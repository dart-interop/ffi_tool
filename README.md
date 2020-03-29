# Overview
[![Pub Package](https://img.shields.io/pub/v/ffi_tool.svg)](https://pub.dartlang.org/packages/ffi_tool)
[![Github Actions CI](https://github.com/dart-interop/ffi_tool/workflows/Dart%20CI/badge.svg)](https://github.com/dart-interop/ffi_tool/actions?query=workflow%3A%22Dart+CI%22)
[![Build Status](https://travis-ci.org/dart-interop/ffi_tool.svg?branch=master)](https://travis-ci.org/dart-interop/ffi_tool)

This is a simple package for generating [dart:ffi](https://dart.dev/guides/libraries/c-interop) bindings.

You can contribute at [github.com/dart-interop/ffi_tool](https://github.com/dart-interop/ffi_tool).

The advantages over handwritten _dart:ffi_ code are:
  * __Less boilerplate__
    * You don't have to define multiple types for each C function.
    * You can require the generated code to use [cupertino_ffi](https://pub.dev/packages/cupertino_ffi)
      reference counting methods (`arcPush`, `arcPop`, `arcReturn`).
  * __Source code readability__
    * You can use the original identifiers (such as `*size_t` instead of `Pointer<IntPtr>`).
    * You can define aliases, e.g. `const len_t = 'int32';`.

# Getting started
## 1.Add dependency
In _pubspec.yaml_:

```yaml
dev_dependencies:
  ffi_tool: ^0.2.5
```

Run `pub get`.

## 2.Write a script
Create _tool/generate_example.dart_:

```dart
import 'package:ffi_tool/c.dart';
import 'dart:io';

void main() {
  // Generates source code and runs 'dartfmt'
  generateFile(File('lib/src/generated.dart'), library);
}

final library = const Library(
  // Where the library is found?
  dynamicLibraryPath: 'path/to/library',

  // Optional imports
  importedUris: {
    'package:example/library.dart',
  },

  /// List of generated functions, structs, and global variables
  elements: <Element>[
    // A definition for a function in C
    Func(
      name: 'Example',
      parameterTypes: ['int32', 'float32', '*void'],
      returnType: 'void',
    ),

    // A definition for a struct in C
    Struct(
      name: 'ExampleStruct',
      fields: [
        Field(
          name: 'length',
          type: 'size_t',
        ),
      ],
    ),

    // A definition for a global variable in C
    Global(
      name: 'ExampleGlobal',
      type: 'Int32',
    ),
  ],
);
```

## 3.Run the script
If you use Dart SDK, run:
```
pub run tool/generate_example.dart
```

If you use Flutter SDK, run:
```
flutter pub run tool/generate_example.dart
```
