import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/presentation/main_list/main_list_screen.dart';
import 'package:comfy_memo/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

@immutable
final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const themeMode = ThemeMode.system;
    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      themeMode: themeMode,
      theme: theme.light(),
      darkTheme: theme.dark(),
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      home: const MainListScreen(),
    );
  }
}
