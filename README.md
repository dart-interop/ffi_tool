# Overview
<a href="https://github.com/terrier989/zone_local">
 <img alt="GitHub Actions status" src="https://github.com/terrier989/zone_local/workflows/Dart%20CI/badge.svg">
</a>

This library helps developers to generate [dart:ffi](https://dart.dev/guides/libraries/c-interop)
bindings. You can contribute at [github.com/dart-interop/ffi_tool](https://github.com/dart-interop/ffi_tool).

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

## Objective-C library
Objective-C supports reflection so we are able to generate APIs automatically. The generated
libraries use [cupertino_ffi](https://github.com/dart-interop/cupertino_ffi) for reference counting.
Please make sure you understand the reference counting patterns that you need to follow when you
use the generated library.

```dart
import 'package:ffi_tool/objective_c.dart';

void main() {
  generateAll([
    ObjcLibrary(
      productName: "Example",
      uri: "https://github.com/example/project",
      libraryName: "example",
      libraryPath: "/System/Library/Frameworks/CoreML.framework/Versions/Current/CoreML",
      generatedPath: "example.dart",
    ),
  ]);
}
```