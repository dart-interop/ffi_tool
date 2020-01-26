// Copyright (c) 2019 ffi_tool authors.
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

import 'package:ffi_tool/c.dart';
import 'package:meta/meta.dart';

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
///       fields: <Field>[
///         Field(
///           type: 'double',
///           name: 'latitude',
///         ),
///         Field(
///           type: 'double',
///           name: 'longitude',
///         ),
///       ],
///     ),
///   ],
/// );
/// ```
class Struct extends Element {
  final String name;
  final bool arc;
  final List<Field> fields;

  /// Optional comment.
  final String comment;

  /// Optional source injected inside the generated class.
  final String inject;

  const Struct({
    @required this.name,
    this.arc = false,
    @required this.fields,
    this.comment,
    this.inject,
  });

  @override
  void generateSource(DartSourceWriter w, Library library) {
    // 'allocate' requires this package
    w.imports.add(
      const ImportedUri('package:ffi/ffi.dart', prefix: 'ffi'),
    );
    if (arc) {
      w.imports.add(
        const ImportedUri('package:cupertino_ffi/ffi.dart', prefix: 'ffi'),
      );
    }

    w.write('\n');
    if (comment == null) {
      w.write('/// C struct `$name`.\n');
    } else {
      w.write('/// ');
      w.writeAll(comment.split('\n'), '\n/// ');
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
      if (annotationName != null) {
        w.write('  @$annotationName()\n');
      }
      w.write('  ${w.getDartType(field.type)} ${field.name};\n');
      w.write('  \n');
    }

    //
    // Write factory
    //
    w.write('  static ffi.Pointer<$name> allocate() {\n');
    if (arc) {
      w.write('    final result = ffi.allocate<$name>();\n');
      w.write('    ffi.arcAdd(result);\n');
      w.write('    return result;\n');
    } else {
      w.write('    return ffi.allocate<$name>();\n');
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
}

class Field {
  final String name;
  final String type;
  const Field({this.type, this.name});
}
