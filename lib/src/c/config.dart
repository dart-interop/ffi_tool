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

///Represents the different methods to create a `DynamicLibrary`.
enum _DynamicLibraryCreationMode { executable, open, process }

///Configures how a `DynamicLibrary` should be created on a platform.
///The different constructors represents the different constructors of `DynamicLibrary`.
///See `DynamicLibrary` for more information.
class DynamicLibraryPlatformConfig {
  final _DynamicLibraryCreationMode _creationMode;
  final String? _path;

  const DynamicLibraryPlatformConfig.executable()
      : _path = null,
        _creationMode = _DynamicLibraryCreationMode.executable;

  const DynamicLibraryPlatformConfig.process()
      : _path = null,
        _creationMode = _DynamicLibraryCreationMode.process;

  const DynamicLibraryPlatformConfig.open(String path)
      : _path = path,
        _creationMode = _DynamicLibraryCreationMode.open;

  @override
  String toString() {
    switch (_creationMode) {
      case _DynamicLibraryCreationMode.executable:
        return 'DynamicLibrary.executable()';
      case _DynamicLibraryCreationMode.open:
        return 'DynamicLibrary.open(\'$_path\')';
      case _DynamicLibraryCreationMode.process:
        return 'DynamicLibrary.process()';
      default:
        return '';
    }
  }
}

/// Defines, how the dynamic library should be loaded on each of darts known platforms.
///
/// If the `DynamicLibraryPlatformConfig` is `null` for a platform, this platform will fallback to `other`.
/// If `other` is `null`, executing on each platform falling back to it
/// and on all platforms that do not match any known platform (e.g. windows, linux, ...),
/// will throw an `UnsupportedError`
class DynamicLibraryConfig {
  final DynamicLibraryPlatformConfig? windows;
  final DynamicLibraryPlatformConfig? linux;
  final DynamicLibraryPlatformConfig? macOS;
  final DynamicLibraryPlatformConfig? iOS;
  final DynamicLibraryPlatformConfig? android;
  final DynamicLibraryPlatformConfig? fuchsia;
  final DynamicLibraryPlatformConfig? other;

  const DynamicLibraryConfig(
      {this.windows,
      this.linux,
      this.macOS,
      this.iOS,
      this.android,
      this.fuchsia,
      this.other});
}
