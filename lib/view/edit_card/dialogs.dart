import 'package:flutter/material.dart';

class DiscardDialog extends StatelessWidget {
  const DiscardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Discard draft?',
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.onSurface),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Discard'),
        ),
      ],
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Delete the card?'),
      content: Text(
        'The card will be deleted with all information '
        'with no possibility of recovery!',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
