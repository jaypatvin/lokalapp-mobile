import 'package:flutter/material.dart';

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
    const double dimension = 50.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onSubtract,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(dimension, dimension),
            shape: const CircleBorder(),
            primary: Colors.white,
            elevation: 0.0,
            side: const BorderSide(),
          ),
          child: const Center(
            child: Text(
              '-',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(dimension, dimension),
            shape: const CircleBorder(),
            primary: Colors.white,
            elevation: 0.0,
            side: const BorderSide(),
          ),
          child: const Center(
            child: Text(
              '+',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
