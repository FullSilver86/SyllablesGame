import 'package:audioplayers/audioplayers.dart';

class PlaySyllable extends AudioPlayer {
  int currentIndex = 0;
  AudioPlayer audioPlayer;

  PlaySyllable(this.audioPlayer);

  void nextTrack(List<String> syllables, int currentIndex) {
    playSyllable(syllables, currentIndex);
  }

  void playSyllable(List<String> syllables, int currentIndex) async {
    String syllable = syllables[currentIndex];
    await audioPlayer.play(AssetSource('sounds/sylabes/$syllable.mp3'));
    audioPlayer.onPlayerComplete.listen((event) {
      if (currentIndex < syllables.length - 1) {
        currentIndex = currentIndex + 1;
        nextTrack(syllables, currentIndex);
      }
    });
  }
}
