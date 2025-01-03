import 'package:flutter/material.dart';

class EditDialog$DiscardChanges extends StatelessWidget {
  const EditDialog$DiscardChanges({super.key});

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

class EditDialog$DeleteCard extends StatelessWidget {
  const EditDialog$DeleteCard({super.key});

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

class EditDialog$Loading extends StatelessWidget {
  const EditDialog$Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: 64,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
