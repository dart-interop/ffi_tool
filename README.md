# Overview
[![Pub Package](https://img.shields.io/pub/v/ffi_tool.svg)](https://pub.dartlang.org/packages/ffi_tool)
[![GitHub Actions status](https://github.com/dart-interop/ffi_tool/workflows/Dart%20CI/badge.svg)](https://github.com/dart-interop/ffi_tool)

This library helps developers to generate [dart:ffi](https://dart.dev/guides/libraries/c-interop)
bindings.

When you generate bindings for an iOS / Mac OS X library that uses the reference counting, the
generated bindings will use [cupertino_ffi](https://github.com/dart-interop/cupertino_ffi).

## Contributing
  * Create a pull request in [github.com/dart-interop/ffi_tool](https://github.com/dart-interop/ffi_tool).
  * You can also get Github push/admin permits by creating an issue.

# Getting started
## Add dependency
In "pubspec.yaml":
```yaml
dev_dependencies:
  ffi_tool: ^0.1.0
```

Run `pub get`.

## Write a script
Create a generator script in some file (example: "tool/generate_ffi.dart"):

```dart
import 'package:ffi_tool/c.dart';
import 'dart:io';

void main() {
  generateFile(File("lib/src/generated.dart"), library);
}

final library = Library(
  dynamicLibraryIdentifier: "dlForExampleLibrary",
  dynamicLibraryPath: "path/to/library",
  importedUris: [
    "package:ffi/ffi.dart",
  ],
  elements: <Element>[
    // C function
    Func(
      name: "Example",
      parameterTypes: ["Int32", "Floa64", "*void", "void"],
      returnType: "ReturnType",
    ),

    // C global variable
    Global(
      name: "ExampleGlobal",
      type: "Int32",
    ),
  ],
);
```

## Run it
```
pub run tool/generate_ffi.dart
```