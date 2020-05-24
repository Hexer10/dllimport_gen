import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/output_helpers.dart'; // ignore: implementation_imports

import '../annotations.dart';
import 'mapping.dart';

class DllImportGenerator extends Generator {
  const DllImportGenerator();

  TypeChecker get dllImportType => TypeChecker.fromRuntime(DllImport);

  TypeChecker get importType => TypeChecker.fromRuntime(Import);

  dynamic generateForAnnotatedElement(Element element,
      ConstantReader annotation, BuildStep buildStep, LibraryReader library) {
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
      var elementName = method.returnType.element.name;

      var returnTypeC = getffiType(elementName);
      var returnTypeDart = getDartType(elementName);

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
      ffiFunc.funcLookup = 'Function get _${method.name}Func => '
          '_dylib.lookupFunction<_${method.name}C, '
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
          final DynamicLibrary _dylib;
          static final _instance = $className._();
          
          $className._() : _dylib = DynamicLibrary.open('$dll');
          
          factory $className() => _instance;
          
          ${ffiFunctions.map((e) => e.funcLookup).join('\n')}
          ${ffiFunctions.map((e) => e.funcDecl).join('\n')}

        }
        ''';
  }

  // Override to implement the @Import annotation
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final values = <String>{};
    final imports = <String>{};

    for (var annotatedElement in library.annotatedWith(importType)) {
      var path = annotatedElement.annotation.read('path').stringValue;
      assert(path != null);
      imports.add('import \'$path\';');
    }

    for (var annotatedElement in library.annotatedWith(dllImportType)) {
      final generatedValue = generateForAnnotatedElement(
          annotatedElement.element,
          annotatedElement.annotation,
          buildStep,
          library);
      await for (var value in normalizeGeneratorOutput(generatedValue)) {
        assert(value == null || (value.length == value.trim().length));
        values.add(value);
      }
    }

    // ignore: prefer_interpolation_to_compose_strings
    return imports.join('') + '\n' + values.join('\n\n');
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
    throw ArgumentError.value(str, 'type');
  }
  return type;
}

/// Throws if not found
String getDartType(String str) {
  var type = typeMap[str]?.dartType;
  if (type == null) {
    throw ArgumentError.value(str, 'type');
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
