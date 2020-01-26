# Overview
<a href='https://github.com/dart-interop/ffi_tool'>
 <img alt='GitHub Actions status' src='https://github.com/dart-interop/ffi_tool/workflows/Dart%20CI/badge.svg'>
</a>

This library helps developers to generate [dart:ffi](https://dart.dev/guides/libraries/c-interop)
bindings. You can contribute at [github.com/dart-interop/ffi_tool](https://github.com/dart-interop/ffi_tool).

The advantages over handwritten _dart:ffi_ code are:
  * __Less boilerplate__
    * You don't have to define multiple types for each C function.
    * You can require the generated code to use [cupertino_ffi](https://pub.dev/packages/cupertino_ffi)
      reference counting methods (`arcPush`, `arcPop`, `arcReturn`).
  * __Possibly better readability__
    * You can use the original identifiers (such as `*size_t` instead of `Pointer<IntPtr>`).
    * You can define aliases, e.g. `const len_t = 'int32';`.

# Getting started
## 1.Add dependency
In 'pubspec.yaml':
```yaml
dev_dependencies:
  ffi_tool: ^0.1.0
```

Run `pub get`.

## 2.Write a script
Create 'tool/generate_example.dart'.

### Example

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
With Dart SDK:
```
pub run tool/generate_example.dart
```

With Flutter SDK:
```
flutter pub run tool/generate_example.dart
```