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

import 'package:meta/meta.dart';

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
///     Opaque(
///       name: "StructWithoutContent"
///     ),
///   ],
/// );
/// ```
class Opaque extends Element {
  /// Optional source injected inside the generated class.
  final String inject;

  const Opaque({
    @required String name,
    String documentation,
    this.inject,
  }) : super(name: name, documentation: documentation);

  @override
  void generateSource(DartSourceWriter w, Library library) {
    w.write('\n');
    if (documentation == null) {
      w.write('/// C opaque struct `$name`.\n');
    } else {
      w.write('/// ');
      w.writeAll(documentation.split('\n'), '\n/// ');
      w.write('\n');
    }

    //
    // Write injected source if any or just generate class
    //
    final inject = this.inject;
    if (inject != null) {
      w.write('class $name extends ffi.Opaque {');
      w.write('  \n');
      w.write(inject);
      w.write('}\n');
    } else {
      w.write('class $name extends ffi.Opaque {}\n');
    }
  }
}
