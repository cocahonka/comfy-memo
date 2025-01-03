import 'dart:async';

import 'package:comfy_memo/domain/flashcard/controller/flashcard_edit_controller.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/view/common/custom_text_field.dart';
import 'package:comfy_memo/view/common/extensions.dart';
import 'package:comfy_memo/view/common/icon_button_with_custom_background.dart';
import 'package:comfy_memo/view/edit_card/dialogs.dart';
import 'package:comfy_memo/view/edit_card/self_verify_selector.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:flutter/material.dart';

class EditCardScreen extends StatefulWidget {
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

class _EditCardScreenState extends State<EditCardScreen> {
  late final GlobalKey<FormState> _formKey;
  late FlashcardEditController _editController;
  late final TextEditingController _titleContoller;
  late final TextEditingController _termController;
  late final TextEditingController _definitionController;
  late SelfVerify _selfVerify;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _titleContoller = TextEditingController(text: widget.flashcard?.title);
    _termController = TextEditingController(text: widget.flashcard?.term);
    _definitionController =
        TextEditingController(text: widget.flashcard?.definition);
    _selfVerify = widget.selfVerifyInitialValue;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _editController =
        context.controllerOf<FlashcardEditController>(listen: true)
          ..removeListener(_onEditStateChanged)
          ..addListener(_onEditStateChanged);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleContoller.dispose();
    _termController.dispose();
    _definitionController.dispose();
    _editController.removeListener(_onEditStateChanged);
    super.dispose();
  }

  void _onEditStateChanged() {
    final state = _editController.state;

    switch (state) {
      case EditState$Success():
        Navigator.pop(context);
        Navigator.pop(context);
      case final EditState$Error error:
        _showError(error.message);
      case EditState$Loading():
        _showLoading();
      case EditState$Idle():
    }
  }

  void _showLoading() => unawaited(
        showDialog(
          context: context,
          builder: (context) => const EditDialog$Loading(),
        ),
      );

  void _showError(String message) {
    final snackBar = SnackBar(
      content: Text('An error occured: $message'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  ({String title, String term, String definition}) get textFieldValues => (
        title: _titleContoller.trimmedText,
        term: _termController.trimmedText,
        definition: _definitionController.trimmedText
      );

  bool get isAnythingChanged {
    final (:title, :term, :definition) = textFieldValues;
    return title != (widget.flashcard?.title ?? '') ||
        term != (widget.flashcard?.term ?? '') ||
        definition != (widget.flashcard?.definition ?? '') ||
        _selfVerify != widget.selfVerifyInitialValue;
  }

  void _onSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (!isAnythingChanged) {
      Navigator.pop(context);
      return;
    }

    final (:title, :term, :definition) = textFieldValues;

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
  }

  Future<void> _onClose() async {
    if (!mounted) return;

    if (!isAnythingChanged) {
      Navigator.pop(context);
      return;
    }

    final isDiscarded = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const EditDialog$DiscardChanges(),
        ) ??
        false;

    if (mounted && isDiscarded) Navigator.pop(context);
  }

  Future<void> _onDelete() async {
    if (!mounted) return;

    final isConfirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const EditDialog$DeleteCard(),
        ) ??
        false;

    if (mounted && isConfirmed) {
      unawaited(
        _editController.delete(
          widget.flashcard!.id,
        ),
      );
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
          onPressed: _onClose,
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
                  onPressed: _onDelete,
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
            key: _formKey,
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
