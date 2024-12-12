import 'dart:async';

import 'package:comfy_memo/src/common/dependencies_scope.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/edit_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/overview_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/repeat_bloc.dart';
import 'package:flutter/widgets.dart';

base class BlocScope extends StatefulWidget {
  const BlocScope({required this.child, super.key});

  final Widget child;

  static BlocScopeInherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BlocScopeInherited>()!;

  @override
  State<BlocScope> createState() => _BlocScopeState();
}

base class _BlocScopeState extends State<BlocScope> {
  late FlashcardEditBloc _editBloc;
  late FlashcardOverviewBloc _overviewBloc;
  late FlashcardRepeatBloc _repeatBloc;

  @override
  void didChangeDependencies() {
    final dependencies = DependenciesScope.of(context);
    _editBloc = FlashcardEditBloc(
      createFlashcardUsecase: dependencies.createFlashcardUsecase,
      editFlashcardUsecase: dependencies.editFlashcardUsecase,
      deleteFlashcardUsecase: dependencies.deleteFlashcardUsecase,
    );
    _overviewBloc = FlashcardOverviewBloc(
      getFlashcardsUsecase: dependencies.getFlashcardsUsecase,
    );
    _repeatBloc = FlashcardRepeatBloc(
      rateFlashcardUsecase: dependencies.rateFlashcardUsecase,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    unawaited(_editBloc.dispose());
    unawaited(_overviewBloc.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocScopeInherited(
      editBloc: _editBloc,
      overviewBloc: _overviewBloc,
      repeatBloc: _repeatBloc,
      child: widget.child,
    );
  }
}

base class BlocScopeInherited extends InheritedWidget {
  const BlocScopeInherited({
    required super.child,
    required this.editBloc,
    required this.overviewBloc,
    required this.repeatBloc,
    super.key,
  });

  final FlashcardEditBloc editBloc;
  final FlashcardOverviewBloc overviewBloc;
  final FlashcardRepeatBloc repeatBloc;

  @override
  bool updateShouldNotify(BlocScopeInherited oldWidget) =>
      !identical(editBloc, oldWidget.editBloc) ||
      !identical(overviewBloc, oldWidget.overviewBloc);
}
