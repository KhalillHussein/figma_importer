// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figma_importer_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigRoot _$ConfigRootFromJson(Map<String, dynamic> json) => ConfigRoot(
      json['figma_importer'] == null
          ? null
          : FigmaImporterConfig.fromJson(
              json['figma_importer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfigRootToJson(ConfigRoot instance) =>
    <String, dynamic>{
      'figma_importer': instance.content?.toJson(),
    };

FigmaImporterConfig _$FigmaImporterConfigFromJson(Map<String, dynamic> json) =>
    FigmaImporterConfig(
      apiToken: json['api_token'] as String,
      fileId: json['file_id'] as String,
      nodeIds:
          (json['node_ids'] as List<dynamic>).map((e) => e as String).toList(),
      outputDirectoryPath: json['output_directory_path'] as String,
      styleClassConfigs: (json['style_class_configs'] as List<dynamic>)
          .map((e) => StyleClassConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      themeClassConfig: json['theme_class_config'] == null
          ? null
          : ThemeConfig.fromJson(
              json['theme_class_config'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FigmaImporterConfigToJson(
        FigmaImporterConfig instance) =>
    <String, dynamic>{
      'api_token': instance.apiToken,
      'file_id': instance.fileId,
      'node_ids': instance.nodeIds,
      'output_directory_path': instance.outputDirectoryPath,
      'style_class_configs':
          instance.styleClassConfigs.map((e) => e.toJson()).toList(),
      'theme_class_config': instance.themeClassConfig?.toJson(),
    };

ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => ThemeConfig(
      className: json['class_name'] as String,
      outputDirectoryPath: json['output_directory_path'] as String,
    );

Map<String, dynamic> _$ThemeConfigToJson(ThemeConfig instance) =>
    <String, dynamic>{
      'class_name': instance.className,
      'output_directory_path': instance.outputDirectoryPath,
    };

StyleClassConfig _$StyleClassConfigFromJson(Map<String, dynamic> json) =>
    StyleClassConfig(
      style: $enumDecode(_$StyleDefinitionEnumMap, json['style']),
      className: json['class_name'] as String,
    );

Map<String, dynamic> _$StyleClassConfigToJson(StyleClassConfig instance) =>
    <String, dynamic>{
      'style': _$StyleDefinitionEnumMap[instance.style]!,
      'class_name': instance.className,
    };

const _$StyleDefinitionEnumMap = {
  StyleDefinition.color: 'color',
  StyleDefinition.typography: 'typography',
  StyleDefinition.shadows: 'shadows',
};
