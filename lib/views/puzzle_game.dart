import 'dart:math';
import 'package:flutter/material.dart';
import 'package:learnignflutter/services/divide_syllables.dart';
import 'package:learnignflutter/Utils/sylabless_lists.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import '../Utils/all_exceptions.dart';

class Puzzles extends StatefulWidget {
  final String puzzleItem;
  final List<String> puzzleSyllables;

  Puzzles({required this.puzzleItem, super.key})
      : puzzleSyllables = divideWordIntoSyllables(puzzleItem, sylablessList);

  @override
  State<Puzzles> createState() => _PuzzlesState();
}

class _PuzzlesState extends State<Puzzles> {
  final _imageKey = GlobalKey();
  Size? imageSize = Size.zero;
  late final Future<File> puzzleImageFile;
  late final Future<int> resizeValue;
  Size? originalPhotoSize;

  @override
  void initState() {
    super.initState();
    puzzleImageFile =
        _getImageFileFromAssets('images/puzzle pattern 2- alpha channel.png');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () => _updateImageSize());
    });
  }

  Future<Size> _calculateImageDimension(futurefile) {
    Completer<Size> completer = Completer();
    Image image = Image.file(futurefile);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  Future<File> _getImageFileFromAssets(String path) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = "$tempPath/$path";
    var file = File(filePath);
    if (file.existsSync()) {
      return file;
    } else {
      throw FileNotFoundException();
    }
  }

  void _updateImageSize() {
    final size = _imageKey.currentContext?.size;
    if (size == null) {}
    if (imageSize != size) {
      imageSize = size!;
      print('imagesize is $imageSize');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/images/animated/20230419_130154.gif',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(
                icon: Image.asset(
                  'assets/images/items/${widget.puzzleItem}.png',
                ),
                iconSize: 200,
                onPressed: () {}),
            Image.asset(
              'assets/images/puzzle pattern 2- alpha channel.png',
              key: _imageKey,
            )
          ]),
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0),
          body: FutureBuilder(
              future: puzzleImageFile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _calculateImageDimension(snapshot.data)
                      .then((size) => originalPhotoSize = size);
                  return Stack(
                    children: [
                      for (int i = 0; i < widget.puzzleSyllables.length; i++)
                        GestureDetectorWidget(
                          assetLocation: 'assets/images/${i + 1}element.png',
                          syl: widget.puzzleSyllables[i],
                          photoSize: originalPhotoSize,
                          resizedImageSize: imageSize,
                        ),
                    ],
                  );
                } else {
                  return const Text('Waiting');
                }
              })),
    ]);
  }
}

class GestureDetectorWidget extends StatefulWidget {
  final String assetLocation;
  final String syl;
  final Size? photoSize;
  final Size? resizedImageSize;
  double? resizeFactor;

  GestureDetectorWidget(
      {required this.syl,
      required this.assetLocation,
      required this.photoSize,
      required this.resizedImageSize,
      super.key})
      : resizeFactor = resizedImageSize != null && photoSize != null
            ? resizedImageSize.height / photoSize.height
            : 0.5;

  @override
  GestureDetectorWidgetState createState() => GestureDetectorWidgetState();
}

class GestureDetectorWidgetState extends State<GestureDetectorWidget> {
  double _x = 0;
  double _y = 0;
  final double _boxWidth = 150;
  final double _boxHeight = 150;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          // aktualizuj pozycję przeciągania
          _x += details.delta.dx;
          _y += details.delta.dy;

          // określ granice przeciągania
          if (_x < 0) {
            _x = 0;
          } else if (_x > MediaQuery.of(context).size.width - _boxWidth) {
            _x = MediaQuery.of(context).size.width - _boxWidth;
          }

          if (_y < 0) {
            _y = 0;
          } else if (_y > MediaQuery.of(context).size.height - _boxHeight) {
            _y = MediaQuery.of(context).size.height - _boxHeight;
          }
        });
      },
      child: Container(
        height: 150,
        width: 150,
        color: Colors.transparent,
        margin: EdgeInsets.only(
          left: _x,
          top: _y,
        ),
        child: Stack(
          children: [
            Center(
                child: IconButton(
              iconSize: 300 * widget.resizeFactor!,
              icon: Image.asset(widget.assetLocation),
              onPressed: () {},
            )),
            Center(
              child: TextButton(
                onPressed: null,
                child: Text(
                  widget.syl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                  // textAlign: TextAlign.start,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
