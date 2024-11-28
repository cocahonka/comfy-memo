import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/presentation/main_list/repeat_card.dart';
import 'package:flutter/material.dart';

@immutable
final class MainListScreen extends StatelessWidget {
  const MainListScreen({super.key});

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
        isRepeatCard: true,
        onOpen: () {},
        onEdit: () {},
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
        isRepeatCard: true,
        onOpen: () {},
        onEdit: () {},
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Faucibus euismod donec urna eget in dui amet ultricies neque.',
        isRepeatCard: false,
        onOpen: () {},
        onEdit: () {},
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur.',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Ac sit sit tellus velit quam consequat eleifend dapibus ipsum. '
            'Integer pulvinar metus pretium diam a felis quis eu elementum. '
            'Mi cras suspendisse risus nec. '
            'Justo nulla facilisi vulputate neque nec fringilla. ',
        isRepeatCard: false,
        onOpen: () {},
        onEdit: () {},
      ),
      RepeatCard(
        title: 'Lorem ipsum dolor sit amet consectetur.',
        term: 'Lorem ipsum dolor sit amet consectetur. '
            'Ac sit sit tellus velit quam consequat eleifend dapibus ipsum. '
            'Integer pulvinar metus pretium diam a felis quis eu elementum. '
            'Mi cras suspendisse risus nec. '
            'Justo nulla facilisi vulputate neque nec fringilla. ',
        isRepeatCard: false,
        onOpen: () {},
        onEdit: () {},
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
        child: const Icon(Icons.add),
        onPressed: () {},
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
