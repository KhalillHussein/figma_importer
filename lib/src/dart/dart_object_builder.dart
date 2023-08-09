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
  }) =>
      _params.add(name == null ? '$value' : '$name: $value');

  String get result {
    final line = '$_objectName$_params'.replaceAll('[', '(');

    //Add trailing comma when the line length >= 40 chars.
    if (line.length >= 40) {
      return line.replaceAll(']', ',)');
    }
    return line.replaceAll(']', ')');
  }

  List<String> get params => _params;
}
