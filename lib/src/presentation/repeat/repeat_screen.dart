import 'dart:async';

import 'package:comfy_memo/src/common/bloc_scope.dart';
import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/repeat_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_with_due_entity.dart';
import 'package:comfy_memo/src/presentation/common/custom_text_field.dart';
import 'package:comfy_memo/src/presentation/common/flip_card.dart';
import 'package:comfy_memo/src/presentation/repeat/dialogs.dart';
import 'package:comfy_memo/src/presentation/repeat/term_card.dart';
import 'package:flutter/material.dart';

typedef RateCallback = void Function(LearningRating);

base class RepeatScreen extends StatefulWidget {
  const RepeatScreen({
    required this.entity,
    super.key,
  });

  final FlashcardWithDueEntity entity;

  @override
  State<RepeatScreen> createState() => _RepeatScreenState();
}

base class _RepeatScreenState extends State<RepeatScreen> {
  late FlashcardRepeatBloc _repeatBloc;
  StreamSubscription<FlashcardRepeatState>? _repeatStateSubscription;

  final TextEditingController _controller = TextEditingController();
  LearningRating? _learningRating;
  bool _isPreview = true;
  bool _isOnceViewed = false;
  bool _isOnceRate = false;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _isLoading.dispose();
    _controller.dispose();
    unawaited(_repeatStateSubscription?.cancel());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _repeatBloc = BlocScope.of(context).repeatBloc;
    _repeatStateSubscription ??= _repeatBloc.stream.listen(_onRepeatState);
    super.didChangeDependencies();
  }

  Future<void> _onRepeatState(FlashcardRepeatState state) async {
    if (!context.mounted) return;
    switch (state) {
      case FlashcardRepeatState$Idle():
        _isLoading.value = false;
      case FlashcardRepeatState$Loading():
        _isLoading.value = true;
      case FlashcardRepeatState$Success():
        _isLoading.value = false;
        const snackBar = SnackBar(
          content: Text('Rating has been successfully accepted'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      case final FlashcardRepeatState$Error error:
        _isLoading.value = false;
        final snackBar = SnackBar(
          content: Text('An error occured: ${error.message}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _onClose(BuildContext context) async {
    if (!context.mounted) return;

    if (!_isOnceViewed) {
      Navigator.pop(context);
      return;
    }

    if (_learningRating case final rating?) {
      _repeatBloc.sink.add(
        FlashcardRepeatEvent$Rate(
          rating: rating,
          cardId: widget.entity.id,
        ),
      );
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

  Future<void> _onRatingChanged(LearningRating? rating) async {
    _learningRating = rating;
    if (!_isOnceRate && rating != null) {
      _isOnceRate = true;
      await _onFirstRate(context);
    }
  }

  void _onFlip() {
    _isOnceViewed = true;
    setState(() {
      _isPreview = !_isPreview;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.entity.selfVerifyType == SelfVerifyType.written ? 0.92 : 0.62;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        bottom: RepeatScreenAppBarBottomTitle(title: widget.entity.title),
        leading: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, value, _) => IconButton(
            onPressed: value ? null : () async => _onClose(context),
            icon: value
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.arrow_back_rounded),
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
                onTapCallback: _onFlip,
                front: TermCardTermSide(
                  aspectRatio: aspectRatio,
                  term: widget.entity.term,
                ),
                back: TermCardRateSide(
                  aspectRatio: aspectRatio,
                  term: widget.entity.definition,
                  onRatingChanged: _onRatingChanged,
                ),
              ),
              if (widget.entity.selfVerifyType == SelfVerifyType.written)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: CustomTextFormField(
                    label: 'Self Verify',
                    isEnabled: _isPreview,
                    isCleanable: true,
                    minLines: 6,
                    maxLines: 6,
                    controller: _controller,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

base class RepeatScreenAppBarBottomTitle extends StatelessWidget
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
