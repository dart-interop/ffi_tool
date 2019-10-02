import 'package:ffi_tool/c.dart';

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

import 'library.dart';
import 'dart:io';

/// Generates [file] by generating C bindings for [library] and running
/// 'dartfmt -w $PATH'.
void generateFile(File file, Library library) {
  final source = library.generateSource();
  file.writeAsStringSync(source);
  _dartFmt(file.path);
}

/// Formats a file with 'dartfmt'
void _dartFmt(String path) {
  final result = Process.runSync("dartfmt", ["-w", path]);
  print(result.stdout);
  print(result.stderr);
}

/// Returns Dart C type for the description type.
///
/// Examples:
///   * "Int32" --> "Int32"
///   * "*CFString" --> "Pointer<CFString>"
///   * "*void" --> "Pointer"
///   * "void" --> "Void"
String toCType(String type) {
  if (type == null) {
    throw ArgumentError.value(type);
  }
  if (type == "*void") {
    return "Pointer";
  }
  if (type == "void") {
    return "Void";
  }
  if (type.startsWith("*")) {
    return "Pointer<${toCType(type.substring(1))}>";
  }
  return type;
}

/// Converts description type to Dart type.
///
/// Examples:
///   * "Int32" --> "int"
///   * "Int64" --> "int"
///   * "*CFString" --> "Pointer<CFString>"
String toDartType(String type) {
  if (type == null) {
    throw ArgumentError.notNull();
  }
  if (type == "*void") {
    return "Pointer";
  }
  if (type.startsWith("*")) {
    return "Pointer<${toCType(type.substring(1))}>";
  }
  const intTypes = {
    "int8",
    "int16",
    "int32",
    "int64",
    "uint8",
    "uint16",
    "uint32",
    "uint64",
    "intptr",
  };
  if (intTypes.contains(type.toLowerCase())) {
    return "int";
  }
  const floatTypes = {
    "float32",
    "float64",
  };
  if (floatTypes.contains(type.toLowerCase())) {
    return "double";
  }
  return type;
}
