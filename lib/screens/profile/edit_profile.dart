import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
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
    final _auth = context.watch<Auth>();

    final _fNameController = useTextEditingController(text: vm.firstName);
    final _lNameController = useTextEditingController(text: vm.lastName);
    final _streetController = useTextEditingController(text: vm.street);

    final _fNameFocusNode = useFocusNode();
    final _lNameFocusNode = useFocusNode();
    final _streetFocusNode = useFocusNode();

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        actions: [
          KeyboardActionsItem(
            focusNode: _fNameFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
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
                    'Done',
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
                    'Done',
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
      backgroundColor: const Color(0xffF1FAFF),
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        titleText: 'Edit My Profile',
        backgroundColor: kTealColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 40.0),
        child: KeyboardActions(
          config: _kbConfig,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: vm.onPhotoPick,
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: Stack(
                    children: [
                      Center(
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.modulate,
                          ),
                          child: PhotoBox(
                            imageSource: PhotoBoxImageSource(
                              file: vm.profilePhoto,
                              url: _auth.user?.profilePhoto,
                            ),
                            shape: BoxShape.circle,
                            displayBorder: false,
                            displayIcon: false,
                          ),
                        ),
                      ),
                      Builder(
                        builder: (ctx) {
                          if (vm.profilePhoto != null ||
                              (_auth.user?.profilePhoto?.isNotEmpty ?? false)) {
                            return Center(
                              child: Text(
                                'Edit Photo',
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
                              height: 130,
                              width: 130,
                              child: Center(
                                child: Text(
                                  'Add Photo',
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
              const SizedBox(height: 47),
              InputNameField(
                onChanged: vm.onFirstNameChanged,
                controller: _fNameController,
                hintText: 'First Name',
                fillColor: Colors.white,
              ),
              const SizedBox(height: 20),
              InputNameField(
                onChanged: vm.onLastNameChanged,
                controller: _lNameController,
                hintText: 'Last Name',
                fillColor: Colors.white,
              ),
              const SizedBox(height: 40),
              InputNameField(
                onChanged: vm.onStreetChanged,
                controller: _streetController,
                hintText: 'Street',
                fillColor: Colors.white,
              ),
              const SizedBox(height: 47),
              AppButton.filled(
                text: 'Apply Changes',
                onPressed: () async => performFuture<void>(vm.updateUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
