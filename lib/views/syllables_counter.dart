import 'package:flutter/material.dart';
import 'package:learnignflutter/views/search_game.dart';

class SyllablesCounter extends StatefulWidget {
  const SyllablesCounter({super.key});

  @override
  State<SyllablesCounter> createState() => _SyllablesCounterState();
}

class _SyllablesCounterState extends State<SyllablesCounter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: [for (var i = 0; i < 8; i++) const SyllableButton()],
      ),
    );
  }
}

class SyllableButton extends StatelessWidget {
  const SyllableButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchGame()),
          );
        },
        icon: Image.asset(
          'assets/images/home_screen_button1.png',
        ),
        iconSize: 200);
  }
}
