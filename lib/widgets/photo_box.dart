import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lokalapp/utils/themes.dart';

// class PhotoBox extends StatefulWidget {
//   final BoxShape shape;
//   PhotoBox({this.shape = BoxShape.circle});

//   @override
//   _PhotoBoxState createState() => _PhotoBoxState();
// }

// class _PhotoBoxState extends State<PhotoBox> {
//   File _file;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async => setState(
//           () async => _file = await Utility.utility.showMediaDialog(context)),
//       child: Container(
//         width: 72.0,
//         height: 75.0,
//         decoration: BoxDecoration(
//           image: _file == null
//               ? null
//               : DecorationImage(
//                   fit: BoxFit.cover,
//                   image: FileImage(_file),
//                 ),
//           shape: this.widget.shape,
//           border: Border.all(width: 1, color: kTealColor),
//         ),
//         child: _file == null
//             ? Icon(
//                 Icons.add,
//                 color: kTealColor,
//                 size: 15,
//               )
//             : null,
//       ),
//     );
//   }
// }

class PhotoBox extends StatelessWidget {
  final File file;
  final BoxShape shape;

  const PhotoBox({@required this.file, @required this.shape});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.0,
      height: 75.0,
      decoration: BoxDecoration(
        image: file == null
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(file),
              ),
        shape: shape,
        border: Border.all(width: 1, color: kTealColor),
      ),
      child: file == null
          ? Icon(
              Icons.add,
              color: kTealColor,
              size: 15,
            )
          : null,
    );
  }
}
