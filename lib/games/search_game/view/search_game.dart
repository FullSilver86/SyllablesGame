import 'package:flutter/material.dart';
import 'dart:math';
import 'package:learnignflutter/games/puzzle_game/view/puzzle_game.dart';

class SearchGame extends StatefulWidget {
  const SearchGame({super.key});

  @override
  State<SearchGame> createState() => _SearchGameState();
}

class _SearchGameState extends State<SearchGame> {
  List<String> selectedItems = [];
  final List<String> wordsList = ['rower', 'sowa', 'tata', 'lala'];

  @override
  void initState() {
    super.initState();
    _selectRandomItems();
  }

  void _selectRandomItems() {
    int index;
    String item;

    for (int i = 0; i < 3; i++) {
      index = Random().nextInt(wordsList.length);
      item = wordsList[index];
      selectedItems.add(item);
      wordsList.removeAt(index);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background image
        Image.asset(
          'assets/images/animated/20230419_130154.gif',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Positioned(
            left: Random().nextDouble() * MediaQuery.of(context).size.width,
            top: Random().nextDouble() * MediaQuery.of(context).size.height,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (
                        context,
                      ) =>
                          Puzzles(puzzleItem: selectedItems[0]),
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/images/items/${selectedItems[0]}.png',
                ),
                iconSize: 50)),
        Positioned(
            left: Random().nextDouble() * MediaQuery.of(context).size.width,
            top: Random().nextDouble() * MediaQuery.of(context).size.height,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Puzzles(puzzleItem: selectedItems[1]),
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/images/items/${selectedItems[1]}.png',
                ),
                iconSize: 50)),
        Positioned(
            left: Random().nextDouble() * MediaQuery.of(context).size.width,
            top: Random().nextDouble() * MediaQuery.of(context).size.height,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Puzzles(puzzleItem: selectedItems[2]),
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/images/items/${selectedItems[2]}.png',
                ),
                iconSize: 50)),
      ]),
    );
  }
}
