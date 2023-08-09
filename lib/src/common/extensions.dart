import 'package:figma_importer/src/figma_api/figma_api.dart';

typedef ArgbColorsTo255 = ({int a, int r, int g, int b});

extension ColorX on Color {
  ArgbColorsTo255 get _as255 => (
        a: _to255(a!),
        r: _to255(r!),
        g: _to255(g!),
        b: _to255(b!),
      );

  int _to255(double color) => (color.clamp(0.0, 1.0) * 255).toInt();

  String _toHex(int value) =>
      value.toRadixString(16).padLeft(2, '0').toUpperCase();

  String get asHex =>
      '''0x${_toHex(_as255.a)}${_toHex(_as255.r)}${_toHex(_as255.g)}${_toHex(_as255.b)}''';
}

extension StringX on String {
  String get replaceSpecialCharactersWithUnderscore =>
      replaceAll(RegExp('[^A-Za-z0-9]'), '_');

  List<String?> get allMatchedStyleFields =>
      RegExp('(?<=TextStyle ).*?(?= =)|(?<=Color ).*?(?= =)')
          .allMatches(this)
          .map((element) => element[0])
          .toList();

  bool containsSubstringNoCase(String string) =>
      toLowerCase().contains(string.toLowerCase());
}
