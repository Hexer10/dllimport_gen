import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

var input = '''
    class CustomClass {
    
    }
    
    var c = CustomClass();
    ''';

void main() {
  var o = parseString(content: input);
  AstNode n = o.unit;

  for (var value in n.childEntities) {}
}
