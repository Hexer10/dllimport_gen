/// DllImport annotation.
class DllImport {
  /// Shared library name.
  final String library;

  const DllImport(this.library);
}

/// Import custom Struct libraries.
class Import {
  /// Dart library location.
  final String path;

  const Import(this.path);
}
