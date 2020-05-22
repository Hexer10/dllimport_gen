import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';
import 'mapping.dart';

class DllImportGenerator extends GeneratorForAnnotation<DllImport> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var dll = annotation.read('library').stringValue;
    if (element.kind != ElementKind.CLASS) {
      throw ArgumentError.value(element.kind, 'element.kind',
          'Invalid element kind for DllImport notation, must be a CLASS');
    }

    var dllClass = element as ClassElement;
    if (!dllClass.isAbstract) {
      print('DllImport-ed class should be abstract!');
    }

    var ffiFunctions = <FFIFunction>[];
    for (var method in dllClass.methods) {
      var ffiFunc = FFIFunction();
      var returnTypeC = typeMap[method.returnType.element.name].ffiType;
      if (returnTypeC == null) {
        throw ArgumentError.value('element.name',
            method.returnType.element.name, 'Invalid element name');
      }

      var returnTypeDart = typeMap[returnTypeC].dartType;

      var cParams = method.parameters
          .map((e) =>
              '${getffiType(e.type.element.name)}${getGenericTypes(e.type)} '
              '${e.name}')
          .join(', ');
      var dartParams = method.parameters
          .map((e) =>
              '${getDartType(e.type.element.name)}${getGenericTypes(e.type)} '
              '${e.name}')
          .join(', ');

      ffiFunc.cTypeDef = 'typedef _${method.name}C = $returnTypeC'
          '${getGenericTypes(method.returnType)} Function($cParams);';
      ffiFunc.dartTypeDef = 'typedef _${method.name}Dart = $returnTypeDart'
          '${getGenericTypes(method.returnType)} Function($dartParams);';
      ffiFunc.funcLookup =
          'final _${method.name}Func = _dylib.lookupFunction<_${method.name}C, '
          '_${method.name}Dart>(\'${method.name}\');';
      ffiFunc.funcDecl =
          '$returnTypeDart ${method.name}($dartParams) => _${method.name}'
          'Func(${method.parameters.map((e) => e.name).join(', ')});';

      ffiFunctions.add(ffiFunc);
    }
    var className = 'FFI${element.name}';

    return '''
        ${ffiFunctions.map((e) => '${e.cTypeDef}\n${e.dartTypeDef}').join('\n')}
        class $className {
          static final _dylib = DynamicLibrary.open('$dll');
          static final _instance = $className._();
          
          $className._();
          
          factory $className() => _instance;
          
          ${ffiFunctions.map((e) => e.funcLookup).join('\n')}
          ${ffiFunctions.map((e) => e.funcDecl).join('\n')}

        }
        ''';
  }
}

class FFIFunction {
  String cTypeDef;
  String dartTypeDef;
  String funcLookup;
  String funcDecl;
}

/// Throws if not found
String getffiType(String str) {
  var type = typeMap[str]?.ffiType;
  if (type == null) {
    throw ArgumentError.value(str, 'type', 'Invalid type: $str');
  }
  return type;
}

/// Throws if not found
String getDartType(String str) {
  var type = typeMap[str]?.dartType;
  if (type == null) {
    throw ArgumentError.value(str, 'type', 'Invalid type: $str');
  }
  return type;
}

String getGenericTypes(DartType type) {
  var generics = type is ParameterizedType ? type.typeArguments : const [];
  if (generics.isEmpty) {
    return '';
  }
  return '<${generics.join(', ')}>';
}
