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

class Library {
  final List<String> importedUris;
  final String dynamicLibraryIdentifier;
  final String dynamicLibraryPath;
  final List<Element> elements;

  Library({
    @required this.importedUris,
    @required this.dynamicLibraryIdentifier,
    @required this.dynamicLibraryPath,
    @required this.elements,
  });

  String generateSource() {
    final sb = StringBuffer();
    sb.write("// AUTOMATICALLY GENERATED. DO NOT EDIT.\n");
    final imports = ({"dart:ffi"}..addAll(importedUris)).toList()..sort();
    for (var uri in imports) {
      sb.write("import '$uri';\n");
    }
    sb.write("\n");
    sb.write("/// Dynamic library\n");
    sb.write(
        "final DynamicLibrary ${dynamicLibraryIdentifier} = DynamicLibrary.open(\n");
    sb.write("  \"${dynamicLibraryPath}\",\n");
    sb.write(");\n");
    for (var element in elements) {
      sb.write(element.generateSource(this));
    }
    return sb.toString();
  }
}

abstract class Element {
  const Element();

  String generateSource(Library library);
}
