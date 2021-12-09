
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../providers/post_requests/auth_body.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/profile/edit_profile.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/input_name_field.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../../widgets/photo_box.dart';

class EditProfile extends StatelessWidget {
  static const routeName = '/profile/edit';
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _EditProfileView(),
      viewModel: EditProfileViewModel(),
    );
  }
}

class _EditProfileView extends HookView<EditProfileViewModel>
    with HookScreenLoader<EditProfileViewModel> {
  _EditProfileView({Key? key, bool reactive = true})
      : super(key: key, reactive: reactive);

  @override
  Widget screen(BuildContext context, EditProfileViewModel vm) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final _fNameController = useTextEditingController(text: vm.firstName);
    final _lNameController = useTextEditingController(text: vm.lastName);
    final _streetController = useTextEditingController(text: vm.street);

    final _fNameFocusNode = useFocusNode();
    final _lNameFocusNode = useFocusNode();
    final _streetFocusNode = useFocusNode();

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            focusNode: _fNameFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    "Done",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: _lNameFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    "Done",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: _streetFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    "Done",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                );
              },
            ],
          ),
        ],
      );
    });

    return Scaffold(
      backgroundColor: Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: "Edit My Profile",
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
        child: Stack(
          children: [
            KeyboardActions(
              config: _kbConfig,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: vm.onPhotoPick,
                    child: Container(
                      height: height * 0.2,
                      child: Stack(
                        children: [
                          Center(
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.modulate,
                              ),
                              child: PhotoBox(
                                file: vm.profilePhoto,
                                shape: BoxShape.circle,
                                url: context.read<AuthBody>().profilePhoto,
                                displayBorder: false,
                              ),
                            ),
                          ),
                          Builder(
                            builder: (ctx) {
                              final authBody = context.read<AuthBody>();
                              if (vm.profilePhoto != null ||
                                  (authBody.profilePhoto?.isNotEmpty ??
                                      false)) {
                                return Center(
                                  child: Text(
                                    "Edit Photo",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.white),
                                  ),
                                );
                              }
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  height: 140.0.h,
                                  width: 140.0.h,
                                  child: Center(
                                    child: Text(
                                      "Add Photo",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InputNameField(
                    onChanged: vm.onFirstNameChanged,
                    controller: _fNameController,
                    hintText: "First Name",
                    fillColor: Colors.white,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  InputNameField(
                    onChanged: vm.onLastNameChanged,
                    controller: _lNameController,
                    hintText: "Last Name",
                    fillColor: Colors.white,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  InputNameField(
                    onChanged: vm.onStreetChanged,
                    controller: _streetController,
                    hintText: "Street",
                    fillColor: Colors.white,
                  ),
                  SizedBox(height: height * 0.15),
                  SizedBox(
                    width: width * 0.6,
                    child: AppButton(
                      "Apply Changes",
                      kTealColor,
                      true,
                      () async => await performFuture<void>(vm.updateUser),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
