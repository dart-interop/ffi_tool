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

class Func extends Element {
  /// Name of the function
  final String name;

  /// Parameter types.
  final List<String> parameterTypes;

  /// Parameter names.
  final List<String> parameterNames;

  /// Parameters.
  List<Parameter> get parameters => List<Parameter>.generate(
        parameterTypes.length,
        (i) {
          final type = parameterTypes[i];
          final name = (parameterNames != null && i < parameterNames.length)
              ? parameterNames[i]
              : "arg$i";
          return Parameter(type: type, name: name);
        },
      );

  /// Return type.
  ///
  /// Examples:
  ///   * "void"
  ///   * "*CFData".
  final String returnType;

  /// Whether the return value should use reference counting?
  ///
  /// Reference counting is defined for Apple libraries only and uses
  /// [cupertino_ffi](https://pub.dev/packages/cupertino_ffi).
  final bool arc;

  Func({
    @required this.name,
    @required this.parameterTypes,
    this.parameterNames,
    @required this.returnType,
    this.arc = false,
  });

  String generateSource(Library library) {
    final sb = StringBuffer();
    final typedefC = "_${name}_C";
    final typedefDart = "_${name}_Dart";
    sb.write("\n");

    // Lookup
    sb.write("/// C function '$name'.\n");
    sb.write("${toDartType(returnType)} $name(\n");
    for (var parameter in parameters) {
      sb.write("  ${toDartType(parameter.type)} ${parameter.name},\n");
    }
    sb.write(") {\n");
    if (arc) {
      sb.write("  final _result = ");
    } else {
      sb.write("  return ");
    }
    sb.write("_$name(");
    for (var i = 0; i < parameters.length; i++) {
      if (i > 0) {
        sb.write(", ");
      }
      sb.write(parameters[i].name);
    }
    sb.write(");\n");
    if (arc) {
      sb.write("  arcAdd(_result);\n");
      sb.write("  return _result;\n");
    }
    sb.write("}\n");
    sb.write("final $typedefDart _$name = ");
    sb.write(
        "${library.dynamicLibraryIdentifier}.lookupFunction<$typedefC, $typedefDart>(\n");
    sb.write("  \"$name\",\n");
    sb.write(");\n");

    // C type
    {
      sb.write("typedef ${toCType(returnType)} $typedefC(");
      if (parameters.isNotEmpty) {
        sb.write("\n");
        for (var parameter in parameters) {
          sb.write("  ${toCType(parameter.type)} ${parameter.name},\n");
        }
      }
      sb.write(");\n");
    }

    // Dart type
    {
      sb.write("typedef ${toDartType(returnType)} $typedefDart(");
      if (parameters.isNotEmpty) {
        sb.write("\n");
        for (var parameter in parameters) {
          sb.write("  ${toDartType(parameter.type)} ${parameter.name},\n");
        }
      }
      sb.write(");\n");
    }
    return sb.toString();
  }
}

class Parameter {
  final String name;
  final String type;
  const Parameter({
    this.type,
    this.name,
  });
}
