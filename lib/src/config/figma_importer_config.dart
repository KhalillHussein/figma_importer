import 'package:equatable/equatable.dart';
import 'package:figma_importer/src/parser/parser.dart';

import 'package:json_annotation/json_annotation.dart';

part 'figma_importer_config.g.dart';

enum Brightness { light, dark }

@JsonSerializable(explicitToJson: true)
class ConfigRoot extends Equatable {
  const ConfigRoot(this.content);

  factory ConfigRoot.fromJson(Map<String, dynamic> json) =>
      _$ConfigRootFromJson(json);

  @JsonKey(name: 'figma_importer')
  final FigmaImporterConfig? content;

  Map<String, dynamic> toJson() => _$ConfigRootToJson(this);

  @override
  List<Object?> get props => [content];
}

@JsonSerializable(explicitToJson: true)
class FigmaImporterConfig extends Equatable {
  const FigmaImporterConfig({
    required this.apiToken,
    required this.fileId,
    required this.nodeIds,
    required this.outputDirectoryPath,
    required this.styleClassConfigs,
    this.themeClassConfig,
  });

  factory FigmaImporterConfig.fromJson(Map<String, dynamic> json) =>
      _$FigmaImporterConfigFromJson(json);

  @JsonKey(name: 'api_token')
  final String apiToken;

  @JsonKey(name: 'file_id')
  final String fileId;

  @JsonKey(name: 'node_ids')
  final List<String> nodeIds;

  @JsonKey(name: 'output_directory_path')
  final String outputDirectoryPath;

  @JsonKey(name: 'style_class_configs')
  final List<StyleClassConfig> styleClassConfigs;

  @JsonKey(name: 'theme_class_config')
  final ThemeConfig? themeClassConfig;

  Map<String, dynamic> toJson() => _$FigmaImporterConfigToJson(this);

  @override
  List<Object?> get props {
    return [
      apiToken,
      fileId,
      nodeIds,
      outputDirectoryPath,
      styleClassConfigs,
      themeClassConfig,
    ];
  }
}

@JsonSerializable()
class ThemeConfig extends Equatable {
  const ThemeConfig({
    required this.className,
    required this.outputDirectoryPath,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);

  @JsonKey(name: 'class_name')
  final String className;

  @JsonKey(name: 'output_directory_path')
  final String outputDirectoryPath;

  Map<String, dynamic> toJson() => _$ThemeConfigToJson(this);

  @override
  List<Object> get props => [className, outputDirectoryPath];
}

@JsonSerializable()
class StyleClassConfig extends Equatable {
  const StyleClassConfig({
    required this.style,
    required this.className,
  });

  factory StyleClassConfig.fromJson(Map<String, dynamic> json) =>
      _$StyleClassConfigFromJson(json);

  final StyleDefinition style;

  @JsonKey(name: 'class_name')
  final String className;

  Map<String, dynamic> toJson() => _$StyleClassConfigToJson(this);

  @override
  List<Object> get props => [style, className];
}
