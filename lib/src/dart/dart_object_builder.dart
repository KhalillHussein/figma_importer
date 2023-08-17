/// Helper class which creates dart object with specified params.
class DartObjectBuilder {
  DartObjectBuilder.createObject(String type)
      : assert(type.isNotEmpty, 'Object type string should not be empty.'),
        _objectName = type;

  /// Name of the object.
  final String _objectName;

  /// List of specified params. in the format 'name: value';
  final List<String> _params = [];

  void addProperty({
    String? name,
    // ignore: always_put_required_named_parameters_first
    required Object value,
  }) {
    var valueString = '$value';

    //Add a comma before the close square brackets.
    //If the square brackets contain elements
    if (valueString.contains(RegExp(r'(?<=\[).+?(?=\])'))) {
      valueString = '${valueString.replaceFirst(']', '')},]';
    }

    _params.add(name == null ? valueString : '$name: $valueString');
  }

  String get result {
    final line = '$_objectName$_params'.replaceFirst('[', '(');
    final lastIndex = line.length - 1;

    //Add trailing comma when the line length >= 40 chars.
    if (line.length >= 40) {
      return line.replaceFirst(']', ',)', lastIndex);
    }
    return line.replaceFirst(']', ')', lastIndex);
  }

  List<String> get params => _params;
}
