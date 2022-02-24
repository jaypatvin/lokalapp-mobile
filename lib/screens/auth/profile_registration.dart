import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/profile_registration.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/constrained_scrollview.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../../widgets/photo_box.dart';
import 'components/checkbox_form_field.dart';

class ProfileRegistration extends StatelessWidget {
  static const routeName = '/register/profile';
  const ProfileRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ProfileRegistrationView(),
      viewModel: ProfileRegistrationViewModel(),
    );
  }
}

class _ProfileRegistrationView extends HookView<ProfileRegistrationViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ProfileRegistrationViewModel vm) {
    final _firstNameFocusNode = useFocusNode();
    final _lastNameFocusNode = useFocusNode();
    final _streetNameFocusNode = useFocusNode();

    final _firstNameController = useTextEditingController();
    final _lastNameController = useTextEditingController();
    final _streetNameController = useTextEditingController();

    useEffect(
      () {
        void _firstNameListener() {
          vm.onFirstNameChanged(_firstNameController.text);
        }

        void _lastNameListener() {
          vm.onLastNameChanged(_lastNameController.text);
        }

        void _streetNameListener() {
          vm.onStreetNameChanged(_streetNameController.text);
        }

        _firstNameController.addListener(_firstNameListener);
        _lastNameController.addListener(_lastNameListener);
        _streetNameController.addListener(_streetNameListener);

        return () {
          _firstNameController.removeListener(_firstNameListener);
          _lastNameController.removeListener(_lastNameListener);
          _streetNameController.removeListener(_streetNameListener);
        };
      },
    );

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _firstNameFocusNode,
          ),
          KeyboardActionsItem(
            focusNode: _lastNameFocusNode,
          ),
          KeyboardActionsItem(
            focusNode: _streetNameFocusNode,
          ),
        ],
      );
    });

    return WillPopScope(
      onWillPop: vm.onWillPop,
      child: Scaffold(
        backgroundColor: kInviteScreenColor,
        appBar: CustomAppBar(
          backgroundColor: kInviteScreenColor,
          leadingColor: kTealColor,
          onPressedLeading: () => Navigator.maybePop(context),
        ),
        body: ConstrainedScrollView(
          child: KeyboardActions(
            disableScroll: true,
            config: _kbConfig,
            child: Column(
              children: [
                Text(
                  "Let's set up your profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.0.h),
                GestureDetector(
                  onTap: vm.picturePickerHandler,
                  child: PhotoBox(
                    imageSource: PhotoBoxImageSource(file: vm.profilePhoto),
                    shape: BoxShape.circle,
                    width: 120.0.w,
                    height: 120.0.h,
                
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                if (vm.hasEmptyField)
                  Text(
                    'You must fill out all field to proceed.',
                    style: TextStyle(
                      color: kPinkColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0.sp,
                    ),
                  ),
                SizedBox(height: 10.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: _RegistrationForm(
                    formKey: vm.formKey,
                    firstNameController: _firstNameController,
                    firstNameNode: _firstNameFocusNode,
                    lastNameController: _lastNameController,
                    lastNameNode: _lastNameFocusNode,
                    streetAddressController: _streetNameController,
                    streetAdddressNode: _streetNameFocusNode,
                    onFormSubmit: () async => performFuture<void>(
                      () async => vm.registerHandler(),
                    ),
                    formFieldDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                        borderSide: vm.hasEmptyField
                            ? const BorderSide(color: kPinkColor)
                            : BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0.r)),
                        borderSide: vm.hasEmptyField
                            ? const BorderSide(color: kPinkColor)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(height: 10.0.h),
                SizedBox(
                  width: 200.0.w,
                  child: AppButton.filled(
                    text: 'CREATE PROFILE',
                    onPressed: () async {
                      _firstNameFocusNode.unfocus();
                      _lastNameFocusNode.unfocus();
                      _streetNameFocusNode.unfocus();

                      await performFuture<void>(
                        () async => vm.registerHandler(),
                      );
                    },
                    textStyle: const TextStyle(color: kNavyColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  final Key? formKey;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? streetAddressController;
  final FocusNode? firstNameNode;
  final FocusNode? lastNameNode;
  final FocusNode? streetAdddressNode;
  final InputDecoration? formFieldDecoration;
  final void Function()? onChanged;
  final void Function()? onFormSubmit;

  _RegistrationForm({
    Key? key,
    this.formKey,
    this.firstNameController,
    this.lastNameController,
    this.streetAddressController,
    this.formFieldDecoration,
    this.onChanged,
    this.onFormSubmit,
    this.firstNameNode,
    this.lastNameNode,
    this.streetAdddressNode,
  }) : super(key: key);

  final _checkBoxTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Goldplay',
    fontWeight: FontWeight.w600,
    fontSize: 13.0.sp,
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: onChanged,
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: firstNameNode,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: firstNameController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
            ),
            decoration: formFieldDecoration!.copyWith(hintText: 'First Name'),
          ),
          SizedBox(height: 15.0.h),
          TextFormField(
            focusNode: lastNameNode,
            autocorrect: false,
            controller: lastNameController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
            ),
            decoration: formFieldDecoration!.copyWith(hintText: 'Last Name'),
          ),
          SizedBox(height: 15.0.h),
          CheckboxFormField(
            validator: (checked) => checked!
                ? null
                : 'You must accept the Terms & Conditions and Privacy Policy',
            title: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: 'I have read the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: _checkBoxTextStyle.copyWith(
                      color: kTealColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: _checkBoxTextStyle.copyWith(
                      color: kTealColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                style: _checkBoxTextStyle,
              ),
            ),
          ),
          // SizedBox(
          //   height: 30.0.h,
          // ),
          TextFormField(
            focusNode: streetAdddressNode,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: streetAddressController,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
            ),
            decoration:
                formFieldDecoration!.copyWith(hintText: 'Street Address'),
          ),
        ],
      ),
    );
  }
}
