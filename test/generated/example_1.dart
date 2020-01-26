// AUTOMATICALLY GENERATED. DO NOT EDIT.

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;

/// Dynamic library
final ffi.DynamicLibrary dynamicLibraryForExampleLibrary =
    ffi.DynamicLibrary.open(
  'path/to/library',
);

/// C function `Example`.
ffi.Pointer<ffi.Utf8> Example(
  int arg0,
  double arg1,
  ffi.Pointer arg2,
  void arg3,
) {
  return _Example(arg0, arg1, arg2, arg3);
}

final _Example_Dart _Example =
    dynamicLibraryForExampleLibrary.lookupFunction<_Example_C, _Example_Dart>(
  'Example',
);
typedef _Example_C = ffi.Pointer<ffi.Utf8> Function(
  ffi.Int32 arg0,
  ffi.Float arg1,
  ffi.Pointer arg2,
  ffi.Void arg3,
);
typedef _Example_Dart = ffi.Pointer<ffi.Utf8> Function(
  int arg0,
  double arg1,
  ffi.Pointer arg2,
  void arg3,
);
