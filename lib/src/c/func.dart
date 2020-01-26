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

/// A definition for C function.
class Func extends Element {
  /// Name of the function
  final String name;

  /// Parameter types.
  final List<String> parameterTypes;

  /// Parameter names.
  List<String> get parameterNames => parameters.map((p) => p.name).toList();

  final List<String> _parameterNames;

  /// Parameters.
  List<Parameter> get parameters => List<Parameter>.generate(
        parameterTypes.length,
        (i) {
          final type = parameterTypes[i];
          final name = (_parameterNames != null && i < _parameterNames.length)
              ? _parameterNames[i]
              : 'arg$i';
          return Parameter(type: type, name: name);
        },
      );

  /// Return type.
  ///
  /// Examples:
  ///   * 'void'
  ///   * '*CFData'.
  final String returnType;

  /// Whether the return value should use Apple reference counting? The
  /// implementation uses [cupertino_ffi](https://pub.dev/packages/cupertino_ffi).
  final bool arc;

  const Func({
    @required this.name,
    @required this.parameterTypes,
    List<String> parameterNames,
    @required this.returnType,
    this.arc = false,
  }) : this._parameterNames = parameterNames;

  @override
  void generateSource(DartSourceWriter w, Library library) {
    if (arc) {
      w.imports.add(
        const Import('package:cupertino_ffi/objc.dart', prefix: 'ffi'),
      );
    }
    final typedefC = '_${name}_C';
    final typedefDart = '_${name}_Dart';
    w.write('\n');

    // Lookup
    w.write('/// C function `$name`.\n');
    w.write('${w.getDartType(returnType)} $name(');
    if (parameters.isNotEmpty) {
      w.write('\n');
      for (var parameter in parameters) {
        w.write('  ${w.getDartType(parameter.type)} ${parameter.name},\n');
      }
    }
    w.write(') {\n');
    if (w.getDartType(returnType) == 'void') {
      w.write('_$name(');
      w.writeAll(parameterNames, ', ');
      w.write(');\n');
    } else {
      if (arc && returnType.startsWith('*')) {
        w.write('  final result = ');
        w.write('_$name(');
        w.writeAll(parameterNames, ', ');
        w.write(');\n');
        w.write('  arcAdd(result);\n');
        w.write('  return result;\n');
      } else {
        w.write('  return ');
        w.write('_$name(');
        w.writeAll(parameterNames, ', ');
        w.write(');\n');
      }
    }
    w.write('}\n');
    w.write('final $typedefDart _$name = ');
    w.write(
        '${library.dynamicLibraryIdentifier}.lookupFunction<$typedefC, $typedefDart>(\n');
    w.write('  \'$name\',\n');
    w.write(');\n');

    // C type
    {
      w.write('typedef ${w.getCType(returnType)} $typedefC(');
      if (parameters.isNotEmpty) {
        w.write('\n');
        for (var parameter in parameters) {
          w.write('  ${w.getCType(parameter.type)} ${parameter.name},\n');
        }
      }
      w.write(');\n');
    }

    // Dart type
    {
      w.write('typedef ${w.getDartType(returnType)} $typedefDart(');
      if (parameters.isNotEmpty) {
        w.write('\n');
        for (var parameter in parameters) {
          w.write('  ${w.getDartType(parameter.type)} ${parameter.name},\n');
        }
      }
      w.write(');\n');
    }
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
