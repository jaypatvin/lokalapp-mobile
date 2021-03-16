import 'package:flutter/material.dart';

class ItemName extends StatefulWidget {
  final Function onChanged;
  ItemName({@required this.onChanged});
  @override
  _ItemNameState createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName> {
  Row buildItemName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextField(
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              fillColor: Color(0xffF2F2F2),
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 13,
              ),
              hintText: "Item Name",
              hintStyle: TextStyle(
                fontFamily: "GoldplayBold",
                fontSize: 14,
                color: Color(0xFFBDBDBD),
                // fontWeight: FontWeight.w500
              ),
              alignLabelWithHint: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    30.0,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildItemName();
  }
}
