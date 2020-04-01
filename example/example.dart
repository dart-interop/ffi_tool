import 'package:ffi_tool/c.dart';
import 'dart:io';

void main() {
  generateFile(File('generated.dart'), library);
}

final library = const Library.platformAware(
  // Configure, how the dynamic library should be loaded depending on the platform
  dynamicLibraryConfig: DynamicLibraryConfig(
      windows: DynamicLibraryPlatformConfig.open('path/to/library.dll'),
      android: DynamicLibraryPlatformConfig.open('path/to/library.so'),
      iOS: DynamicLibraryPlatformConfig.process()),

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
