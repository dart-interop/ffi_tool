import 'package:ffi_tool/c.dart';
import 'package:test/test.dart';

void main() {
  test("Func example #1", () {
    final library = Library(
      dynamicLibraryIdentifier: "dlForExampleLibrary",
      dynamicLibraryPath: "path/to/library",
      importedUris: [],
      elements: [
        Func(
          name: "Example",
          parameterTypes: ["Int32", "Floa64", "*void", "void"],
          returnType: "ReturnType",
        ),
      ],
    );
    expect(library.generateSource(), """
// AUTOMATICALLY GENERATED. DO NOT EDIT.
import \'dart:ffi\';

/// Dynamic library
final DynamicLibrary dlForExampleLibrary = DynamicLibrary.open(
  "path/to/library",
);

/// C function \'Example\'.
ReturnType Example(
  int arg0,
  Floa64 arg1,
  Pointer arg2,
  void arg3,
) {
  return _Example(arg0, arg1, arg2, arg3);
}
final _Example_Dart _Example = dlForExampleLibrary.lookupFunction<_Example_C, _Example_Dart>(
  "Example",
);
typedef ReturnType _Example_C(
  Int32 arg0,
  Floa64 arg1,
  Pointer arg2,
  Void arg3,
);
typedef ReturnType _Example_Dart(
  int arg0,
  Floa64 arg1,
  Pointer arg2,
  void arg3,
);
""");
  });

  test("Global example #1", () {
    final library = Library(
      dynamicLibraryIdentifier: "dlForExampleLibrary",
      dynamicLibraryPath: "path/to/library",
      importedUris: [],
      elements: [
        Global(
          name: "Global0",
          type: "Global0Type",
        ),
        Global(
          name: "Global1",
          type: "Global1Type",
        ),
      ],
    );
    expect(library.generateSource(), """
// AUTOMATICALLY GENERATED. DO NOT EDIT.
import \'dart:ffi\';

/// Dynamic library
final DynamicLibrary dlForExampleLibrary = DynamicLibrary.open(
  "path/to/library",
);

/// C global \'Global0\'.
final Global0Type Global0 = dlForExampleLibrary.lookup<Global0Type>(
  "Global0",
).load<Global0Type>();

/// C global \'Global1\'.
final Global1Type Global1 = dlForExampleLibrary.lookup<Global1Type>(
  "Global1",
).load<Global1Type>();
""");
  });
}
