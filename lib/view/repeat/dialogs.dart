import 'package:flutter/material.dart';

class RepeatDialog$ExitWithoutRate extends StatelessWidget {
  const RepeatDialog$ExitWithoutRate({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Exit without a rate?'),
      content: Text(
        'A card will not be considered repeated '
        'without a rate!',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Exit'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
