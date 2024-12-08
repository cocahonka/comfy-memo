import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/presentation/common/custom_text_field.dart';
import 'package:comfy_memo/src/presentation/common/icon_button_with_custom_background.dart';
import 'package:flutter/material.dart';

typedef EditCallback = void Function(FlashcardEditDto);
typedef CreateCallback = void Function(FlashcardCreateDto);

@immutable
base class AddCardScreen extends StatefulWidget {
  const AddCardScreen._internal({
    required this.isCreateMode,
    required this.selfVerifyTypeInitialValue,
    required this.onDelete,
    required this.onEdit,
    required this.onCreate,
    required this.titleInitialValue,
    required this.termInitialValue,
    required this.definitionInitialValue,
    super.key,
  });

  const AddCardScreen.createMode({
    required CreateCallback onCreate,
    Key? key,
  }) : this._internal(
          isCreateMode: true,
          selfVerifyTypeInitialValue: SelfVerifyType.none,
          onDelete: null,
          onEdit: null,
          onCreate: onCreate,
          titleInitialValue: null,
          termInitialValue: null,
          definitionInitialValue: null,
          key: key,
        );

  const AddCardScreen.editMode({
    required EditCallback onEdit,
    required VoidCallback onDelete,
    required String titleInitialValue,
    required String termInitialValue,
    required String definitionInitialValue,
    required SelfVerifyType selfVerifyTypeInitialValue,
    Key? key,
  }) : this._internal(
          isCreateMode: false,
          selfVerifyTypeInitialValue: selfVerifyTypeInitialValue,
          onDelete: onDelete,
          onEdit: onEdit,
          onCreate: null,
          titleInitialValue: titleInitialValue,
          termInitialValue: termInitialValue,
          definitionInitialValue: definitionInitialValue,
          key: key,
        );

  final bool isCreateMode;
  bool get isEditMode => !isCreateMode;

  final VoidCallback? onDelete;
  final EditCallback? onEdit;
  final CreateCallback? onCreate;

  final String? titleInitialValue;
  final String? termInitialValue;
  final String? definitionInitialValue;
  final SelfVerifyType selfVerifyTypeInitialValue;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

base class _AddCardScreenState extends State<AddCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController _titleContoller = TextEditingController(
    text: widget.titleInitialValue,
  );
  late final TextEditingController _termController = TextEditingController(
    text: widget.termInitialValue,
  );
  late final TextEditingController _definitionController =
      TextEditingController(
    text: widget.definitionInitialValue,
  );

  late SelfVerifyType _selfVerifyType = widget.selfVerifyTypeInitialValue;

  @override
  void dispose() {
    _titleContoller.dispose();
    _termController.dispose();
    _definitionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? text) {
    if (text?.trim() case final String trimmedText) {
      if (trimmedText.isEmpty) return 'Title must be non empty';
      return null;
    }

    return 'Title is required';
  }

  String? _validateTerm(String? text) {
    if (text?.trim() case final String trimmedText) {
      if (trimmedText.isEmpty) return 'Term must be non empty';
      return null;
    }

    return 'Term is required';
  }

  String? _validateDefinition(String? text) {
    if (text?.trim() case final String trimmedText) {
      if (trimmedText.isEmpty) return 'Definition must be non empty';
      return null;
    }

    return 'Definition is required';
  }

  void _onSave(BuildContext context) {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final title = _titleContoller.text.trim();
    final term = _termController.text.trim();
    final definition = _definitionController.text.trim();

    if (widget.isCreateMode) {
      widget.onCreate?.call(
        FlashcardCreateDto(
          title: title,
          term: term,
          definition: definition,
          selfVerifyType: _selfVerifyType,
        ),
      );
    } else {
      widget.onEdit?.call(
        FlashcardEditDto(
          title: title,
          term: term,
          definition: definition,
          selfVerifyType: _selfVerifyType,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  Future<void> _onClose(BuildContext context) async {
    final title = _titleContoller.text.trim();
    final term = _termController.text.trim();
    final definition = _definitionController.text.trim();

    if (title == (widget.titleInitialValue ?? '') &&
        term == (widget.termInitialValue ?? '') &&
        definition == (widget.definitionInitialValue ?? '')) {
      Navigator.pop(context);
    } else {
      final isDiscarded = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const DiscardDialog(),
      );

      if (context.mounted && (isDiscarded ?? false)) Navigator.pop(context);
    }
  }

  Future<void> _onDelete(BuildContext context) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const DeleteDialog(),
    );

    if (isConfirmed ?? false) {
      widget.onDelete?.call();
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.isCreateMode ? 'Add Card' : 'Edit Card'),
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () async => _onClose(context),
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: () => _onSave(context),
              child: const Text('Save'),
            ),
          ),
          if (widget.isEditMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButtonWithCustomBackground(
                iconButton: IconButton(
                  onPressed: () async => _onDelete(context),
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: theme.colorScheme.onError,
                ),
                backgroundColor: theme.colorScheme.error,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  label: 'Title',
                  minLines: 2,
                  maxLines: 2,
                  controller: _titleContoller,
                  maxLength: 80,
                  validator: _validateTitle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomTextFormField(
                    label: 'Term/Question',
                    isCleanable: true,
                    minLines: 4,
                    maxLength: 1000,
                    controller: _termController,
                    validator: _validateTerm,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomTextFormField(
                    label: 'Definition/Answer',
                    isCleanable: true,
                    minLines: 4,
                    maxLength: 1000,
                    controller: _definitionController,
                    validator: _validateDefinition,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SelfVerifyTypeSelector(
                    initialValue: widget.selfVerifyTypeInitialValue,
                    onSelectionChanged: (value) => _selfVerifyType = value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
base class DiscardDialog extends StatelessWidget {
  const DiscardDialog({super.key});

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

@immutable
base class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

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
