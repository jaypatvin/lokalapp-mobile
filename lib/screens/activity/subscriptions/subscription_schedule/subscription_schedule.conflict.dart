import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';

class ScheduleConflictsNotification extends StatelessWidget {
  final void Function()? onAutomatic;
  final void Function()? onManual;

  /// The dialog to be displayed when conflicts are present.
  const ScheduleConflictsNotification({
    Key? key,
    this.onAutomatic,
    this.onManual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                MdiIcons.alertCircle,
                color: Colors.red,
              ),
              SizedBox(height: 10.0.h),
              const Text(
                'There will be days on the schedule that you set that this '
                "shop won't be able to deliver.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'You can either let us automatically re-schedule '
                          'your order to the next available date',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kTealColor,
                          ),
                    ),
                    const TextSpan(text: ' or '),
                    TextSpan(
                      text: 'you can manually re-schedule the unavailable '
                          'dates in the Activities screen.',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kOrangeColor,
                          ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(height: 10.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: AppButton.filled(
                      text: 'Set Manually',
                      color: kOrangeColor,
                      onPressed: onManual,
                    ),
                  ),
                  SizedBox(width: 5.0.w),
                  Expanded(
                    child: AppButton.filled(
                      text: 'Set Automatically',
                      onPressed: onAutomatic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
