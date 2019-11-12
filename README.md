# Overview
<a href="https://github.com/terrier989/zone_local">
 <img alt="GitHub Actions status" src="https://github.com/terrier989/zone_local/workflows/Dart%20CI/badge.svg">
</a>

This library helps developers to generate [dart:ffi](https://dart.dev/guides/libraries/c-interop)
bindings. You can contribute at [github.com/dart-interop/ffi_tool](https://github.com/dart-interop/ffi_tool).

The advantages of using this package (instead of writing hand-written code) are:
  * Often less boilerplate
  * Often more readable (e.g. "*void" instead of "Pointer<Void>")
  * Support for Apple's ARC

# Getting started
In "pubspec.yaml", add:
```yaml
dev_dependencies:
  ffi_tool: ^0.1.0
```

Run `pub get`.

You have to write a generator script (see examples below) in some file. For example,
"tool/generate_example.dart".

Run the script with `pub run tool/generate_example.dart`.

# Generator scripts
## C library

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
      parameterTypes: ["int32", "float64", "*void"],
      returnType: "void",
    ),

    // C global variable
    Global(
      name: "ExampleGlobal",
      type: "Int32",
    ),
  ],
);
```