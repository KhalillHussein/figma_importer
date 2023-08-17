import 'package:equatable/equatable.dart';
import 'package:figma_importer/src/config/config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'theme_reference.g.dart';

@JsonSerializable(explicitToJson: true)
class ThemeReferenceRoot extends Equatable {
  const ThemeReferenceRoot(this.themeReference);

  factory ThemeReferenceRoot.fromJson(Map<String, dynamic> json) =>
      _$ThemeReferenceRootFromJson(json);

  @JsonKey(name: 'theme_reference')
  final ThemeReference? themeReference;

  Map<String, dynamic> toJson() => _$ThemeReferenceRootToJson(this);

  @override
  List<Object?> get props => [themeReference];

  static const template = ThemeReferenceRoot(
    ThemeReference(
      colorSchemes: [
        ColorScheme(
          name: 'lightColorSchemeName',
          factory: ColorSchemeFactory.light,
          properties: ColorSchemeProperties(
            primary: '#TODO',
            onPrimary: '#TODO',
            primaryContainer: '#TODO',
            onPrimaryContainer: '#TODO',
            secondary: '#TODO',
            onSecondary: '#TODO',
            secondaryContainer: '#TODO',
            onSecondaryContainer: '#TODO',
            tertiary: '#TODO',
            onTertiary: '#TODO',
            tertiaryContainer: '#TODO',
            onTertiaryContainer: '#TODO',
            error: '#TODO',
            onError: '#TODO',
            errorContainer: '#TODO',
            onErrorContainer: '#TODO',
            background: '#TODO',
            onBackground: '#TODO',
            surface: '#TODO',
            onSurface: '#TODO',
            surfaceVariant: '#TODO',
            onSurfaceVariant: '#TODO',
            outline: '#TODO',
            outlineVariant: '#TODO',
            shadow: '#TODO',
            scrim: '#TODO',
            inverseSurface: '#TODO',
            onInverseSurface: '#TODO',
            inversePrimary: '#TODO',
            surfaceTint: '#TODO',
          ),
        ),
      ],
      textThemes: [
        TextTheme(
          name: 'textThemeName',
          properties: TextThemeProperties(
            displayLarge: '#TODO',
            displayMedium: '#TODO',
            displaySmall: '#TODO',
            headlineLarge: '#TODO',
            headlineMedium: '#TODO',
            headlineSmall: '#TODO',
            titleLarge: '#TODO',
            titleMedium: '#TODO',
            titleSmall: '#TODO',
            bodyLarge: '#TODO',
            bodyMedium: '#TODO',
            bodySmall: '#TODO',
            labelLarge: '#TODO',
            labelMedium: '#TODO',
            labelSmall: '#TODO',
          ),
        ),
      ],
      themes: [
        Theme(
          name: 'lightExampleName',
          textTheme: 'textThemeName',
          colorScheme: 'lightColorSchemeName',
          brightness: Brightness.light,
        ),
      ],
    ),
  );
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ThemeReference extends Equatable {
  const ThemeReference({
    required this.themes,
    this.textThemes,
    this.colorSchemes,
  });

  factory ThemeReference.fromJson(Map<String, dynamic> json) =>
      _$ThemeReferenceFromJson(json);

  @JsonKey(name: 'themes')
  final List<Theme> themes;

  @JsonKey(name: 'text_themes')
  final List<TextTheme>? textThemes;

  @JsonKey(name: 'color_schemes')
  final List<ColorScheme>? colorSchemes;

  Map<String, dynamic> toJson() => _$ThemeReferenceToJson(this);

  @override
  List<Object?> get props => [themes, textThemes, colorSchemes];
}

@JsonSerializable(includeIfNull: false)
class Theme extends Equatable {
  const Theme({
    required this.name,
    required this.brightness,
    this.textTheme,
    this.colorScheme,
  });

  factory Theme.fromJson(Map<String, dynamic> json) => _$ThemeFromJson(json);

  final String name;

  final Brightness brightness;

  @JsonKey(name: 'text_theme')
  final String? textTheme;

  @JsonKey(name: 'color_scheme')
  final String? colorScheme;

  Map<String, dynamic> toJson() => _$ThemeToJson(this);

  @override
  List<Object?> get props => [name, brightness, textTheme, colorScheme];
}

sealed class BaseThemeParams<T extends BaseThemeProperties> extends Equatable {
  const BaseThemeParams({
    required this.name,
    required this.properties,
  });

  final String name;
  final T properties;
}

// ignore: one_member_abstracts
abstract class BaseThemeProperties extends Equatable {
  const BaseThemeProperties();

  Map<String, dynamic> toJson();
}

@JsonSerializable(explicitToJson: true)
class TextTheme extends BaseThemeParams<TextThemeProperties> {
  const TextTheme({
    required super.name,
    required super.properties,
  });

  factory TextTheme.fromJson(Map<String, dynamic> json) =>
      _$TextThemeFromJson(json);

  Map<String, dynamic> toJson() => _$TextThemeToJson(this);

  @override
  List<Object?> get props => [name, properties];
}

@JsonSerializable()
class TextThemeProperties extends BaseThemeProperties {
  const TextThemeProperties({
    this.displayLarge,
    this.displayMedium,
    this.displaySmall,
    this.headlineLarge,
    this.headlineMedium,
    this.headlineSmall,
    this.titleLarge,
    this.titleMedium,
    this.titleSmall,
    this.bodyLarge,
    this.bodyMedium,
    this.bodySmall,
    this.labelLarge,
    this.labelMedium,
    this.labelSmall,
  });

  factory TextThemeProperties.fromJson(Map<String, dynamic> json) =>
      _$TextThemePropertiesFromJson(json);

