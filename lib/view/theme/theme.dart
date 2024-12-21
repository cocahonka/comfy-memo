import 'package:flutter/material.dart';

@immutable
final class MaterialTheme {
  const MaterialTheme(this.textTheme);

  final TextTheme textTheme;

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff745b0c),
      surfaceTint: Color(0xff745b0c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffe08e),
      onPrimaryContainer: Color(0xff241a00),
      secondary: Color(0xff745b0b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdf92),
      onSecondaryContainer: Color(0xff241a00),
      tertiary: Color(0xff35693f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb6f1bb),
      onTertiaryContainer: Color(0xff002109),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff8f1),
      onBackground: Color(0xff1f1b13),
      surface: Color(0xfffff8f1),
      onSurface: Color(0xff1f1b13),
      surfaceVariant: Color(0xffece1cf),
      onSurfaceVariant: Color(0xff4c4639),
      outline: Color(0xff7e7667),
      outlineVariant: Color(0xffcfc5b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff343027),
      inverseOnSurface: Color(0xfff8f0e2),
      inversePrimary: Color(0xffe4c36c),
      primaryFixed: Color(0xffffe08e),
      onPrimaryFixed: Color(0xff241a00),
      primaryFixedDim: Color(0xffe4c36c),
      onPrimaryFixedVariant: Color(0xff584400),
      secondaryFixed: Color(0xffffdf92),
      onSecondaryFixed: Color(0xff241a00),
      secondaryFixedDim: Color(0xffe5c36c),
      onSecondaryFixedVariant: Color(0xff594400),
      tertiaryFixed: Color(0xffb6f1bb),
      onTertiaryFixed: Color(0xff002109),
      tertiaryFixedDim: Color(0xff9bd4a0),
      onTertiaryFixedVariant: Color(0xff1b5129),
      surfaceDim: Color(0xffe1d9cc),
      surfaceBright: Color(0xfffff8f1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffeae1d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff534000),
      surfaceTint: Color(0xff745b0c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8c7223),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff544000),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8d7123),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff174d25),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4b8053),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f1),
      onBackground: Color(0xff1f1b13),
      surface: Color(0xfffff8f1),
      onSurface: Color(0xff1f1b13),
      surfaceVariant: Color(0xffece1cf),
      onSurfaceVariant: Color(0xff484235),
      outline: Color(0xff655e50),
      outlineVariant: Color(0xff817a6b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff343027),
      inverseOnSurface: Color(0xfff8f0e2),
      inversePrimary: Color(0xffe4c36c),
      primaryFixed: Color(0xff8c7223),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff715908),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8d7123),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff725908),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4b8053),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff32673c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe1d9cc),
      surfaceBright: Color(0xfffff8f1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffeae1d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff2c2100),
      surfaceTint: Color(0xff745b0c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff534000),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2c2100),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff544000),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00290d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff174d25),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f1),
      onBackground: Color(0xff1f1b13),
      surface: Color(0xfffff8f1),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffece1cf),
      onSurfaceVariant: Color(0xff282318),
      outline: Color(0xff484235),
      outlineVariant: Color(0xff484235),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff343027),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffeaba),
      primaryFixed: Color(0xff534000),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff392b00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff544000),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff392b00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff174d25),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003513),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe1d9cc),
      surfaceBright: Color(0xfffff8f1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf2e5),
      surfaceContainer: Color(0xfff6eddf),
      surfaceContainerHigh: Color(0xfff0e7d9),
      surfaceContainerHighest: Color(0xffeae1d4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe4c36c),
      surfaceTint: Color(0xffe4c36c),
      onPrimary: Color(0xff3d2e00),
      primaryContainer: Color(0xff584400),
      onPrimaryContainer: Color(0xffffe08e),
      secondary: Color(0xffe5c36c),
      onSecondary: Color(0xff3e2e00),
      secondaryContainer: Color(0xff594400),
      onSecondaryContainer: Color(0xffffdf92),
      tertiary: Color(0xff9bd4a0),
      onTertiary: Color(0xff003915),
      tertiaryContainer: Color(0xff1b5129),
      onTertiaryContainer: Color(0xffb6f1bb),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff16130b),
      onBackground: Color(0xffeae1d4),
      surface: Color(0xff16130b),
      onSurface: Color(0xffeae1d4),
      surfaceVariant: Color(0xff4c4639),
      onSurfaceVariant: Color(0xffcfc5b4),
      outline: Color(0xff989080),
      outlineVariant: Color(0xff4c4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae1d4),
      inverseOnSurface: Color(0xff343027),
      inversePrimary: Color(0xff745b0c),
      primaryFixed: Color(0xffffe08e),
      onPrimaryFixed: Color(0xff241a00),
      primaryFixedDim: Color(0xffe4c36c),
      onPrimaryFixedVariant: Color(0xff584400),
      secondaryFixed: Color(0xffffdf92),
      onSecondaryFixed: Color(0xff241a00),
      secondaryFixedDim: Color(0xffe5c36c),
      onSecondaryFixedVariant: Color(0xff594400),
      tertiaryFixed: Color(0xffb6f1bb),
      onTertiaryFixed: Color(0xff002109),
      tertiaryFixedDim: Color(0xff9bd4a0),
      onTertiaryFixedVariant: Color(0xff1b5129),
      surfaceDim: Color(0xff16130b),
      surfaceBright: Color(0xff3d392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2a21),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe8c870),
      surfaceTint: Color(0xffe4c36c),
      onPrimary: Color(0xff1e1500),
      primaryContainer: Color(0xffaa8e3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe9c770),
      onSecondary: Color(0xff1e1500),
      secondaryContainer: Color(0xffab8d3d),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff9fd8a4),
      onTertiary: Color(0xff001b07),
      tertiaryContainer: Color(0xff679d6e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff16130b),
      onBackground: Color(0xffeae1d4),
      surface: Color(0xff16130b),
      onSurface: Color(0xfffffaf6),
      surfaceVariant: Color(0xff4c4639),
      onSurfaceVariant: Color(0xffd3cab8),
      outline: Color(0xffaba291),
      outlineVariant: Color(0xff8a8273),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae1d4),
      inverseOnSurface: Color(0xff2e2a21),
      inversePrimary: Color(0xff5a4500),
      primaryFixed: Color(0xffffe08e),
      onPrimaryFixed: Color(0xff171000),
      primaryFixedDim: Color(0xffe4c36c),
      onPrimaryFixedVariant: Color(0xff443400),
      secondaryFixed: Color(0xffffdf92),
      onSecondaryFixed: Color(0xff181000),
      secondaryFixedDim: Color(0xffe5c36c),
      onSecondaryFixedVariant: Color(0xff453400),
      tertiaryFixed: Color(0xffb6f1bb),
      onTertiaryFixed: Color(0xff001505),
      tertiaryFixedDim: Color(0xff9bd4a0),
      onTertiaryFixedVariant: Color(0xff053f1a),
      surfaceDim: Color(0xff16130b),
      surfaceBright: Color(0xff3d392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2a21),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffffaf6),
      surfaceTint: Color(0xffe4c36c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe8c870),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffffaf6),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe9c770),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff0ffec),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9fd8a4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff16130b),
      onBackground: Color(0xffeae1d4),
      surface: Color(0xff16130b),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4c4639),
      onSurfaceVariant: Color(0xfffffaf6),
      outline: Color(0xffd3cab8),
      outlineVariant: Color(0xffd3cab8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae1d4),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff352800),
      primaryFixed: Color(0xffffe4a3),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe8c870),
      onPrimaryFixedVariant: Color(0xff1e1500),
      secondaryFixed: Color(0xffffe4a6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe9c770),
      onSecondaryFixedVariant: Color(0xff1e1500),
      tertiaryFixed: Color(0xffbbf5bf),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff9fd8a4),
      onTertiaryFixedVariant: Color(0xff001b07),
      surfaceDim: Color(0xff16130b),
      surfaceBright: Color(0xff3d392f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2a21),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

@immutable
final class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      surfaceTint: surfaceTint,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
      primaryFixed: primaryFixed,
      onPrimaryFixed: onPrimaryFixed,
      primaryFixedDim: primaryFixedDim,
      onPrimaryFixedVariant: onPrimaryFixedVariant,
      secondaryFixed: secondaryFixed,
      onSecondaryFixed: onSecondaryFixed,
      secondaryFixedDim: secondaryFixedDim,
      onSecondaryFixedVariant: onSecondaryFixedVariant,
      tertiaryFixed: tertiaryFixed,
      onTertiaryFixed: onTertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim,
      onTertiaryFixedVariant: onTertiaryFixedVariant,
      surfaceDim: surfaceDim,
      surfaceBright: surfaceBright,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
    );
  }
}

@immutable
final class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;
}

@immutable
final class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
