// GENERATED CODE - DO NOT MODIFY BY HAND
import 'dart:ffi';

// **************************************************************************
// DllImportGenerator
// **************************************************************************

typedef _SetCursorPosC = Uint8 Function(Uint32 X, Uint32 Y);
typedef _SetCursorPosDart = int Function(int X, int Y);

class FFIUser32 {
  final DynamicLibrary _dylib;
  static final _instance = FFIUser32._();

  FFIUser32._() : _dylib = DynamicLibrary.open('user32.dll');

  factory FFIUser32() => _instance;

  Function get _SetCursorPosFunc =>
      _dylib.lookupFunction<_SetCursorPosC, _SetCursorPosDart>('SetCursorPos');
  int SetCursorPos(int X, int Y) => _SetCursorPosFunc(X, Y);
}

typedef _GetLastErrorC = Uint32 Function();
typedef _GetLastErrorDart = int Function();

class FFIKernel32 {
  final DynamicLibrary _dylib;
  static final _instance = FFIKernel32._();

  FFIKernel32._() : _dylib = DynamicLibrary.open('kernel32.dll');

  factory FFIKernel32() => _instance;

  Function get _GetLastErrorFunc =>
      _dylib.lookupFunction<_GetLastErrorC, _GetLastErrorDart>('GetLastError');
  int GetLastError() => _GetLastErrorFunc();
}
