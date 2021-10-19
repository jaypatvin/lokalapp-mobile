import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/screen_loader.dart';

import '../../../utils/constants/themes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_app_bar.dart';

class SetUpPaymentOptions extends StatefulWidget {
  static const routeName = "/profile/shop/paymentOptions";
  final void Function() onSubmit;
  const SetUpPaymentOptions({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  _SetUpPaymentOptionsState createState() => _SetUpPaymentOptionsState();
}

class _SetUpPaymentOptionsState extends State<SetUpPaymentOptions>
    with ScreenLoader {
  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "Add Shop",
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Text(
              "Set-up payment options",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10.0),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: ListTile(
                tileColor: Colors.grey[300],
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    "assets/payment/bank.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  "Bank Transfer/Deposit",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: Icon(
                  Icons.add,
                  color: kTealColor,
                  size: 18.0.r,
                ),
                onTap: null,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
              child: ListTile(
                tileColor: Colors.grey[300],
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/payment/gcash.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  "Gcash",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: Icon(
                  Icons.add,
                  color: kTealColor,
                  size: 18.0.r,
                ),
                onTap: null,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                "Skip",
                kTealColor,
                false,
                () async => await performFuture(this.widget.onSubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
