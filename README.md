![Banner](https://raw.githubusercontent.com/KhalillHussein/figma_importer/main/doc/figma_importer_cover.png?raw=true)

[![coverage][coverage_badge]][coverage_badge]
[![pub package][pub_badge]][pub_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

A light tool for generating Figma styles as variables.
Supports `Color`, `LinearGradient`, `TextStyle`, and `Shadow` styles generation. 

## Installation 🚀

### Install using pub

This package is a standalone library that is unrelated to your project. As a result, there's no need to include it in your Flutter project because it acts as a global command-line tool for all of your projects.

```sh
dart pub global activate figma_importer
```

## How to use? 🧐

### Import styles from the Figma file

1. [Setup](#setup) plugin configuration yaml file (you only need to do it once)

2. Run the command:

   ```sh
   $ figma_importer import
   ```
   
### Imported style classes example

#### Color styles

```dart
class MyAppPalette {
  MyAppPalette._();

  static const Color primary = Color(0xFF378EFF);
  ...
}
```

#### Typography styles
```dart
class MyAppTypography {
  MyAppTypography._();

  static const displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    ...
  );
}
```

#### Shadow styles
```dart
class MyAppShadows {
  MyAppShadows._();

  static const shadowSmall = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 10,
      spreadRadius: -4,
      offset: Offset(4, 3),
   ),
   ...
  ];
}
```

## Setup

### Create Configuration

Add the following configuration at the end of your `pubspec.yaml` file.

```yaml
figma_importer:

  # Add your Figma API token here
  api_token: api-token

  # Add figma file id here
  file_id: file-id

  # Add node ids here
  node_ids: []

  # A path where all generated styles will be
  output_directory_path: lib/resources

  # Define three or less supported style types for generation
  style_class_configs:
    - style: color
      class_name: MyAppColorsPalette
    - style: typography
      class_name: MyAppTextStyles
    - style: shadows
      class_name: MyAppShadows

  # Optional parameters for theme class generation
  theme_class_config:

    # A class name for your theme
    class_name: MyAppTheme

    # A path where the generated theme will be
    output_directory_path: lib/theme
```

### Get required parameters

#### Get your Figma API token

https://www.figma.com/developers/api#authentication

![Get token](https://raw.githubusercontent.com/KhalillHussein/figma_importer/main/doc/get_figma_api_token.png)

#### Structure of the Figma file link
To understand how to get properties, just see the file link params example:

`https://www.figma.com/file/{file_id}/{file_name}?type=design&node-id={node_id}&mode=design`


#### Get your Figma file id
To get the file id, just open the Figma project in the browser and click on the address bar. You can see the file id next to the file path, as in the example link.

#### Get node ids
Each object in the Figma file is a Node, which has its own id. You can add a list of node-ids that contain styles. 
To get the node-id, you can select any object on the page and copy the `node-id` parameter in the address bar.

Or, without any selection, just copy the id of the current opened page, which contains all the styles. For example, a page with UI-kit or design tokens.

## Theme generation 🎨

The library also supports theme generation for light and dark modes. Each generated `ThemeData` can only include `ColorScheme` and `TextTheme` objects.

Generated themes are linked to the generated style files. Thus, before the theme generation, you should already have style files for color and typography and the corresponding configuration for them in your `pubspec.yaml` file.

Theme generation can be done by two ways: `auto` or `manual`.

### Auto Theme generation

Auto theme generation requires a specific naming. Each style in the Figma project should have the same name as the Flutter material theme `ColorScheme` and `TextTheme` parameters. 

Style names (especially color styles) should contain the prefix `light` or `dark`, depending on the theme mode. 

Format: `{theme_mode_prefix}/{style_name}`

For text styles, if your app uses the same single text style for both theme modes, a prefix for the text style is not needed.

#### Theme variations

If your app has more than two themes, you can additionally define the theme variation prefix of those themes.

Format: `{theme_mode_prefix}-{theme_variation_name}/{style_name}`

Auto generation can be done by the command:

```sh
$ figma_importer gen-theme --auto
```

### Manual Theme generation

Manual Theme generation has three steps:
1. Create theme reference `figma_importer_theme_ref.yaml` file by the command:
   ```sh
   $ figma_importer create-theme-ref
   ```
   
2. Fill in the Figma style names to the fields in the generated file. All properties are optional, unused properties can be deleted. Also, you can define additional themes in the file. 

3. Run theme generation by the command:

   ```sh
   $ figma_importer gen-theme --path=figma_importer_theme_ref.yaml
   ```

   In the path parameter specify a path to the theme reference file.
   

## Bugs or Requests 🤝

If you encounter any problems feel free to open an [issue](https://github.com/KhalillHussein/figma_importer/issues/new?template=bug_report.md). If you feel the library is missing a feature, please raise a [ticket](https://github.com/KhalillHussein/figma_importer/issues/new?template=feature_request.md). Pull request are also welcome.

[coverage_badge]: https://raw.githubusercontent.com/KhalillHussein/figma_importer/main/coverage_badge.svg
[pub_badge]: https://img.shields.io/pub/v/figma_importer.svg
[pub_link]: https://pub.dartlang.org/packages/figma_importer
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
