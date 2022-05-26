import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class WidgetToImage extends StatefulWidget {
  final Function(GlobalKey key) builder;

  static Future<Uint8List?> capture(GlobalKey? key) async {
    if (key == null) return null;

    print('key $key');

    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    await Future.delayed(const Duration(milliseconds: 200));

    final image = await boundary.toImage(pixelRatio: 3);
    print('image $image');
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngByes = byteData!.buffer.asUint8List();

    return pngByes;
  }

  const WidgetToImage({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _WidgetToImageState createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
