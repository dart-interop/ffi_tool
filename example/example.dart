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
      documentation: 'Takes parameters and does stuff.',
      parameterTypes: ['int32', 'float64', '*void'],
      returnType: 'void',
    ),

    // A global
    Global(
      name: 'ExampleGlobal',
      type: 'int32',
    ),

    // A Struct
    Struct(
      name: 'ExampleStruct',
      fields: [
        StructField(
          name: 'exampleInt',
          type: 'int32'
        ),
      ]
    ),

    // A constant
    Constant(
      name: 'exampleConstant',
      type: 'int',
      value: '10',
      documentation: 'A constant',
    ),

    // A group of constants
    GroupedConstants(
      name: 'ExampleConstantGroup',
      documentation: 'Just an Example of using GroupedConstants',
      constants: [
        Constant(
          name: 'exampleintConstant',
          type: 'double',
          value: '10.2',
        ),
        Constant(
          name: 'exampleStringConstant',
          type: 'String',
          value: '"example string"',
        ),
      ],
    ),
  ],
);
