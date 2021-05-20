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

import 'dart_source_writer.dart';
import 'config.dart';

/// A definition for a C library.
class Library {
  /// The name for the class all functions and globals are placed in.
  ///
  /// This is required since version 0.4.0 of this package due to null safety.
  final String containerClassName;

  /// A preamble which is simply copied to the generated file.
  final String? preamble;

  /// Custom load code to load the underlying dynamic library, only non-null if created with the `Library.customLoadCode` constructor.
  final String? customLoadCode;

  /// If the library was created with the default constructor and is not platform aware this represents the path of the underlying dynamic library.
  final String? dynamicLibraryPath;

  ///If this library is platform aware, this represents the platform config, otherwise this is null.
  final DynamicLibraryConfig? dynamicLibraryConfig;

  /// Optional 'library' directive in the generated file.
  final String? libraryName;

  /// Optional 'part of' directive in the generated file.
  final String? partOf;

  /// Optional imported URIs. May be empty nut never null.
  final Set<ImportedUri> importedUris;

  /// Optional 'part' directives in the generated file. May be empty nut never null.
  final Set<String> parts;

  /// Elements.
  final List<Element> elements;

  static const String dynamicLibraryIdentifier = '_dynamicLibrary';

  ///The default constructor, which is not platform aware.
  ///
  ///The dynamic library will be created using the `DynamicLibrary.open` method and the given `dynamicLibraryPath`.
  const Library({
    required this.dynamicLibraryPath,
    required this.elements,
    String? containerClassName,
    String? libraryName,
    this.partOf,
    this.preamble = '// AUTOMATICALLY GENERATED. DO NOT EDIT.',
    this.importedUris = const {},
    this.parts = const {},
  })  : dynamicLibraryConfig = null,
        customLoadCode = null,
        libraryName = libraryName,
        containerClassName =
            containerClassName ?? ((libraryName ?? '') + 'FunctionsAndGlobals');

  ///Creates a library which is platform aware, meaning that the creation of the underlying dynamic library can depend on the platform.
  const Library.platformAware({
    required this.dynamicLibraryConfig,
    required this.elements,
    String? containerClassName,
    String? libraryName,
    this.partOf,
    this.preamble = '// AUTOMATICALLY GENERATED. DO NOT EDIT.',
    this.importedUris = const {},
    this.parts = const {},
  })  : dynamicLibraryPath = null,
        customLoadCode = null,
        libraryName = libraryName,
        containerClassName =
            containerClassName ?? ((libraryName ?? '') + 'FunctionsAndGlobals');

  ///Creates a library where the underlying dynamic library is explicitly loaded using the given `customLoadCode`.
  ///
  ///`customLoadCode` must be valid dart code and will be prefixed with "ffi.DynamicLibrary _open(){\n" and surfixed with "\n}".
  ///In other words, `customLoadCode` is the method body of a method with signatrure "DynamicLibrary _open()".
  const Library.customLoadCode({
    required this.customLoadCode,
    required this.elements,
    String? containerClassName,
    String? libraryName,
    this.partOf,
    this.preamble = '// AUTOMATICALLY GENERATED. DO NOT EDIT.',
    this.importedUris = const {},
    this.parts = const {},
  })  : dynamicLibraryPath = null,
        dynamicLibraryConfig = null,
        libraryName = libraryName,
        containerClassName =
            containerClassName ?? ((libraryName ?? '') + 'FunctionsAndGlobals');

  ///Creates a library without caring about the underlying library. You have to set it manually using the init() function of the generated file at runtime.
  const Library.withoutLoading({
    required this.elements,
    String? containerClassName,
    String? libraryName,
    this.partOf,
    this.preamble = '// AUTOMATICALLY GENERATED. DO NOT EDIT.',
    this.importedUris = const {},
    this.parts = const {},
  })  : dynamicLibraryPath = null,
        dynamicLibraryConfig = null,
        customLoadCode = null,
        libraryName = libraryName,
        containerClassName =
            containerClassName ?? ((libraryName ?? '') + 'FunctionsAndGlobals');

  bool get _platformAware => dynamicLibraryConfig != null;

