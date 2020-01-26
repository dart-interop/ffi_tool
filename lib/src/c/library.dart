// Copyright (c) 2019 ffi_tool authors.
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

import 'package:ffi_tool/c.dart';
import 'package:meta/meta.dart';

/// A definition for a C library.
class Library {
  final String dynamicLibraryIdentifier;
  final String dynamicLibraryPath;

  /// Optional 'library' directive in the generated file.
  final String libraryName;

  /// Optional 'part of' directive in the generated file.
  final String partOf;

  /// Optional imported URIs.
  final Set<ImportedUri> importedUris;

  /// Optional 'part' directives in the generated file.
  final Set<String> parts;

  /// Elements.
  final List<Element> elements;

  const Library({
    @required this.dynamicLibraryPath,
    @required this.elements,
    this.libraryName,
    this.partOf,
    this.importedUris = const {},
    this.parts = const {},
    this.dynamicLibraryIdentifier = '_dynamicLibrary',
  });

  void generateSource(DartSourceWriter w) {
    w.libraryName = libraryName;
    w.partOf = partOf;

    // Imports
    w.imports.add(const ImportedUri('dart:ffi', prefix: 'ffi'));
    w.imports.addAll(importedUris);

    // Parts
    w.parts.addAll(parts);

    // Parts
    if (parts.isNotEmpty) {
      w.write('\n');
      for (var part in parts) {
        w.write("part '$part';\n");
      }
      w.write('\n');
    }
    w.write('/// Dynamic library\n');
    w.write(
        'final ffi.DynamicLibrary ${dynamicLibraryIdentifier} = ffi.DynamicLibrary.open(\n');
    w.write('  \'${dynamicLibraryPath}\',\n');
    w.write(');\n');
    for (var element in elements) {
      element.generateSource(w, this);
    }
  }

  @override
  String toString() {
    final w = DartSourceWriter();
    generateSource(w);
    return w.toString();
  }
}

abstract class Element {
  const Element();

  void generateSource(DartSourceWriter w, Library library);
}
