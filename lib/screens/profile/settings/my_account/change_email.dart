import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../state/mvvm_builder.widget.dart';
import '../../../../state/views/hook.view.dart';
import '../../../../utils/constants/themes.dart';
import '../../../../view_models/profile/settings/my_account/change_email.vm.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/overlays/screen_loader.dart';
import 'components/email_input_form.dart';
import 'confirmation.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ChangeEmailView(),
      viewModel: ChangeEmailViewModel(),
    );
  }
}

class _ChangeEmailView extends HookView<ChangeEmailViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ChangeEmailViewModel viewModel) {
    final _formKey = useMemoized<GlobalKey<FormState>>(
      () => GlobalKey<FormState>(),
    );

    final _newEmailFocusNode = useFocusNode();
    final _confirmEmailFocusNode = useFocusNode();
    final _passwordFocusNode = useFocusNode();

    final _isMounted = useIsMounted();

    final _addPadding = useState(false);

    useEffect(() {
      void listener() {
        _addPadding.value = _newEmailFocusNode.hasFocus ||
            _confirmEmailFocusNode.hasFocus ||
            _passwordFocusNode.hasFocus;
      }

      _newEmailFocusNode.addListener(listener);
      _confirmEmailFocusNode.addListener(listener);
      _passwordFocusNode.addListener(listener);

      return () {
        if (_isMounted()) {
          _newEmailFocusNode.removeListener(listener);
          _confirmEmailFocusNode.removeListener(listener);
          _passwordFocusNode.removeListener(listener);
        }
      };
    }, [
      _newEmailFocusNode,
      _confirmEmailFocusNode,
      _passwordFocusNode,
    ]);

    return Scaffold(
      backgroundColor: kInviteScreenColor,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleText: 'Change Email Address',
        backgroundColor: kTealColor,
        titleStyle: const TextStyle(color: Colors.white),
        onPressedLeading: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0.w, 20.0.h, 20.0.w, 0),
        child: Column(
          children: [
            Expanded(
              child: EmailInputForm(
                formKey: _formKey,
                displayEmailMatchError: viewModel.displayEmailError,
                displaySignInError: viewModel.displaySignInError,
                newEmailFocusNode: _newEmailFocusNode,
                confirmEmailFocusNode: _confirmEmailFocusNode,
                passwordFocusNode: _passwordFocusNode,
                onNewEmailChanged: viewModel.onEmailChanged,
                onConfirmEmailChanged: viewModel.onNewEmailChanged,
                onPasswordChanged: viewModel.onPasswordChanged,
                onFormSubmit: () async {
                  final success =
                      await performFuture<bool>(viewModel.onFormSubmit);
                  if (success!) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const MyAccountConfirmation(),
                      ),
                    );
                  }
                },
              ),
            ),
            if (viewModel.displayEmailError)
              Text(
                'Email addresses do not match!',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: kPinkColor),
              ),
            SizedBox(
              width: double.maxFinite,
              child: AppButton.filled(
                text: 'Confirm',
                onPressed: () async {
                  _newEmailFocusNode.unfocus();
                  _confirmEmailFocusNode.unfocus();
                  _passwordFocusNode.unfocus();

                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  final _success =
                      await performFuture<bool>(viewModel.onFormSubmit);

                  if (_success!) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyAccountConfirmation(),
                      ),
                    );
                    return;
                  }
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _addPadding.value ? kKeyboardActionHeight : 0,
            ),
          ],
        ),
      ),
    );
  }
}
