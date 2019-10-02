import 'package:ffi_tool/c.dart';
import 'dart:io';

void main() {
  generateFile(File("generated.dart"), library);
}

final library = Library(
  dynamicLibraryIdentifier: "dlForExampleLibrary",
  dynamicLibraryPath: "path/to/library",
  importedUris: [
    "package:ffi/ffi.dart",
  ],
  elements: [
    // A function
    Func(
      name: "Example",
      parameterTypes: ["Int32", "Floa64", "*void", "void"],
      returnType: "ReturnType",
    ),

    // A global
    Global(
      name: "ExampleGlobal",
      type: "Int32",
    ),
  ],
);
