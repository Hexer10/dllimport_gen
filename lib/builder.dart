import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/dllimport_generator.dart';

Builder dllImportBuilder(BuilderOptions options) =>
    SharedPartBuilder([DllImportGenerator()], 'dllimport');
