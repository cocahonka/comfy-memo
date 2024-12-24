import 'dart:async';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard_with_due.dart';
import 'package:comfy_memo/domain/scheduler_entry/controller/repeat_controller.dart';
import 'package:comfy_memo/view/common/custom_text_field.dart';
import 'package:comfy_memo/view/common/flip_card.dart';
import 'package:comfy_memo/view/repeat/dialogs.dart';
import 'package:comfy_memo/view/repeat/term_card.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:flutter/material.dart';

class RepeatScreen extends StatefulWidget {
  const RepeatScreen({
    required this.flashcard,
    super.key,
  });

  final FlashcardWithDue flashcard;

  @override
  State<RepeatScreen> createState() => _RepeatScreenState();
}

class _RepeatScreenState extends State<RepeatScreen> {
  late RepeatController _repeatController;
  final TextEditingController _textController = TextEditingController();

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
    switch (state) {
      case RepeatState$Initial():
        break;
      case RepeatState$Answered():
        break;
      case RepeatState$Loading():
        break;
      case final RepeatState$Error error:
        final snackBar = SnackBar(
          content: Text('An error occured: ${error.message}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      case final RepeatState$Success success:
        final due = success.due.difference(DateTime.now().toUtc());
        final String nextRepeat;
        if (due.inDays > 0) {
          nextRepeat = '${due.inDays} days';
        } else if (due.inHours > 0) {
          nextRepeat = '${due.inHours} hours';
        } else if (due.inMinutes > 0) {
          nextRepeat = '${due.inMinutes} minutes';
        } else {
          nextRepeat = '${due.inSeconds} seconds';
        }

        final snackBar = SnackBar(
          content: Text(
            'Rating has been successfully accepted! '
            'The next repeat in $nextRepeat',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
    }
  }

  Future<void> _onClose(BuildContext context) async {
    if (!context.mounted) return;

    if (!_repeatController.value.hasEverAnswered) {
      Navigator.pop(context);
      return;
    }

    if (_repeatController.value.rating != null) {
      unawaited(_repeatController.submitRating(cardId: widget.flashcard.id));
      return;
    }

    final isCanceled = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const ExitWithoutRateDialog(),
        ) ??
        true;

    if (!isCanceled && context.mounted) Navigator.of(context).pop();
  }

  Future<void> _onFirstRate(BuildContext context) async {
    if (!context.mounted) return;

    final snackBar = SnackBar(
      content: const Text(
        'Now you can exit the card, '
        'your rate will be taken! :)',
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Exit',
        onPressed: () async => _onClose(context),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.flashcard.selfVerify == SelfVerify.written ? 0.92 : 0.62;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        bottom: RepeatScreenAppBarBottomTitle(title: widget.flashcard.title),
        leading: RepaintBoundary(
          child: ValueListenableBuilder(
            valueListenable: _repeatController,
            builder: (_, value, __) {
              // TODO: Select states
              final isLoading = value is RepeatState$Loading;
              return IconButton(
                onPressed: isLoading ? null : () async => _onClose(context),
                icon: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Icon(Icons.arrow_back_rounded),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              FlipCard(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                onFlipped: (state) => _repeatController.answer(),
                front: TermCardTermSide(
                  aspectRatio: aspectRatio,
                  term: widget.flashcard.term,
                ),
                back: TermCardRateSide(
                  aspectRatio: aspectRatio,
                  term: widget.flashcard.definition,
                  // TODO: Select states
                  onRatingChanged: (rating) => _repeatController.rate(
                    rating,
                    onFirstRate: () => unawaited(_onFirstRate(context)),
                  ),
                ),
              ),
              if (widget.flashcard.selfVerify == SelfVerify.written)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: ValueListenableBuilder(
                    valueListenable: _repeatController,
                    builder: (context, state, _) => CustomTextFormField(
                      label: 'Self Verify',
                      isEnabled: state is RepeatState$Initial,
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
}

class RepeatScreenAppBarBottomTitle extends StatelessWidget
    implements PreferredSizeWidget {
  const RepeatScreenAppBarBottomTitle({required this.title, super.key});

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
