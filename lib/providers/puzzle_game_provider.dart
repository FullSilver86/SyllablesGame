import 'package:flutter/material.dart';

class Positions extends ChangeNotifier {
  double _puzzleBoardOffsetdx = 0.0;
  double _puzzleBoardOffsetdy = 0.0;
  double _puzzleElementOffsetdx = 1.0;
  double _puzzleElementOffsetdy = 1.0;

  get boardOffset => [_puzzleBoardOffsetdx, _puzzleBoardOffsetdy];
  get puzzleOffset => [_puzzleElementOffsetdx, _puzzleElementOffsetdy];

  void setBoardOffset(newOffsetdx, newOffsetdy) {
    _puzzleBoardOffsetdx = newOffsetdx;
    _puzzleBoardOffsetdy = newOffsetdy;
  }

  void setPuzzleElementOffset(newOffsetdx, newOffsetdy) {
    _puzzleElementOffsetdx = newOffsetdx;
    _puzzleElementOffsetdy = newOffsetdy;
  }
}
