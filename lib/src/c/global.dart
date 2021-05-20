// Copyright (c) 2021 ffi_tool authors.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the 'Software'), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
// OR OTHER DEALINGS IN THE SOFTWARE.

import 'library.dart';
import 'dart_source_writer.dart';

/// A definition for a C global.
class Global extends Element {
  final String type;
  const Global(
      {required String name, required this.type, String? documentation})
      : super(name: name, documentation: documentation);

  @override
  void generateInnerSource(DartSourceWriter w, Library library) {
    final dartType = w.getDartType(type);
    w.write('\n');
    if (documentation == null) {
      w.write('/// C global `$name`.\n');
    } else {
      w.write('/// ');
      w.writeAll(documentation!.split('\n'), '\n/// ');
      w.write('\n');
    }
    w.write('final $dartType $name;\n');
  }

  @override
  void generateOuterSource(DartSourceWriter w, Library library) {}

  @override
  bool generateConstructorSource(DartSourceWriter w, Library library) {
    final cType = w.getCType(type);
    w.write('$name = ${Library.dynamicLibraryIdentifier}.lookup<$cType>(\n');
    w.write('  \'$name\',\n');
    w.write(').value\n');
    return true;
  }
}
