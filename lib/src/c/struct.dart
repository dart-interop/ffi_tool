import 'package:ffi_tool/c.dart';

/// Dart Struct Ffi
///
/// ```dart
/// import 'package:ffi_tool/c.dart';
/// import 'dart:io';
/// void main() {
///   generateFile(File("generated.dart"), library);
/// }
/// final library = Library(
///   dynamicLibraryIdentifier: "dlForExampleLibrary",
///   dynamicLibraryPath: "path/to/library",
///   importedUris: [
///     "package:ffi/ffi.dart",
///   ],
///   elements: [
///     // A Struct
///     Struct(
///       name: "Coordinate",
///       members: <Member>[Member(type:"double",name : "latitude"), Member(type:"double",name : "longitude" )],
///     ),
///   ],
/// );
/// ```
class Struct extends Element {
  final String name;
  final List<Member> members;

  Struct({this.name, this.members});

  @override
  String generateSource(Library library) {
    final sb = StringBuffer();

    sb.write('\nclass $name extends Struct {');
    sb.writeAll(members.map((member) => member.toString()), '\n');

    final allocatedParameters = StringBuffer()
      ..writeAll(members.map((member) => member.getAllocatedParam()), ', ');

    final allocatedRefs = StringBuffer()
      ..writeAll(members.map((member) => member.getAllocatedRef()), '\n');

    sb.write(
        '\n\n  factory $name.allocate(${allocatedParameters.toString()}) =>');
    sb.write('\n      allocate<$name>().ref\n');
    sb.write('${allocatedRefs.toString()}');
    sb.write(';\n');
    sb.write('}\n');
    return sb.toString();
  }
}

class Member {
  final String name;
  final String type;
  Member({this.type, this.name});
  String getAllocatedParam() => '$type $name';
  String getAllocatedRef() =>
      (StringBuffer()..write('        ..$name = $name')).toString();

  @override
  String toString() =>
      (StringBuffer()..write('\n  @${getAnnotation(type)}()\n  ${type} $name;'))
          .toString();

  String getAnnotation(String type) {
    switch (type) {
      case 'double':
        return 'Double';
        break;
      default:
        'double';
    }
  }
}
