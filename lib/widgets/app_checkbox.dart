import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  final bool value;
  final void Function() onTap;
  final Widget? title;
  const AppCheckBox({
    Key? key,
    required this.value,
    required this.onTap,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap, //() => setState(() => forDelivery = !forDelivery),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
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
                  value: this.value,
                  onChanged: (_) => this.onTap(),
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
