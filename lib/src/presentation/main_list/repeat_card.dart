import 'package:flutter/material.dart';

base class RepeatCard extends StatelessWidget {
  const RepeatCard({
    required this.title,
    required this.term,
    required this.isRepeatTime,
    required VoidCallback onOpen,
    required VoidCallback onEdit,
    super.key,
  })  : _onOpen = onOpen,
        _onEdit = onEdit;

  final String title;
  final String term;
  final bool isRepeatTime;
  final VoidCallback _onOpen;
  final VoidCallback _onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _onOpen,
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RepeatCardHeadline(title: title, onEdit: _onEdit),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: RepeatCardBody(term: term),
              ),
              if (isRepeatTime)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: RepeatCardNotification(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

base class RepeatCardHeadline extends StatelessWidget {
  const RepeatCardHeadline({
    required this.title,
    required VoidCallback onEdit,
    super.key,
  }) : _onEdit = onEdit;

  final String title;
  final VoidCallback _onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton.filledTonal(
            onPressed: _onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }
}

base class RepeatCardBody extends StatelessWidget {
  const RepeatCardBody({required this.term, super.key});

  final String term;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      term,
      style: theme.textTheme.bodyMedium
          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }
}

base class RepeatCardNotification extends StatelessWidget {
  const RepeatCardNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Time to repeat!',
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}
