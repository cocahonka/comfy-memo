import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:flutter/material.dart';

class SelfVerifySelector extends StatefulWidget {
  const SelfVerifySelector({
    required this.initialValue,
    required this.onSelectionChanged,
    super.key,
  });

  final ValueSetter<SelfVerify> onSelectionChanged;
  final SelfVerify initialValue;

  @override
  State<SelfVerifySelector> createState() => _SelfVerifySelectorState();
}

class _SelfVerifySelectorState extends State<SelfVerifySelector> {
  late SelfVerify _selected = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Self Verify', style: theme.textTheme.titleLarge),
        SegmentedButton<SelfVerify>(
          segments: const [
            ButtonSegment(
              value: SelfVerify.none,
              label: Text('None'),
            ),
            ButtonSegment(
              value: SelfVerify.written,
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
