import 'package:dllimport_gen/dll_import.dart';

import 'example.ffi.g.dart';

@DllImport('user32.dll')
abstract class User32 {
  /// https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setcursorposnon_constant_identifier_names
  BOOL SetCursorPos(int X, int Y);
}

@DllImport('kernel32.dll')
abstract class Kernel32 {
  /// https://docs.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-getlasterror
  DWORD GetLastError();
}

void main() {
  var user32 = FFIUser32();
  var kernel = FFIKernel32();
  var success = user32.SetCursorPos(0, 0) != 0;
  if (!success) {
    print('Failed: ${kernel.GetLastError()}');
  }
}
