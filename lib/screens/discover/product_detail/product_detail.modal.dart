import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/constants/themes.dart';

class ProductDetailOptions extends StatelessWidget {
  const ProductDetailOptions({
    Key? key,
    this.onVisitShop,
    this.onReportProduct,
    this.onCopyLink,
  }) : super(key: key);

  final VoidCallback? onVisitShop;
  final VoidCallback? onReportProduct;
  final VoidCallback? onCopyLink;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (onVisitShop != null)
          GestureDetector(
            onTap: onVisitShop,
            child: ListTile(
              leading: const Icon(
                MdiIcons.storeOutline,
                color: kNavyColor,
              ),
              title: Text(
                'Visit Shop',
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: kNavyColor, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        if (onReportProduct != null)
          GestureDetector(
            onTap: onReportProduct,
            child: ListTile(
              leading: const Icon(
                MdiIcons.alertCircleOutline,
                color: kPinkColor,
              ),
              title: Text(
                'Report Product',
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: kPinkColor, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        if (onCopyLink != null)
          GestureDetector(
            onTap: onCopyLink,
            child: ListTile(
              leading: const Icon(MdiIcons.linkVariant, color: kNavyColor),
              title: Text(
                'Copy Link',
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: kNavyColor, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }
}
