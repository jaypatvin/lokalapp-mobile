import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/constants/themes.dart';
import '../../../../widgets/app_button.dart';

class ScheduleConflictsNotification extends StatelessWidget {
  final void Function()? onAutomatic;
  final void Function()? onManual;

  /// The dialog to be displayed when conflicts are present.
  const ScheduleConflictsNotification({
    super.key,
    this.onAutomatic,
    this.onManual,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(21),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                MdiIcons.alertCircle,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                'There will be days on the schedule that you set that this '
                "shop won't be able to deliver.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'You can either let us automatically re-schedule '
                          'your order to the next available date',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: kTealColor,
                          ),
                    ),
                    const TextSpan(text: ' or '),
                    TextSpan(
                      text: 'you can manually re-schedule the unavailable '
                          'dates in the Activities screen.',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: kOrangeColor,
                          ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              const SizedBox(height: 12),
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
