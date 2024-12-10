import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/presentation/main_list/main_list_screen.dart';
import 'package:comfy_memo/src/presentation/theme/theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

ColorScheme _adaptDynamicColorScheme(ColorScheme colorScheme) {
  final schemeBase = ColorScheme.fromSeed(
    seedColor: colorScheme.primary,
    brightness: colorScheme.brightness,
  );

  return schemeBase.harmonized();
}

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const themeMode = ThemeMode.system;
    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final ThemeData lightTheme;
        final ThemeData darkTheme;

        if (kDebugMode) {
          (lightDynamic, darkDynamic) = (null, null);
        }

        if (lightDynamic != null && darkDynamic != null) {
          lightTheme = theme.theme(_adaptDynamicColorScheme(lightDynamic));
          darkTheme = theme.theme(_adaptDynamicColorScheme(darkDynamic));
        } else {
          lightTheme = theme.light();
          darkTheme = theme.dark();
        }

        return MaterialApp(
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          title: Constants.appName,
          home: const MainListScreen(),
        );
      },
    );
  }
}
