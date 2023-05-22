import 'package:flutter/material.dart';
import 'package:learnignflutter/services/divide_syllables.dart';
import 'package:learnignflutter/Utils/sylabless_lists.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:learnignflutter/providers/puzzle_game_provider.dart';

class Puzzles extends StatefulWidget {
  final String puzzleItem;
  final List<String> puzzleSyllables;

  Puzzles({required this.puzzleItem, super.key})
      : puzzleSyllables = divideWordIntoSyllables(puzzleItem, sylablessList);

  @override
  State<Puzzles> createState() => _PuzzlesState();
}

class _PuzzlesState extends State<Puzzles> {
  final _puzzleBoardKey = GlobalKey();
  Size? imageSize = Size.zero;
  late final Future<File> puzzleImageFile;
  late final Future<int> resizeValue;
  Size? originalPhotoSize;
  dynamic loadedImage;

  @override
  void initState() {
    super.initState();
    puzzleImageFile =
        assetToFile('assets/images/puzzle pattern 2- alpha channel.png');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _updateImageSize();
      });
    });
  }

  @override
  void dispose() {
    assetToFile('assets/images/puzzle pattern 2- alpha channel.png')
        .then((file) => file.delete());
    super.dispose();
  }

  Future<File> assetToFile(String path) async {
    final bytes = await rootBundle.load(path);
    final buffer = bytes.buffer;
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$path').create(recursive: true);
    file.writeAsBytesSync(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  // original image dimensions
  Future<Size> _calculateImageDimension(futurefile) {
    Completer<Size> completer = Completer();
    Image image = Image.file(futurefile);
    image.image.resolve(const ImageConfiguration()).addListener(
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

  //rendered image
  void _updateImageSize() {
    final size = _puzzleBoardKey.currentContext?.size;
    if (size == null) {}
    if (imageSize != size) {
      imageSize = size!;
      print('imagesize is $imageSize');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Positions()),
        ],
        child: Stack(children: [
          Image.asset(
            'assets/images/animated/20230419_130154.gif',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent.withOpacity(0),
            body: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                    icon: Image.asset(
                      'assets/images/items/${widget.puzzleItem}.png',
                    ),
                    iconSize: 200,
                    onPressed: () {}),
                Image.asset(
                  'assets/images/puzzle pattern 2- alpha channel.png',
                  key: _puzzleBoardKey,
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
                      final RenderBox renderedImage =
                          _puzzleBoardKey.currentContext?.findRenderObject()
                              as RenderBox;
                      final position = renderedImage.localToGlobal(Offset.zero);
                      context
                          .read<Positions>()
                          .setBoardOffset(position.dx, position.dy);
                      // print(context.watch<Positions>().boardOffset);
                      return Stack(
                        children: [
                          for (int i = 0;
                              i < widget.puzzleSyllables.length;
                              i++)
                            GestureDetectorWidget(
                              id: i + 1,
                              assetLocation:
                                  'assets/images/${i + 1}element.png',
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
        ]));
  }
}

class GestureDetectorWidget extends StatefulWidget {
  final int id;
  final String assetLocation;
  final String syl;
  final Size? photoSize;
  final Size? resizedImageSize;
  double? resizeFactor;

  GestureDetectorWidget({
    required this.id,
    required this.syl,
    required this.assetLocation,
    required this.photoSize,
    required this.resizedImageSize,
    super.key,
  }) : resizeFactor = resizedImageSize != null && photoSize != null
            ? resizedImageSize.height / photoSize.height
            : 0.5;

  @override
  GestureDetectorWidgetState createState() => GestureDetectorWidgetState();
}

class GestureDetectorWidgetState extends State<GestureDetectorWidget> {
  double _x = 0;
  double _y = 0;
  // double puzzleElementOffsetdx = 0;
  // double puzzleElementOffsetdy = 0;
  // final double _boxWidth = 50;
  // final double _boxHeight = 50;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          // position
          _x += details.delta.dx;
          _y += details.delta.dy;

          // edges
          if (_x < 0) {
            _x = 0;
            // } else if (_x > MediaQuery.of(context).size.width - _boxWidth) {
            //   _x = MediaQuery.of(context).size.width - _boxWidth;
          }

          if (_y < 0) {
            _y = 0;
            // } else if (_y > MediaQuery.of(context).size.height - _boxHeight) {
            //   _y = MediaQuery.of(context).size.height - _boxHeight;
          }
        });
      },
      child: Container(
        height: 90,
        width: 90,
        color: Colors.transparent,
        margin: EdgeInsets.only(
          left: _x,
          top: _y,
        ),
        child: Stack(
          children: [
            UnconstrainedBox(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                RenderBox puzzleelementRenderBox =
                    context.findRenderObject() as RenderBox;
                Offset puzzleElementOffset =
                    puzzleelementRenderBox.localToGlobal(Offset.zero);
                context.read<Positions>().setPuzzleElementOffset(
                    puzzleElementOffset.dx, puzzleElementOffset.dy);
                // print(context.watch<Positions>().puzzleOffset);
                return IconButton(
                  iconSize: 600 * widget.resizeFactor!,
                  icon: Image.asset(widget.assetLocation),
                  onPressed: () {
                    print(widget.resizeFactor);
                  },
                );
              }),
            ),
            Container(
              //I need the font for all!!
              margin: const EdgeInsets.all(12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.syl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
