import 'dart:async';

import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/presentation/add_card/add_card_screen.dart';
import 'package:comfy_memo/src/presentation/main_list/repeat_card.dart';
import 'package:comfy_memo/src/presentation/repeat/repeat_screen.dart';
import 'package:flutter/material.dart';

base class MainListScreen extends StatelessWidget {
  const MainListScreen({super.key});

  Future<void> _onAdd(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: AddCardScreen.createMode(
          onCreate: (_) {},
        ),
      ),
    );
  }

  Future<void> _onEdit(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: AddCardScreen.editMode(
          onEdit: (_) {},
          onDelete: () {},
          titleInitialValue: 'Hello world',
          termInitialValue: 'termInitialValue',
          definitionInitialValue: 'definitionInitialValue',
          selfVerifyTypeInitialValue: SelfVerifyType.written,
        ),
      ),
    );
  }

  Future<void> _onOpen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RepeatScreen(
          title: 'Lorem ipsum dolor sit amet consectetur. '
              'Diam dui nunc amet pharetra magna vitae',
          term: 'Lorem ipsum dolor sit amet consectetur. '
                  'Ac sit sit tellus velit quam consequat '
                  'eleifend dapibus ipsum. '
                  'Integer pulvinar metus pretium diam a '
                  'felis quis eu elementum. '
                  'Mi cras suspendisse risus nec. '
                  'Justo nulla facilisi vulputate neque nec fringilla. ' *
              20,
          selfVerifyType: SelfVerifyType.written,
          onRate: (_) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cards = [
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Tortor etiam sit diam feugiat. '
            'Egestas pellentesque lobortis risus nec in a pulvinar. '
            'Ultrices etiam amet netus elit. ',
        isRepeatTime: true,
        onOpen: () async => _onOpen(context),
        onEdit: () async => _onEdit(context),
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur. '
            'Diam dui nunc amet pharetra magna vitae',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Urna auctor quis facilisis cursus neque eu feugiat. '
            'Vulputate nibh risus eu massa condimentum lorem tristique. '
            'Amet sit dolor id velit. '
            'Odio hac pharetra ultricies in. '
            'Amet quam donec lacus maecenas id vitae diam vitae tincidunt.',
        isRepeatTime: true,
        onOpen: () async => _onOpen(context),
        onEdit: () async => _onEdit(context),
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Faucibus euismod donec urna eget in dui amet ultricies neque.',
        isRepeatTime: false,
        onOpen: () async => _onOpen(context),
        onEdit: () async => _onEdit(context),
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur.',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Ac sit sit tellus velit quam consequat eleifend dapibus ipsum. '
            'Integer pulvinar metus pretium diam a felis quis eu elementum. '
            'Mi cras suspendisse risus nec. '
            'Justo nulla facilisi vulputate neque nec fringilla. ',
        isRepeatTime: false,
        onOpen: () async => _onOpen(context),
        onEdit: () async => _onEdit(context),
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur.',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Ac sit sit tellus velit quam consequat eleifend dapibus ipsum. '
            'Integer pulvinar metus pretium diam a felis quis eu elementum. '
            'Mi cras suspendisse risus nec. '
            'Justo nulla facilisi vulputate neque nec fringilla. ',
        isRepeatTime: false,
        onOpen: () async => _onOpen(context),
        onEdit: () async => _onEdit(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: colorScheme.onTertiaryContainer,
        backgroundColor: colorScheme.tertiaryContainer,
        child: const Icon(Icons.add_rounded),
        onPressed: () async => _onAdd(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (_, index) => Padding(
            padding:
                EdgeInsets.only(bottom: index == cards.length - 1 ? 16 : 12),
            child: cards[index],
          ),
        ),
      ),
    );
  }
}
