import 'package:comfy_memo/src/presentation/common/deffered_value_listenable_builder.dart';
import 'package:flutter/material.dart';

base class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.label,
    required TextEditingController controller,
    this.isCleanable = false,
    this.isEnabled = true,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.autovalidateMode = AutovalidateMode.onUnfocus,
    this.validator,
    super.key,
  }) : _controller = controller;

  final String label;
  final bool isCleanable;
  final bool isEnabled;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<String>? validator;
  final TextEditingController _controller;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

base class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final WidgetStatesController _widgetStatesController =
      WidgetStatesController();
  late ThemeData _theme;

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _widgetStatesController.dispose();
    super.dispose();
  }

  WidgetStateColor get _suffixIconColor => WidgetStateColor.resolveWith(
        (states) {
          final colors = _theme.colorScheme;
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withOpacity(0.38);
          }
          if (states.contains(WidgetState.error)) {
            if (states.contains(WidgetState.hovered)) {
              return colors.onErrorContainer;
            }
            return colors.error;
          }
          if (states.contains(WidgetState.focused)) {
            return colors.primary;
          }
          return colors.onSurfaceVariant;
        },
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          autovalidateMode: widget.autovalidateMode,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          controller: widget._controller,
          maxLength: widget.maxLength,
          enabled: widget.isEnabled,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(widget.label),
            alignLabelWithHint: true,
            suffixIcon: widget.isCleanable && widget.isEnabled
                ? const SizedBox.shrink()
                : null,
          ),
          statesController: _widgetStatesController,
          validator: widget.validator,
        ),
        if (widget.isCleanable && widget.isEnabled)
          Positioned(
            right: 12,
            top: 16,
            child: ValueListenableBuilder(
              valueListenable: widget._controller,
              builder: (context, textEditingValue, _) => Visibility(
                visible: textEditingValue.text.isNotEmpty,
                child: DefferedValueListenableBuilder(
                  valueListenable: _widgetStatesController,
                  builder: (context, states, _) => GestureDetector(
                    onTap: widget._controller.clear,
                    child: Icon(
                      Icons.cancel_outlined,
                      color: _suffixIconColor.resolve(states),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
