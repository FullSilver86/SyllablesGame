import 'package:flutter/material.dart';
import 'package:learnignflutter/services/play_syllable.dart';
import 'package:learnignflutter/views/syllables_counter.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = PlaySyllable(AudioPlayer());
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Column with buttons in the center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/home_screen_button1.png',
                  ),
                  iconSize: 300,
                  onPressed: () async {
                    audioPlayer.playSyllable(['sy', 'la', 'by'], 0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SyllablesCounter(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
