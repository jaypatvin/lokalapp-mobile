import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../utils/constants/themes.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController inputController;
  final FocusNode? inputFocusNode;
  final void Function() onSend;
  final void Function()? onTap;
  final String? hintText;
  const InputTextField({
    Key? key,
    required this.inputController,
    required this.onSend,
    required this.inputFocusNode,
    this.hintText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 8,
      controller: inputController,
      focusNode: inputFocusNode,
      textAlignVertical: TextAlignVertical.center,
      onTap: onTap,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Colors.grey[400]),
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          icon: const Icon(MdiIcons.arrowRightCircle),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 32,
          onPressed: onSend,
          color: kTealColor,
        ),
      ),
    );
  }
}
