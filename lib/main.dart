import 'package:flutter/material.dart';
import 'package:learnignflutter/views/home.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
// inicjalizacja obiektu TTS
  FlutterTts flutterTts = FlutterTts();

// funkcja, która odczytuje sylaby
  Future<void> speak(String syllable) async {
    await flutterTts.speak(syllable);
  }

// przykładowe użycie
  speak("ma");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    ),
  );
}
