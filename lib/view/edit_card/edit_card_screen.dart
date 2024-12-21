import 'dart:async';

import 'package:comfy_memo/domain/flashcard/controller/flashcard_edit_controller.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/view/common/custom_text_field.dart';
import 'package:comfy_memo/view/common/icon_button_with_custom_background.dart';
import 'package:comfy_memo/view/edit_card/dialogs.dart';
import 'package:comfy_memo/view/edit_card/self_verify_selector.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:flutter/material.dart';

base class EditCardScreen extends StatefulWidget {
  const EditCardScreen._internal({
    required this.isCreateMode,
    required this.flashcard,
    required this.selfVerifyInitialValue,
    super.key,
  });

  const EditCardScreen.createMode({
    SelfVerify selfVerifyInitialValue = SelfVerify.none,
    Key? key,
  }) : this._internal(
          isCreateMode: true,
          flashcard: null,
          selfVerifyInitialValue: selfVerifyInitialValue,
          key: key,
        );

  EditCardScreen.editMode({
    required Flashcard flashcard,
    Key? key,
  }) : this._internal(
          isCreateMode: false,
          flashcard: flashcard,
          selfVerifyInitialValue: flashcard.selfVerify,
          key: key,
        );

  final bool isCreateMode;
  bool get isEditMode => !isCreateMode;

  final Flashcard? flashcard;
  final SelfVerify selfVerifyInitialValue;

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

base class _EditCardScreenState extends State<EditCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final FlashcardEditController _editController;
  late final TextEditingController _titleContoller = TextEditingController(
    text: widget.flashcard?.title,
  );
  late final TextEditingController _termController = TextEditingController(
    text: widget.flashcard?.term,
  );
  late final TextEditingController _definitionController =
      TextEditingController(
    text: widget.flashcard?.definition,
  );
  late SelfVerify _selfVerify = widget.selfVerifyInitialValue;

  @override
  void didChangeDependencies() {
    _editController =
        context.controllerOf<FlashcardEditController>(listen: true);
    super.didChangeDependencies();
  }

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

  void _onSave() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final title = _titleContoller.text.trim();
    final term = _termController.text.trim();
    final definition = _definitionController.text.trim();

    if (widget.isCreateMode) {
      unawaited(
        _editController.create(
          FlashcardCreateDto(
            title: title,
            term: term,
            definition: definition,
            selfVerify: _selfVerify,
          ),
        ),
      );
    } else {
      unawaited(
        _editController.edit(
          FlashcardEditDto(
            title: title,
            term: term,
            definition: definition,
            selfVerify: _selfVerify,
          ),
          widget.flashcard!.id,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  Future<void> _onClose(BuildContext context) async {
    final title = _titleContoller.text.trim();
    final term = _termController.text.trim();
    final definition = _definitionController.text.trim();

    if (title == (widget.flashcard?.title ?? '') &&
        term == (widget.flashcard?.term ?? '') &&
        definition == (widget.flashcard?.definition ?? '')) {
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
      unawaited(
        _editController.delete(
          widget.flashcard!.id,
        ),
      );
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
              onPressed: _onSave,
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
                  child: SelfVerifySelector(
                    initialValue: widget.selfVerifyInitialValue,
                    onSelectionChanged: (value) => _selfVerify = value,
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
