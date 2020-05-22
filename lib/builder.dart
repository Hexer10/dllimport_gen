import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/dllimport_generator.dart';

Builder dllImportBuilder(BuilderOptions options) =>
    LibraryBuilder(DllImportGenerator(),
        generatedExtension: '.ffi.g.dart',
        header: '$defaultFileHeader\nimport \'dart:ffi\';');
