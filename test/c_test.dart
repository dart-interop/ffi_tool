import 'package:ffi_tool/c.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  test('Library defaults', () {
    final library = Library(
      dynamicLibraryPath: '',
      elements: [],
    );
    expect(library.dynamicLibraryIdentifier, '_dynamicLibrary');
    expect(library.libraryName, isNull);
    expect(library.partOf, isNull);
    expect(library.importedUris, <ImportedUri>{});
    expect(library.parts, <String>{});
  });

  test('Functions', () {
    final library = Library(
      dynamicLibraryIdentifier: 'dynamicLibraryForExampleLibrary',
      dynamicLibraryPath: 'path/to/library',
      elements: [
        Func(
          name: 'Example',
          parameterTypes: ['Int32', 'Float32', '*void', 'void'],
          returnType: '*utf8',
        ),
      ],
    );

    // Generate file so we can see linter warnings
    final file = File('test/generated/example_1.dart');
    generateFile(file, library);

    // Test that we generated something.
    // We don't test the file content we don't have linter version fixed for
    // every developer.
    expect(file.readAsStringSync(), hasLength(greaterThan(100)));

    expect(library.toString(), '''
// AUTOMATICALLY GENERATED. DO NOT EDIT.

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;

/// Dynamic library
final ffi.DynamicLibrary dynamicLibraryForExampleLibrary = ffi.DynamicLibrary.open(
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
final _Example_Dart _Example = dynamicLibraryForExampleLibrary.lookupFunction<_Example_C, _Example_Dart>(
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
''');
  });

  test('Globals', () {
    final library = Library(
      dynamicLibraryPath: 'path/to/library',
      importedUris: {},
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
      elements: [
        Struct(
          name: 'Coordinate',
          fields: <StructField>[
            StructField(type: 'double', name: 'latitude'),
            StructField(type: 'double', name: 'longitude')
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
typedef _Example_C = ffi.Pointer Function();
typedef _Example_Dart = ffi.Pointer Function();
''');
  });

  test('Constants', () {
    final library = Library(
      dynamicLibraryPath: 'path/to/library',
      importedUris: {},
      elements: [
        Constant(
            name: 'a',
            type: 'int',
            value: '10',
            documentation: 'test doc line 1\ntest doc line 2'),
        Constant(
          name: 'b',
          type: 'String',
          value: '"test string"',
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

/// test doc line 1
/// test doc line 2
const int a = 10;

const String b = "test string";
''');
  });

  test('GroupedConstants', () {
    final library = Library(
      dynamicLibraryPath: 'path/to/library',
      importedUris: {},
      elements: [
        GroupedConstants(
          name: 'Constants',
          documentation: 'test line 1\ntest line 2',
          constants: [
            Constant(
                name: 'a',
                type: 'int',
                value: '10',
                documentation: 'test doc line 1\ntest doc line 2'),
            Constant(
              name: 'b',
              type: 'String',
              value: '"test string"',
            ),
          ],
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

/// test line 1
/// test line 2
class Constants {

  /// test doc line 1
  /// test doc line 2
  static const int a = 10;

  static const String b = "test string";
}
''');
  });
}
