// Copyright (c) 2021 ffi_tool authors.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
// OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart_source_writer.dart';
import 'library.dart';

/// A definition for a C struct.
///
/// ```dart
/// import 'package:ffi_tool/c.dart';
/// import 'dart:io';
///
/// void main() {
///   generateFile(File("generated.dart"), library);
/// }
///
/// const library = Library(
///   dynamicLibraryPath: "path/to/library",
///
///   elements: [
///     Struct(
///       name: "Coordinate",
///       fields: <StructField>[
///         StructField(
///           type: 'double',
///           name: 'latitude',
///         ),
///         StructField(
///           type: 'double',
///           name: 'longitude',
///         ),
///       ],
///     ),
///   ],
/// );
/// ```
class Struct extends Element {
  final bool arc;
  final List<StructField> fields;

  /// Optional source injected inside the generated class.
  final String? inject;

  const Struct({
    required String name,
    this.arc = false,
    required this.fields,
    String? documentation,
    this.inject,
  }) : super(name: name, documentation: documentation);

  @override
  void generateOuterSource(DartSourceWriter w, Library library) {
    if (fields.isEmpty) {
      throw Exception(
          'Structs may no longer by empty and must contain at least one field! Consider using a Opaque instead!');
    }
    if (arc) {
      w.imports.add(
        const ImportedUri('package:cupertino_ffi/ffi.dart', prefix: 'ffi'),
      );
    }

    w.write('\n');
    if (documentation == null) {
      w.write('/// C struct `$name`.\n');
    } else {
      w.write('/// ');
      w.writeAll(documentation!.split('\n'), '\n/// ');
      w.write('\n');
    }
    w.write('class $name extends ffi.Struct {\n');
    w.write('  \n');

    //
    // Write fields
    //
    for (var field in fields) {
      // Some types (Int32, Float32, etc.) need to be annotated
      final annotationName = w.getPropertyAnnotationType(field.type);
      if (annotationName != null && annotationName != 'ffi.Pointer') {
        w.write('  @$annotationName()\n');
      }
      w.write('  ${w.getDartType(field.type)} ${field.name};\n');
      w.write('  \n');
    }

    //
    // Write factory
    //
    w.write(
        '  static ffi.Pointer<$name> allocate(ffi.Allocator allocator) {\n');
    if (arc) {
      w.write(
          '    final result = allocator.allocate<$name>(ffi.sizeOf<$name>());\n');
      w.write('    ffi.arcAdd(result);\n');
      w.write('    return result;\n');
    } else {
      w.write('    return allocator.allocate<$name>(ffi.sizeOf<$name>());\n');
    }
    w.write('  }\n');
    w.write('  \n');

    //
    // Write injected source
    //
    final inject = this.inject;
    if (inject != null) {
      w.write(inject);
    }

    w.write('}\n');
  }

  @override
  void generateInnerSource(DartSourceWriter w, Library library) {}

  @override
  bool generateConstructorSource(DartSourceWriter w, Library library) => false;
}

class StructField {
  final String name;
  final String type;
  const StructField({required this.type, required this.name});
}
