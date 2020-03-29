import 'package:ffi_tool/c.dart';
import 'dart:io';

void main() {
  generateFile(File('generated.dart'), library);
}

final library = Library(
  dynamicLibraryPath: DynamicLibraryConfig(
      windows: DynamicLibraryPlatformConfig(
          creationMode: DynamicLibraryCreationMode.open,
          path: 'path/to/library.dll'),
      android: DynamicLibraryPlatformConfig(
          creationMode: DynamicLibraryCreationMode.open,
          path: 'path/to/library.so'),
      iOS: DynamicLibraryPlatformConfig(
          creationMode: DynamicLibraryCreationMode.process)),
  elements: [
    // A function
    Func(
      name: 'Example',
      parameterTypes: ['int32', 'float64', '*void'],
      returnType: 'void',
    ),

    // A global
    Global(
      name: 'ExampleGlobal',
      type: 'int32',
    ),
  ],
);
