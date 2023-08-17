// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeReferenceRoot _$ThemeReferenceRootFromJson(Map<String, dynamic> json) =>
    ThemeReferenceRoot(
      json['theme_reference'] == null
          ? null
          : ThemeReference.fromJson(
              json['theme_reference'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThemeReferenceRootToJson(ThemeReferenceRoot instance) =>
    <String, dynamic>{
      'theme_reference': instance.themeReference?.toJson(),
    };

ThemeReference _$ThemeReferenceFromJson(Map<String, dynamic> json) =>
    ThemeReference(
      themes: (json['themes'] as List<dynamic>)
          .map((e) => Theme.fromJson(e as Map<String, dynamic>))
          .toList(),
      textThemes: (json['text_themes'] as List<dynamic>?)
          ?.map((e) => TextTheme.fromJson(e as Map<String, dynamic>))
          .toList(),
      colorSchemes: (json['color_schemes'] as List<dynamic>?)
          ?.map((e) => ColorScheme.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ThemeReferenceToJson(ThemeReference instance) {
  final val = <String, dynamic>{
    'themes': instance.themes.map((e) => e.toJson()).toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'text_themes', instance.textThemes?.map((e) => e.toJson()).toList());
  writeNotNull(
      'color_schemes', instance.colorSchemes?.map((e) => e.toJson()).toList());
  return val;
}

Theme _$ThemeFromJson(Map<String, dynamic> json) => Theme(
      name: json['name'] as String,
      brightness: $enumDecode(_$BrightnessEnumMap, json['brightness']),
      textTheme: json['text_theme'] as String?,
      colorScheme: json['color_scheme'] as String?,
    );

Map<String, dynamic> _$ThemeToJson(Theme instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'brightness': _$BrightnessEnumMap[instance.brightness]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text_theme', instance.textTheme);
  writeNotNull('color_scheme', instance.colorScheme);
  return val;
}

const _$BrightnessEnumMap = {
  Brightness.light: 'light',
  Brightness.dark: 'dark',
};

TextTheme _$TextThemeFromJson(Map<String, dynamic> json) => TextTheme(
      name: json['name'] as String,
      properties: TextThemeProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextThemeToJson(TextTheme instance) => <String, dynamic>{
      'name': instance.name,
      'properties': instance.properties.toJson(),
    };

TextThemeProperties _$TextThemePropertiesFromJson(Map<String, dynamic> json) =>
    TextThemeProperties(
      displayLarge: json['display_large'] as String?,
      displayMedium: json['display_medium'] as String?,
      displaySmall: json['display_small'] as String?,
      headlineLarge: json['headline_large'] as String?,
      headlineMedium: json['headline_medium'] as String?,
      headlineSmall: json['headline_small'] as String?,
      titleLarge: json['title_large'] as String?,
      titleMedium: json['title_medium'] as String?,
      titleSmall: json['title_small'] as String?,
      bodyLarge: json['body_large'] as String?,
      bodyMedium: json['body_medium'] as String?,
      bodySmall: json['body_small'] as String?,
      labelLarge: json['label_large'] as String?,
      labelMedium: json['label_medium'] as String?,
      labelSmall: json['label_small'] as String?,
    );

Map<String, dynamic> _$TextThemePropertiesToJson(
        TextThemeProperties instance) =>
    <String, dynamic>{
      'display_large': instance.displayLarge,
      'display_medium': instance.displayMedium,
      'display_small': instance.displaySmall,
      'headline_large': instance.headlineLarge,
      'headline_medium': instance.headlineMedium,
      'headline_small': instance.headlineSmall,
      'title_large': instance.titleLarge,
      'title_medium': instance.titleMedium,
      'title_small': instance.titleSmall,
      'body_large': instance.bodyLarge,
      'body_medium': instance.bodyMedium,
      'body_small': instance.bodySmall,
      'label_large': instance.labelLarge,
      'label_medium': instance.labelMedium,
      'label_small': instance.labelSmall,
    };

ColorScheme _$ColorSchemeFromJson(Map<String, dynamic> json) => ColorScheme(
      name: json['name'] as String,
      factory: $enumDecode(_$ColorSchemeFactoryEnumMap, json['factory']),
      properties: ColorSchemeProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ColorSchemeToJson(ColorScheme instance) =>
    <String, dynamic>{
      'name': instance.name,
      'properties': instance.properties.toJson(),
      'factory': _$ColorSchemeFactoryEnumMap[instance.factory]!,
    };

const _$ColorSchemeFactoryEnumMap = {
  ColorSchemeFactory.light: 'light',
  ColorSchemeFactory.dark: 'dark',
};

ColorSchemeProperties _$ColorSchemePropertiesFromJson(
        Map<String, dynamic> json) =>
    ColorSchemeProperties(
      primary: json['primary'] as String?,
      onPrimary: json['on_primary'] as String?,
      primaryContainer: json['primary_container'] as String?,
      onPrimaryContainer: json['on_primary_container'] as String?,
      secondary: json['secondary'] as String?,
      onSecondary: json['on_secondary'] as String?,
      secondaryContainer: json['secondary_container'] as String?,
      onSecondaryContainer: json['on_secondary_container'] as String?,
      tertiary: json['tertiary'] as String?,
      onTertiary: json['on_tertiary'] as String?,
      tertiaryContainer: json['tertiary_container'] as String?,
      onTertiaryContainer: json['on_tertiary_container'] as String?,
      error: json['error'] as String?,
      onError: json['on_error'] as String?,
      errorContainer: json['error_container'] as String?,
      onErrorContainer: json['on_error_container'] as String?,
      background: json['background'] as String?,
      onBackground: json['on_background'] as String?,
      surface: json['surface'] as String?,
      onSurface: json['on_surface'] as String?,
      surfaceVariant: json['surface_variant'] as String?,
      onSurfaceVariant: json['on_surface_variant'] as String?,
      outline: json['outline'] as String?,
      outlineVariant: json['outline_variant'] as String?,
      shadow: json['shadow'] as String?,
      scrim: json['scrim'] as String?,
      inverseSurface: json['inverse_surface'] as String?,
      onInverseSurface: json['on_inverse_surface'] as String?,
      inversePrimary: json['inverse_primary'] as String?,
      surfaceTint: json['surface_tint'] as String?,
    );

Map<String, dynamic> _$ColorSchemePropertiesToJson(
        ColorSchemeProperties instance) =>
    <String, dynamic>{
      'primary': instance.primary,
      'on_primary': instance.onPrimary,
      'primary_container': instance.primaryContainer,
      'on_primary_container': instance.onPrimaryContainer,
      'secondary': instance.secondary,
      'on_secondary': instance.onSecondary,
      'secondary_container': instance.secondaryContainer,
      'on_secondary_container': instance.onSecondaryContainer,
      'tertiary': instance.tertiary,
      'on_tertiary': instance.onTertiary,
      'tertiary_container': instance.tertiaryContainer,
      'on_tertiary_container': instance.onTertiaryContainer,
      'error': instance.error,
      'on_error': instance.onError,
      'error_container': instance.errorContainer,
      'on_error_container': instance.onErrorContainer,
      'background': instance.background,
      'on_background': instance.onBackground,
      'surface': instance.surface,
      'on_surface': instance.onSurface,
      'surface_variant': instance.surfaceVariant,
      'on_surface_variant': instance.onSurfaceVariant,
      'outline': instance.outline,
      'outline_variant': instance.outlineVariant,
      'shadow': instance.shadow,
      'scrim': instance.scrim,
      'inverse_surface': instance.inverseSurface,
      'on_inverse_surface': instance.onInverseSurface,
      'inverse_primary': instance.inversePrimary,
      'surface_tint': instance.surfaceTint,
    };
