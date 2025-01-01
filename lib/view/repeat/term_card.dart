import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:comfy_memo/view/repeat/repeat_rating_selector.dart';
import 'package:flutter/material.dart';

class RepeatCard extends StatelessWidget {
  const RepeatCard({
    required this.aspectRatio,
    required this.child,
    super.key,
  });

  final double aspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class RepeatCard$Term extends StatelessWidget {
  const RepeatCard$Term({
    required this.aspectRatio,
    required this.term,
    super.key,
  });

  final double aspectRatio;
  final String term;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepeatCard(
      aspectRatio: aspectRatio,
      child: SingleChildScrollView(
        child: Text(
          term,
          textAlign: TextAlign.justify,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class RepeatCard$Rate extends StatelessWidget {
  const RepeatCard$Rate({
    required this.aspectRatio,
    required this.term,
    required this.onRatingChanged,
    super.key,
  });

  final double aspectRatio;
  final String term;
  final ValueChanged<RepeatRating?> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepeatCard(
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
                    RepeatRatingSelector(onSelectionChanged: onRatingChanged),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
