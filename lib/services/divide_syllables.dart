List<String> divideWordIntoSyllables(String word, List<String> syllables) {
  List<String> dividedWord = [];

  int startIndex = 0;
  int endIndex = word.length;
  while (startIndex != endIndex) {
    for (var i = endIndex; i >= startIndex; i--) {
      String syllable = word.substring(startIndex, i);
      if (syllables.contains(syllable)) {
        dividedWord.add(syllable);
        startIndex = i;
        break;
      }
    }
  }
  return dividedWord;
}
