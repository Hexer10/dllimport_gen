class Mapping {
  final String ffiType;
  final String dartType;

  Mapping(this.ffiType, this.dartType);
}

Map<String, Mapping> typeMap = {
  /* WINAPI TYPES */
  'BOOL': Mapping('Uint8', 'int'),
  'int': Mapping('Uint32', 'int'),
  'HWND': Mapping('Pointer', 'Pointer'),
  'HDESK': Mapping('Pointer', 'Pointer'),
  'LPARAM': Mapping('Pointer<Int64>', 'Pointer<Int64>'),
  'WPARAM': Mapping('Pointer<Uint64>', 'Pointer<Uint64>'),
  'LPSTR': Mapping('Pointer', 'Pointer'),
  'HICON': Mapping('Pointer', 'Pointer'),
  'LPWSTR': Mapping('Pointer', 'Pointer'),
  'LPCWSTR': Mapping('Pointer', 'Pointer'),
  'WINSTAENUMPROCA': Mapping('Pointer', 'Pointer'),
  'DWORD': Mapping('Uint32', 'int'),
  'ACCESS_MASK': Mapping('Uint32', 'int'),
  'HANDLE': Mapping('Pointer', 'Pointer'),
  'HMODULE': Mapping('Pointer', 'Pointer'),
  'LPDWORD': Mapping('Pointer<Uint32>', 'Pointer<Uint32>'),
  'LONG': Mapping('Int64', 'int'),
  'HMENU': Mapping('Pointer', 'Pointer'),
  'HINSTANCE': Mapping('Pointer', 'Pointer'),
  'LPVOID': Mapping('Pointer', 'Pointer'),
  'LPTSTR': Mapping('Pointer', 'Pointer'),
  'LRESULT': Mapping('Pointer', 'Pointer'),
  'UINT': Mapping('Uint32', 'int'),
  'void': Mapping('Void', 'void'),
  'BYTE': Mapping('Uint8', 'int'),
  'ULONG_PTR': Mapping('Pointer', 'Pointer'),
  'LPINPUT': Mapping('Pointer', 'Pointer'),
  'HHOOK': Mapping('Pointer', 'Pointer'),
  'HOOKPROC': Mapping('Pointer', 'Pointer'),
  'LPMSG': Mapping('Pointer', 'Pointer'),
  'LPCSTR': Mapping('Pointer', 'Pointer'),

  /* DART FFI TYPES*/
  'Int8': Mapping('Int8', 'int'),
  'Int16': Mapping('Int16', 'int'),
  'Int32': Mapping('Int32', 'int'),
  'Int64': Mapping('Int64', 'int'),
  'Uint8': Mapping('Uint8', 'int'),
  'Uint16': Mapping('Uint16', 'int'),
  'Uint32': Mapping('Uint32', 'int'),
  'Uint64': Mapping('Uint64', 'int'),
  'Float': Mapping('Float', 'double'),
  'Double': Mapping('Double', 'double'),
  'Void': Mapping('Void', 'void'),
  'Pointer': Mapping('Pointer', 'Pointer'),
  'NativeType': Mapping('NativeType', 'NativeType'),
};
