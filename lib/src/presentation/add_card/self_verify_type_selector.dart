import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:flutter/material.dart';

@immutable
base class SelfVerifyTypeSelector extends StatefulWidget {
  const SelfVerifyTypeSelector({
    required this.initialValue,
    required this.onSelectionChanged,
    super.key,
  });

  final ValueSetter<SelfVerifyType> onSelectionChanged;
  final SelfVerifyType initialValue;

  @override
  State<SelfVerifyTypeSelector> createState() => _SelfVerifyTypeSelectorState();
}

base class _SelfVerifyTypeSelectorState extends State<SelfVerifyTypeSelector> {
  late SelfVerifyType _selected = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Self Verify', style: theme.textTheme.titleLarge),
        SegmentedButton<SelfVerifyType>(
          segments: const [
            ButtonSegment(
              value: SelfVerifyType.none,
              label: Text('None'),
            ),
            ButtonSegment(
              value: SelfVerifyType.written,
              label: Text('Write'),
            ),
          ],
          selected: {_selected},
          onSelectionChanged: (newSelection) {
            setState(() {
              _selected = newSelection.first;
              widget.onSelectionChanged(_selected);
            });
          },
        ),
      ],
    );
  }
}
