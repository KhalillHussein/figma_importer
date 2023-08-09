import 'dart:convert';
import 'dart:io';

import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

class YamlUtils {
  static Map<String, dynamic> load(String filePath) {
    final yaml = _loadYamlFile(filePath);
    final map = jsonDecode(jsonEncode(yaml)) as Map<String, dynamic>;
    return map;
  }

  static YamlMap _loadYamlFile(String path) {
    final yamlFile = File(path);
    final yamlContent = yamlFile.readAsStringSync();
    final yaml = loadYaml(yamlContent) as YamlMap;
    return yaml;
  }

  static String toYamlString(Map<String, dynamic> json) {
    final map = jsonDecode(jsonEncode(json));
    final yaml = json2yaml(map as Map<String, dynamic>);
    return yaml;
  }
}
