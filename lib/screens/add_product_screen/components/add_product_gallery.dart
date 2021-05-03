import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../utils/utility.dart';
import '../../../widgets/photo_box.dart';

class AddProductGallery extends StatefulWidget {
  final List<PhotoBox> _photoBoxes = [];
  List<PhotoBox> get photoBoxes => UnmodifiableListView(_photoBoxes);
  @override
  _AddProductGalleryState createState() => _AddProductGalleryState();
}

class _AddProductGalleryState extends State<AddProductGallery> {
  final boxShape = BoxShape.rectangle;
  final double height = 75.0;
  final double width = 72.0;

  @override
  void initState() {
    super.initState();

    widget._photoBoxes.add(
      PhotoBox(
        shape: boxShape,
        file: null,
        width: width,
        height: height,
      ),
    );
  }

  Future<void> selectImage(int index) async {
    var file = await MediaUtility.instance.showMediaDialog(context);
    if (file != null) {
      setState(() {
        widget._photoBoxes[index] = PhotoBox(
          file: file,
          shape: boxShape,
          width: width,
          height: height,
        );
        if (widget._photoBoxes.last.file != null &&
            widget._photoBoxes.length < 4) {
          widget._photoBoxes.removeWhere((p) => p.file == null);
          var _pb = List<PhotoBox>.from(widget._photoBoxes);
          widget._photoBoxes
            ..clear()
            ..addAll(
              {
                ..._pb,
                PhotoBox(
                  file: null,
                  shape: boxShape,
                  width: width,
                  height: height,
                ),
              },
            );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget._photoBoxes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async => await selectImage(index),
          child: Card(
              margin: EdgeInsets.all(5.0), child: widget._photoBoxes[index]),
        );
      },
    );
  }
}
