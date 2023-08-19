### Basic Example

#### Import Figma styles command:

```shell
$ figma_importer import
```

#### Auto Theme generation command:

```sh
$ figma_importer gen-theme --auto
```

#### Manual Theme generation command:

```sh
$ figma_importer gen-theme --path=figma_importer_theme_ref.yaml
```

#### Theme reference generation command:

```sh
$ figma_importer create-theme-ref
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
    fontWeight: FontWeight.w400,
    fontSize: 36.0,
    height: 1.22,
    fontFamily: 'Roboto',
    letterSpacing: 0.4,
    decoration: TextDecoration.underline,
  );
  ...
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

### Imported theme class example

```dart
class MyAppTheme {
  const MyAppTheme._();

  static final ThemeData m3SysDarkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: m3TextTheme,
    colorScheme: m3SysDarkColorScheme,
  );

  static final ThemeData m3SysLightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: m3TextTheme,
    colorScheme: m3SysLightColorScheme,
  );


  static const ColorScheme m3SysDarkColorScheme = ColorScheme.dark(
    primary: Palette.m3SysDarkPrimary,
    onPrimary: Palette.m3SysDarkOnPrimary,
    primaryContainer: Palette.m3SysDarkPrimaryContainer,
    ...
  );


  static const ColorScheme m3SysLightColorScheme = ColorScheme.light(
    primary: Palette.m3SysLightPrimary,
    onPrimary: Palette.m3SysLightOnPrimary,
    primaryContainer: Palette.m3SysLightPrimaryContainer,
    ...
  );

  static const TextTheme m3TextTheme = TextTheme(
    displayLarge: TextStyles.m3DisplayLarge,
    displayMedium: TextStyles.m3DisplayMedium,
    displaySmall: TextStyles.m3DisplaySmall,
    headlineLarge: TextStyles.m3HeadlineLarge,
    ...
  );
}

```