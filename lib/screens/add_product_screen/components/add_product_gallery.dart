import 'package:flutter/material.dart';

import '../../../utils/utility.dart';
import '../../../widgets/photo_box.dart';

class AddProductGallery extends StatefulWidget {
  @override
  _AddProductGalleryState createState() => _AddProductGalleryState();
}

class _AddProductGalleryState extends State<AddProductGallery> {
  final boxShape = BoxShape.rectangle;
  List<PhotoBox> photoBoxes;

  @override
  void initState() {
    super.initState();

    photoBoxes = [
      PhotoBox(
        shape: boxShape,
        file: null,
      )
    ];
  }

  Future<void> selectImage(int index) async {
    var file = await Utility.getInstance().showMediaDialog(context);
    if (file != null) {
      setState(() {
        photoBoxes[index] = PhotoBox(
          file: file,
          shape: boxShape,
        );
        if (photoBoxes.last.file != null) {
          photoBoxes.removeWhere((p) => p.file == null);
          photoBoxes = [
            ...photoBoxes,
            PhotoBox(
              file: null,
              shape: boxShape,
            )
          ];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: photoBoxes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async => await selectImage(index),
          child: Card(margin: EdgeInsets.all(5.0), child: photoBoxes[index]),
        );
      },
    );
  }
}