  bool get _customLoadCode => customLoadCode != null;

  bool get _withoutLoading =>
      dynamicLibraryConfig == null &&
      customLoadCode == null &&
      dynamicLibraryPath == null;

  void generateSource(DartSourceWriter w) {
    w.libraryName = libraryName;
    w.partOf = partOf;
    w.preamble = preamble;

    // Imports
    w.imports.add(const ImportedUri('dart:ffi', prefix: 'ffi'));
    if (_platformAware) {
      w.imports
          .add(const ImportedUri('dart:io', prefix: 'io', show: 'Platform'));
    }
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

    // Outer elements, meaning things not belonging into a class
    for (var element in elements) {
      element.generateOuterSource(w, this);
    }

    w.write('\n');
    if (_customLoadCode) {
      w.write('ffi.DynamicLibrary _open(){\n');
      w.write(customLoadCode!);
      w.write('\n}');
    } else if (_platformAware) {
      final dynamicLibraryConfig = this.dynamicLibraryConfig!;
      w.write('ffi.DynamicLibrary _open(){\n\t');
      if (dynamicLibraryConfig.windows != null) {
        w.write(
            'if(io.Platform.isWindows) return ffi.${dynamicLibraryConfig.windows};\n\t');
      }
      if (dynamicLibraryConfig.linux != null) {
        w.write(
            'if(io.Platform.isLinux) return ffi.${dynamicLibraryConfig.linux};\n\t');
      }
      if (dynamicLibraryConfig.android != null) {
        w.write(
            'if(io.Platform.isAndroid) return ffi.${dynamicLibraryConfig.android};\n\t');
      }
      if (dynamicLibraryConfig.macOS != null) {
        w.write(
            'if(io.Platform.isMacOS) return ffi.${dynamicLibraryConfig.macOS};\n\t');
      }
      if (dynamicLibraryConfig.iOS != null) {
        w.write(
            'if(io.Platform.isIOS) return ffi.${dynamicLibraryConfig.iOS};\n\t');
      }
      if (dynamicLibraryConfig.fuchsia != null) {
        w.write(
            'if(io.Platform.isFuchsia) return ffi.${dynamicLibraryConfig.fuchsia};\n\t');
      }
      var other = dynamicLibraryConfig.other == null
          ? 'throw UnsupportedError(\'This platform is not supported.\');\n'
          : 'return ffi.${dynamicLibraryConfig.other};\n';
      w.write(other);
      w.write('}');
    } else if (!_withoutLoading) {
      w.write('ffi.DynamicLibrary _open() => ffi.DynamicLibrary.open(\n');
      w.write('  \'${dynamicLibraryPath}\',\n');
      w.write(');\n');
    }

    if (!_withoutLoading) {
      w.write('/// Dynamic library\n');
      w.write(
          'final ffi.DynamicLibrary ${dynamicLibraryIdentifier} = _open();');
    }

    w.write('class $containerClassName {\n');

    // Class constructor
    w.write('$containerClassName(');
    if (_withoutLoading) {
      w.write('ffi.DynamicLibrary $dynamicLibraryIdentifier');
    }
    w.write(')');
    var first = true;
    var needSeparator = true;
    for (var element in elements) {
      if (needSeparator) {
        if (first) {
          first = false;
          w.write(':\n');
        } else {
          w.write(',\n');
        }
      }
      needSeparator = element.generateConstructorSource(w, this);
    }
    w.write(';\n');
    w.write('\n');
    // Inner elements, the things that belong into a class
    for (var element in elements) {
      element.generateInnerSource(w, this);
    }

    w.write('}');
  }

  @override
  String toString() {
    final w = DartSourceWriter();
    generateSource(w);
    return w.toString();
  }
}

/// Abstract base class for Func, Struct and Global.
abstract class Element {
  /// Name of this element
  final String name;

  /// Optional documentation of this element
  final String? documentation;

  const Element({required this.name, this.documentation});

  void generateOuterSource(DartSourceWriter w, Library library);
  void generateInnerSource(DartSourceWriter w, Library library);
  bool generateConstructorSource(DartSourceWriter w, Library library);
}
