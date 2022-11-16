import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  final bool value;
  final void Function() onTap;
  final Widget? title;
  final BoxShape shape;
  const AppCheckBox({
    super.key,
    required this.value,
    required this.onTap,
    this.shape = BoxShape.rectangle,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            height: 18,
            width: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: shape,
                border: Border.all(
                  width: 2,
                ),
              ),
              child: Theme(
                data: ThemeData(
                  // accentColor: Colors.transparent,
                  toggleableActiveColor: Colors.transparent,
                  unselectedWidgetColor: Colors.transparent,
                ),
                child: Checkbox(
                  checkColor: Colors.black,
                  value: value,
                  onChanged: (_) => onTap(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (title != null) title!,
        ],
      ),
    );
  }
}
