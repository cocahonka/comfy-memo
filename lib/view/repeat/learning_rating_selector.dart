import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:flutter/material.dart';

class LearningRatingSelector extends StatefulWidget {
  const LearningRatingSelector({
    required this.onSelectionChanged,
    super.key,
  });

  final ValueSetter<RepeatRating?> onSelectionChanged;

  @override
  State<LearningRatingSelector> createState() => _LearningRatingSelectorState();
}

class _LearningRatingSelectorState extends State<LearningRatingSelector> {
  RepeatRating? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SegmentedButton<RepeatRating>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        selectedForegroundColor: theme.colorScheme.onSecondaryContainer,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      segments: const [
        ButtonSegment(
          value: RepeatRating.forgot,
          label: Text('Forgot'),
        ),
        ButtonSegment(
          value: RepeatRating.hard,
          label: Text('Hard'),
        ),
        ButtonSegment(
          value: RepeatRating.good,
          label: Text('Good'),
        ),
        ButtonSegment(
          value: RepeatRating.perfect,
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
