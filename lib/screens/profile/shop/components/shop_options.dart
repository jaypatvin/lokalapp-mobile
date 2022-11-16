import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/constants/themes.dart';

class ShopOptions extends StatelessWidget {
  const ShopOptions({
    super.key,
    this.onReportShop,
    this.onCopyLink,
  });

  final VoidCallback? onReportShop;
  final VoidCallback? onCopyLink;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (onReportShop != null)
          GestureDetector(
            onTap: onReportShop,
            child: ListTile(
              leading: const Icon(
                MdiIcons.alertCircleOutline,
                color: kPinkColor,
              ),
              title: Text(
                'Report Shop',
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
