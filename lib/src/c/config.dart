import 'package:meta/meta.dart';

///Represents the different methods to create a `DynamicLibrary`.
///
///See the `DynamicLibrary` class for more information.
enum DynamicLibraryCreationMode { executable, open, process }

///Configures how a `DynamicLibrary` should be created on a platform.
///
///If the library is dynamic and opend, a path to it must be provided.
///For static creation modes, the path parameter must remaind `null`.
///See the `DynamicLibrary` class for more information.
class DynamicLibraryPlatformConfig {
  final DynamicLibraryCreationMode creationMode;
  final String path;

  const DynamicLibraryPlatformConfig({@required this.creationMode, this.path})
      : assert(creationMode != null, 'creationMode must not be null!'),
        assert(
            creationMode != DynamicLibraryCreationMode.open ||
                (creationMode == DynamicLibraryCreationMode.open &&
                    path != null),
            'When using a dynamic library, a path is required!'),
        assert(
            creationMode == DynamicLibraryCreationMode.open ||
                (creationMode != DynamicLibraryCreationMode.open &&
                    path == null),
            'When using a static library, the must not be a path!');

  @override
  String toString() {
    switch (creationMode) {
      case DynamicLibraryCreationMode.executable:
        return 'DynamicLibrary.executable()';
        break;
      case DynamicLibraryCreationMode.open:
        return 'DynamicLibrary.open(\'$path\')';
        break;
      case DynamicLibraryCreationMode.process:
        return 'DynamicLibrary.process()';
        break;
    }
    return null;
  }
}

class DynamicLibraryConfig {
  final DynamicLibraryPlatformConfig windows;
  final DynamicLibraryPlatformConfig linux;
  final DynamicLibraryPlatformConfig macOS;
  final DynamicLibraryPlatformConfig iOS;
  final DynamicLibraryPlatformConfig android;
  final DynamicLibraryPlatformConfig fuchsia;
  final DynamicLibraryPlatformConfig other;

  ///Shortcut for using the same dynamic library on every platform.
  DynamicLibraryConfig.open(String path)
      : this(
            other: DynamicLibraryPlatformConfig(
                creationMode: DynamicLibraryCreationMode.open, path: path));

  const DynamicLibraryConfig(
      {this.windows,
      this.linux,
      this.macOS,
      this.iOS,
      this.android,
      this.fuchsia,
      this.other});
}
