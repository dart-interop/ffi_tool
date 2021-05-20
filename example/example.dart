import 'package:ffi_tool/c.dart';
import 'dart:io';

void main() {
  // Generates source code and runs 'dartfmt'
  generateFile(File('generated.dart'), library);
}

final library = Library.platformAware(
  // Configure, how the dynamic library should be loaded depending on the platform
  dynamicLibraryConfig: DynamicLibraryConfig(
      windows: DynamicLibraryPlatformConfig.open('path/to/library.dll'),
      android: DynamicLibraryPlatformConfig.open('path/to/library.so'),
      iOS: DynamicLibraryPlatformConfig.process()),

  // Optional library preamble
  preamble:
      '// Licensed under MIT license\r\n// AUTOMATICALLY GENERATED. DO NOT EDIT.',

  // Optional imports
  importedUris: {
    ImportedUri('package:example/library.dart'),
  },

  /// List of generated functions, structs, and global variables
  elements: <Element>[
    // A definition for a function in C
    Func(
      name: 'Example',
      documentation: 'Takes parameters and does stuff.',
      parameterTypes: ['int32', 'float32', '*void'],
      returnType: 'void',
    ),

    // A definition for a struct in C
    // structs must at lease have one field, for
    // structs without fields use Opaque
    Struct(
      name: 'ExampleStruct',
      fields: [
        StructField(
          name: 'length',
          type: 'size_t',
        ),
      ],
    ),

    // Opaque structs are structs without fields
    Opaque(name: 'ExampleOpaqueStruct'),

    // A definition for a global variable in C
    Global(
      name: 'ExampleGlobal',
      type: 'Int32',
    ),
  ],
);
