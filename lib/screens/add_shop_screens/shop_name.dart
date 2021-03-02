import 'package:flutter/material.dart';

class ShopName extends StatefulWidget {
  Function onChanged;
  TextEditingController shopController;
  String errorText;
  ShopName({this.onChanged, this.shopController, this.errorText});
  @override
  _ShopNameState createState() => _ShopNameState();
}

class _ShopNameState extends State<ShopName> {
  Row buildShopName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextField(
            onTap: () {},
            controller: widget.shopController,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              fillColor: Color(0xffF2F2F2),
              filled: true,
              isDense: true,
              errorText: widget.errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 13,
              ),
              hintText: "Shop Name",
              hintStyle: TextStyle(
                  fontFamily: "GoldplayBold",
                  fontSize: 14,
                  color: Color(0xFFBDBDBD),
                  fontWeight: FontWeight.w500),
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
    return buildShopName();
  }
}
