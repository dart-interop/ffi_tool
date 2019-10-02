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

class Global extends Element {
  final String name;
  final String type;
  const Global({@required this.name, @required this.type});

  @override
  String generateSource(Library library) {
    final sb = StringBuffer();
    final dartType = toDartType(type);
    final cType = toCType(type);
    sb.write("\n");
    sb.write("/// C global '$name'.\n");
    sb.write(
        "final $dartType $name = ${library.dynamicLibraryIdentifier}.lookup<$cType>(\n");
    sb.write("  \"$name\",\n");
    sb.write(").load<$dartType>();\n");
    return sb.toString();
  }
}