  @JsonKey(name: 'display_large')
  final String? displayLarge;
  @JsonKey(name: 'display_medium')
  final String? displayMedium;

  @JsonKey(name: 'display_small')
  final String? displaySmall;
  @JsonKey(name: 'headline_large')
  final String? headlineLarge;

  @JsonKey(name: 'headline_medium')
  final String? headlineMedium;

  @JsonKey(name: 'headline_small')
  final String? headlineSmall;

  @JsonKey(name: 'title_large')
  final String? titleLarge;

  @JsonKey(name: 'title_medium')
  final String? titleMedium;

  @JsonKey(name: 'title_small')
  final String? titleSmall;

  @JsonKey(name: 'body_large')
  final String? bodyLarge;

  @JsonKey(name: 'body_medium')
  final String? bodyMedium;

  @JsonKey(name: 'body_small')
  final String? bodySmall;

  @JsonKey(name: 'label_large')
  final String? labelLarge;

  @JsonKey(name: 'label_medium')
  final String? labelMedium;

  @JsonKey(name: 'label_small')
  final String? labelSmall;

  @override
  Map<String, dynamic> toJson() => _$TextThemePropertiesToJson(this);

  @override
  List<Object?> get props {
    return [
      displayLarge,
      displayMedium,
      displaySmall,
      headlineLarge,
      headlineMedium,
      headlineSmall,
      titleLarge,
      titleMedium,
      titleSmall,
      bodyLarge,
      bodyMedium,
      bodySmall,
      labelLarge,
      labelMedium,
      labelSmall,
    ];
  }
}

enum ColorSchemeFactory { light, dark }

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ColorScheme extends BaseThemeParams<ColorSchemeProperties> {
  const ColorScheme({
    required super.name,
    required this.factory,
    required super.properties,
  });

  factory ColorScheme.fromJson(Map<String, dynamic> json) =>
      _$ColorSchemeFromJson(json);

  final ColorSchemeFactory factory;

  Map<String, dynamic> toJson() => _$ColorSchemeToJson(this);

  @override
  List<Object?> get props => [name, factory, properties];
}

@JsonSerializable()
class ColorSchemeProperties extends BaseThemeProperties {
  const ColorSchemeProperties({
    this.primary,
    this.onPrimary,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.secondary,
    this.onSecondary,
    this.secondaryContainer,
    this.onSecondaryContainer,
    this.tertiary,
    this.onTertiary,
    this.tertiaryContainer,
    this.onTertiaryContainer,
    this.error,
    this.onError,
    this.errorContainer,
    this.onErrorContainer,
    this.background,
    this.onBackground,
    this.surface,
    this.onSurface,
    this.surfaceVariant,
    this.onSurfaceVariant,
    this.outline,
    this.outlineVariant,
    this.shadow,
    this.scrim,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.surfaceTint,
  });

  factory ColorSchemeProperties.fromJson(Map<String, dynamic> json) =>
      _$ColorSchemePropertiesFromJson(json);

  final String? primary;
  @JsonKey(name: 'on_primary')
  final String? onPrimary;

  @JsonKey(name: 'primary_container')
  final String? primaryContainer;

  @JsonKey(name: 'on_primary_container')
  final String? onPrimaryContainer;

  final String? secondary;

  @JsonKey(name: 'on_secondary')
  final String? onSecondary;

  @JsonKey(name: 'secondary_container')
  final String? secondaryContainer;

  @JsonKey(name: 'on_secondary_container')
  final String? onSecondaryContainer;
  final String? tertiary;

  @JsonKey(name: 'on_tertiary')
  final String? onTertiary;

  @JsonKey(name: 'tertiary_container')
  final String? tertiaryContainer;

  @JsonKey(name: 'on_tertiary_container')
  final String? onTertiaryContainer;
  final String? error;

  @JsonKey(name: 'on_error')
  final String? onError;

  @JsonKey(name: 'error_container')
  final String? errorContainer;

  @JsonKey(name: 'on_error_container')
  final String? onErrorContainer;

  final String? background;

  @JsonKey(name: 'on_background')
  final String? onBackground;

  final String? surface;

  @JsonKey(name: 'on_surface')
  final String? onSurface;

  @JsonKey(name: 'surface_variant')
  final String? surfaceVariant;

  @JsonKey(name: 'on_surface_variant')
  final String? onSurfaceVariant;

  final String? outline;

  @JsonKey(name: 'outline_variant')
  final String? outlineVariant;

  final String? shadow;
  final String? scrim;

  @JsonKey(name: 'inverse_surface')
  final String? inverseSurface;

  @JsonKey(name: 'on_inverse_surface')
  final String? onInverseSurface;

  @JsonKey(name: 'inverse_primary')
  final String? inversePrimary;

  @JsonKey(name: 'surface_tint')
  final String? surfaceTint;

  @override
  Map<String, dynamic> toJson() => _$ColorSchemePropertiesToJson(this);

  @override
  List<Object?> get props {
    return [
      primary,
      onPrimary,
      primaryContainer,
      onPrimaryContainer,
      secondary,
      onSecondary,
      secondaryContainer,
      onSecondaryContainer,
      tertiary,
      onTertiary,
      tertiaryContainer,
      onTertiaryContainer,
      error,
      onError,
      errorContainer,
      onErrorContainer,
      background,
      onBackground,
      surface,
      onSurface,
      surfaceVariant,
      onSurfaceVariant,
      outline,
      outlineVariant,
      shadow,
      scrim,
      inverseSurface,
      onInverseSurface,
      inversePrimary,
      surfaceTint,
    ];
  }
}
