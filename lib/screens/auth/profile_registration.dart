import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: vm.picturePickerHandler,
                  child: PhotoBox(
                    imageSource: PhotoBoxImageSource(file: vm.profilePhoto),
                    shape: BoxShape.circle,
                    width: 130.0,
                    height: 130.0,
                  ),
                ),
                if (vm.hasEmptyField)
                  const Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 10),
                    child: Text(
                      'You must fill out all field to proceed.',
                      style: TextStyle(
                        color: kPinkColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        borderSide: vm.hasEmptyField
                            ? const BorderSide(color: kPinkColor)
                            : BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        borderSide: vm.hasEmptyField
                            ? const BorderSide(color: kPinkColor)
                            : BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 190,
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
                    textStyle: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const SizedBox(height: kKeyboardActionHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController streetAddressController;
  final FocusNode firstNameNode;
  final FocusNode lastNameNode;
  final FocusNode streetAdddressNode;
  final InputDecoration formFieldDecoration;
  final VoidCallback onFormSubmit;

  const _RegistrationForm({
    Key? key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.streetAddressController,
    required this.formFieldDecoration,
    required this.onFormSubmit,
    required this.firstNameNode,
    required this.lastNameNode,
    required this.streetAdddressNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: firstNameNode,
            autocorrect: false,
            keyboardType: TextInputType.name,
            controller: firstNameController,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black),
            decoration: formFieldDecoration.copyWith(hintText: 'First Name'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            focusNode: lastNameNode,
            autocorrect: false,
            keyboardType: TextInputType.name,
            controller: lastNameController,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black),
            decoration: formFieldDecoration.copyWith(hintText: 'Last Name'),
          ),
          const SizedBox(height: 30),
          CheckboxFormField(
            validator: (checked) => checked!
                ? null
                : 'You must accept the Terms & Conditions and Privacy Policy',
            title: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(text: 'I have read the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: kTealColor,
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: kTealColor,
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Goldplay',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            focusNode: streetAdddressNode,
            autocorrect: false,
            keyboardType: TextInputType.streetAddress,
            controller: streetAddressController,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black),
            decoration:
                formFieldDecoration.copyWith(hintText: 'Street Address'),
          ),
        ],
      ),
    );
  }
}
