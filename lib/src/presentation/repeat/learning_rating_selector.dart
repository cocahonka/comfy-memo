import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:flutter/material.dart';

@immutable
base class LearningRatingSelector extends StatefulWidget {
  const LearningRatingSelector({
    required this.onSelectionChanged,
    super.key,
  });

  final ValueSetter<LearningRating?> onSelectionChanged;

  @override
  State<LearningRatingSelector> createState() => _LearningRatingSelectorState();
}

base class _LearningRatingSelectorState extends State<LearningRatingSelector> {
  LearningRating? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SegmentedButton<LearningRating>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        selectedForegroundColor: theme.colorScheme.onSecondaryContainer,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      segments: const [
        ButtonSegment(
          value: LearningRating.forgot,
          label: Text('Forgot'),
        ),
        ButtonSegment(
          value: LearningRating.hard,
          label: Text('Hard'),
        ),
        ButtonSegment(
          value: LearningRating.good,
          label: Text('Good'),
        ),
        ButtonSegment(
          value: LearningRating.perfect,
          label: Text('Perfect'),
        ),
      ],
      selected: {if (_selected != null) _selected!},
      onSelectionChanged: (newSelection) {
        setState(() {
          _selected = newSelection.firstOrNull;
          widget.onSelectionChanged(_selected);
        });
      },
    );
  }
}
