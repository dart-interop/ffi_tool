import 'package:ffi_tool/c.dart';
import 'package:test/test.dart';

void main() {
  test('Library defaults', () {
    final library = Library(
      dynamicLibraryPath: '',
      elements: [],
    );
    expect(library.dynamicLibraryIdentifier, '_dynamicLibrary');
    expect(library.importedUris, <String>{});
  });

  test('Functions', () {
    final library = Library(
      dynamicLibraryIdentifier: 'dynamicLibraryForExampleLibrary',
      dynamicLibraryPath: 'path/to/library',
      importedUris: [],
      elements: [
        Func(
          name: 'Example',
          parameterTypes: ['Int32', 'Float32', '*void', 'void'],
          returnType: 'ReturnType',
        ),
      ],
    );
    expect(library.toString(), '''
// AUTOMATICALLY GENERATED. DO NOT EDIT.

import 'dart:ffi' as ffi;

/// Dynamic library
final ffi.DynamicLibrary dynamicLibraryForExampleLibrary = ffi.DynamicLibrary.open(
  'path/to/library',
);

/// C function `Example`.
ReturnType Example(
  int arg0,
  double arg1,
  ffi.Pointer arg2,
  void arg3,
) {
  return _Example(arg0, arg1, arg2, arg3);
}
final _Example_Dart _Example = dynamicLibraryForExampleLibrary.lookupFunction<_Example_C, _Example_Dart>(
  'Example',
);
typedef ReturnType _Example_C(
  ffi.Int32 arg0,
  ffi.Float arg1,
  ffi.Pointer arg2,
  ffi.Void arg3,
);
typedef ReturnType _Example_Dart(
  int arg0,
  double arg1,
  ffi.Pointer arg2,
  void arg3,
);
''');
  });

  test('Globals', () {
    final library = Library(
      dynamicLibraryPath: 'path/to/library',
      importedUris: [],
      elements: [
        Global(
          name: 'Global0',
          type: 'Global0Type',
        ),
        Global(
          name: 'Global1',
          type: 'Global1Type',
        ),
      ],
    );
    expect(library.toString(), '''
// AUTOMATICALLY GENERATED. DO NOT EDIT.

import 'dart:ffi' as ffi;

/// Dynamic library
final ffi.DynamicLibrary _dynamicLibrary = ffi.DynamicLibrary.open(
  'path/to/library',
);

/// C global `Global0`.
final Global0Type Global0 = _dynamicLibrary.lookup<Global0Type>(
  'Global0',
).value;

/// C global `Global1`.
final Global1Type Global1 = _dynamicLibrary.lookup<Global1Type>(
  'Global1',
).value;
''');
  });

  test('Structs', () {
    final library = Library(
      dynamicLibraryIdentifier: 'dynamicLibraryForExampleLibrary',
      dynamicLibraryPath: 'path/to/library',
      importedUris: [],
      elements: [
        Struct(
          name: 'Coordinate',
          fields: <Field>[
            Field(type: 'double', name: 'latitude'),
            Field(type: 'double', name: 'longitude')
          ],
        ),
      ],
    );
    expect(library.toString(), '''
// AUTOMATICALLY GENERATED. DO NOT EDIT.

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;

/// Dynamic library
final ffi.DynamicLibrary dynamicLibraryForExampleLibrary = ffi.DynamicLibrary.open(
  'path/to/library',
);

/// C struct `Coordinate`.
class Coordinate extends ffi.Struct {
  
  @ffi.Double()
  double latitude;
  
  @ffi.Double()
  double longitude;
  
  static ffi.Pointer<Coordinate> allocate() {
    return ffi.allocate<Coordinate>();
  }
  
}
''');
  });

  test('ARC', () {
    final library = Library(
      dynamicLibraryPath: 'path/to/library',
      importedUris: [],
      elements: [
        Func(
          name: 'Example',
          parameterTypes: [],
          returnType: '*void',
          arc: true,
        ),
      ],
    );
    expect(library.toString(), '''
// AUTOMATICALLY GENERATED. DO NOT EDIT.

import 'dart:ffi' as ffi;
import 'package:cupertino_ffi/objc.dart' as ffi;

/// Dynamic library
final ffi.DynamicLibrary _dynamicLibrary = ffi.DynamicLibrary.open(
  'path/to/library',
);

/// C function `Example`.
ffi.Pointer Example() {
  final result = _Example();
  arcAdd(result);
  return result;
}
final _Example_Dart _Example = _dynamicLibrary.lookupFunction<_Example_C, _Example_Dart>(
  'Example',
);
typedef ffi.Pointer _Example_C();
typedef ffi.Pointer _Example_Dart();
''');
  });
}
