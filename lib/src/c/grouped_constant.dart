// Copyright (c) 2020 ffi_tool authors.
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

import 'package:ffi_tool/src/c/constant.dart';
import 'package:meta/meta.dart';

import 'library.dart';
import 'dart_source_writer.dart';

/// Group of constants (wrapped in a class)
///
/// Expands to (example)
/// ```dart
/// class SomeName {
///   static const int a = 10;
///   static const String b = "hello";
/// }
/// ```
class GroupedConstants extends Element {
  final List<Constant> constants;

  const GroupedConstants(
      {@required String name, @required this.constants, String documentation})
      : super(name: name, documentation: documentation);

  @override
  void generateSource(DartSourceWriter w, Library library) {
    w.write('\n');
    if (documentation != null) {
      w.write('/// ');
      w.writeAll(documentation.split('\n'), '\n/// ');
      w.write('\n');
    }
    w.write('class $name {\n');
    for (var constant in constants) {
      w.write('\n');
      var depth = '  ';
      if (constant.documentation != null) {
        w.write(depth + '/// ');
        w.writeAll(constant.documentation.split('\n'), '\n' + depth + '/// ');
        w.write('\n');
      }
      w.write(
          depth + 'static const ${constant.type} ${constant.name} = ${constant.value};\n');
    }
    w.write('}\n');
  }
}
