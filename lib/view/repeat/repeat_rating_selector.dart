import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:flutter/material.dart';

class RepeatRatingSelector extends StatefulWidget {
  const RepeatRatingSelector({
    required this.onSelectionChanged,
    super.key,
  });

  final ValueChanged<RepeatRating?> onSelectionChanged;

  @override
  State<RepeatRatingSelector> createState() => _RepeatRatingSelectorState();
}

class _RepeatRatingSelectorState extends State<RepeatRatingSelector> {
  RepeatRating? _rating;

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
      selected: {if (_rating case final rating?) rating},
      onSelectionChanged: (newSelection) {
        setState(() {
          _rating = newSelection.firstOrNull;
          widget.onSelectionChanged(_rating);
        });
      },
    );
  }
}
