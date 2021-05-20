# 0.4.0
  * BREAKING: Null Safety
  * BREAKING: Removed dependency on the ffi package since dart:ffi is stable now (since dart 2.12)
  * BREAKING: Removed Utf8 type, use Uint8 instead
  * Added Opaque type

# 0.3.0
  * Configure how a dynamic library should be loaded depending on the platform,
    explicitly give the load code, or make the user responsible for loading at runtime.

  * You can now add documentation to functions, structs and globals
    and preambles (e.g. for including licenses) to generated licenses.

  * BREAKING: DartSourceWriter and Parameter class removed from public API
    (although they were not meant to be used outside this package in the first place).

  * BREAKING: Renamed the class Field to StructField, since its only used for structs.

  * Further bug fixes

# 0.2.5
  * Fixes issues caused by a breaking change after a pull request didn't go through enough code
    review.

# 0.2.3
  * Adds support for disabling dartfmt.

# 0.2.2
  * Bug fixes

# 0.2.1
  * Bug fixes
  * Support for generating 'library', 'part of', and 'parts' directives.

# 0.2.0
  * Support for pedantic 1.9 linter warning.
  * Added struct support.
  * Refactored the API.

# 0.1.2
  * The package now works in the latest Dart SDK.
  * Removed cupertino_ffi stuff.

# 0.1.1
  * Added Objective-C support.

# 0.1.0
  * Initial release
