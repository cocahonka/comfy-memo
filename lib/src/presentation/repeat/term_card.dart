import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/presentation/repeat/learning_rating_selector.dart';
import 'package:flutter/material.dart';

@immutable
base class TermCard extends StatelessWidget {
  const TermCard({
    required this.aspectRatio,
    required this.child,
    super.key,
  });

  final double aspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

@immutable
base class TermCardTermSide extends StatelessWidget {
  const TermCardTermSide({
    required this.aspectRatio,
    required this.term,
    super.key,
  });

  final double aspectRatio;
  final String term;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TermCard(
      aspectRatio: aspectRatio,
      child: SingleChildScrollView(
        child: Text(
          term,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

@immutable
base class TermCardRateSide extends StatelessWidget {
  const TermCardRateSide({
    required this.aspectRatio,
    required this.term,
    required this.onRatingChanged,
    super.key,
  });

  final double aspectRatio;
  final String term;
  final ValueChanged<LearningRating?> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TermCard(
      aspectRatio: aspectRatio,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                term,
                textAlign: TextAlign.justify,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Divider(color: theme.colorScheme.outlineVariant),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rate your answer',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child:
                    LearningRatingSelector(onSelectionChanged: onRatingChanged),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
