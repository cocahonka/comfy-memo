import 'dart:async';
import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:comfy_memo/domain/common/listenable_selector.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/domain/scheduler_entry/controller/repeat_controller.dart';
import 'package:comfy_memo/view/common/custom_text_field.dart';
import 'package:comfy_memo/view/common/flip_card.dart';
import 'package:comfy_memo/view/repeat/dialogs.dart';
import 'package:comfy_memo/view/repeat/term_card.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:flutter/material.dart';

class RepeatScreen extends StatefulWidget {
  const RepeatScreen({required this.flashcard, super.key});

  final Flashcard flashcard;

  @override
  State<RepeatScreen> createState() => _RepeatScreenState();
}

class _RepeatScreenState extends State<RepeatScreen> {
  late RepeatController _repeatController;
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _repeatController = context.controllerOf<RepeatController>(listen: true);
    _repeatController.removeListener(_onRepeatState);
    _repeatController.addListener(_onRepeatState);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textController.dispose();
    _repeatController.removeListener(_onRepeatState);
    super.dispose();
  }

  void _onRepeatState() {
    final state = _repeatController.value;
    if (state case final RepeatState$Error error) {
      _showErrorSnackbar(error.message);
    } else if (state case final RepeatState$Success success) {
      _showNextRepeatSnackbar(
        success.due.difference(DateTime.now().toUtc()),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _onClose() async {
    if (!mounted) return;

    final state = _repeatController.state;
    if (state.isNeverAnswered) {
      Navigator.pop(context);
      return;
    }
    if (state.rating != null) {
      unawaited(_repeatController.submitRating(cardId: widget.flashcard.id));
      return;
    }

    final isExitCanceled = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const RepeatDialog$ExitWithoutRate(),
        ) ??
        true;

    if (mounted && !isExitCanceled) Navigator.of(context).pop();
  }

  void _onFlipped(FlipCardState state) {
    switch (state) {
      case FlipCardState.front:
        _repeatController.unanswer();
      case FlipCardState.back:
        _repeatController.answer();
    }
  }

  void _onRatingChanged(RepeatRating? rating) => _repeatController.rate(
        rating,
        onFirstRate: _showFirstRateSnackbar,
      );

  @override
  Widget build(BuildContext context) {
    // TODO: Add pop scope
    final repeatCardAspectRatio =
        widget.flashcard.selfVerify == SelfVerify.written ? 0.92 : 0.62;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        bottom: RepeatScreen$AppBar$Bottom(title: widget.flashcard.title),
        leading: RepeatScreen$AppBar$Leading(onPressed: _onClose),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              FlipCard(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                onFlipped: _onFlipped,
                front: RepeatCard$Term(
                  aspectRatio: repeatCardAspectRatio,
                  term: widget.flashcard.term,
                ),
                back: RepeatCard$Rate(
                  aspectRatio: repeatCardAspectRatio,
                  term: widget.flashcard.definition,
                  onRatingChanged: _onRatingChanged,
                ),
              ),
              if (widget.flashcard.selfVerify == SelfVerify.written)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: ValueListenableBuilder(
                    valueListenable: _repeatController.select(
                      (controller) => controller.state,
                      (prev, next) => prev.isInitial != next.isInitial,
                    ),
                    builder: (_, state, __) => CustomTextFormField(
                      label: 'Self Verify',
                      isEnabled: state.isInitial,
                      isCleanable: true,
                      minLines: 6,
                      maxLines: 6,
                      controller: _textController,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String error) {
    final snackbar = SnackBar(
      content: Text('An error occured: $error'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  void _showNextRepeatSnackbar(Duration nextRepeat) {
    String formatDuration(Duration duration) {
      if (duration.inDays > 0) return '${duration.inDays} days';
      if (duration.inHours > 0) return '${duration.inHours} hours';
      if (duration.inMinutes > 0) return '${duration.inMinutes} minutes';
      return '${duration.inSeconds} seconds';
    }

    final snackBar = SnackBar(
      content: Text(
        'Rating has been successfully accepted! '
        'The next repeat in ${formatDuration(nextRepeat)}',
      ),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _showFirstRateSnackbar() {
    final snackBar = SnackBar(
      content: const Text(
        'Now you can exit the card, '
        'your rate will be taken! :)',
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(label: 'Exit', onPressed: _onClose),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class RepeatScreen$AppBar$Leading extends StatelessWidget {
  const RepeatScreen$AppBar$Leading({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ValueListenableBuilder(
        valueListenable:
            context.controllerOf<RepeatController>(listen: true).select(
                  (controller) => controller.state,
                  (prev, next) => prev.isLoading != next.isLoading,
                ),
        builder: (_, state, __) {
          return IconButton(
            onPressed: state.isLoading ? null : onPressed,
            icon: state.isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.arrow_back_rounded),
          );
        },
      ),
    );
  }
}

class RepeatScreen$AppBar$Bottom extends StatelessWidget
    implements PreferredSizeWidget {
  const RepeatScreen$AppBar$Bottom({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
