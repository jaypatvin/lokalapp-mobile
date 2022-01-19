import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityController extends StatelessWidget {
  final void Function()? onAdd;
  final void Function()? onSubtract;
  const QuantityController({
    Key? key,
    this.onAdd,
    this.onSubtract,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double dimension = 50.0.w;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onSubtract,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            shape: const CircleBorder(),
            primary: Colors.white,
            elevation: 0.0,
            side: const BorderSide(),
          ),
          child: Icon(
            Icons.remove,
            size: 35.0.r,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 15.0.w),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            shape: const CircleBorder(),
            primary: Colors.white,
            elevation: 0.0,
            side: const BorderSide(),
          ),
          child: Icon(
            Icons.add,
            size: 35.0.r,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
