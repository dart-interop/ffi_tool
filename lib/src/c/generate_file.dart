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

import 'dart:io';

import 'library.dart';
import 'dart_source_writer.dart';

/// Generates [file] by generating C bindings for [library].
/// If format is true 'dartfmt -w $PATH' will be run to format the generated file.
void generateFile(File file, Library library, {bool format = true}) {
  final w = DartSourceWriter();
  library.generateSource(w);
  file.writeAsStringSync(w.toString());
  if (format) _dartFmt(file.path);
}

/// Formats a file with 'dartfmt'
void _dartFmt(String path) {
  final result =
      Process.runSync('dartfmt', ['-w', path], runInShell: Platform.isWindows);
  print(result.stdout);
  print(result.stderr);
}
