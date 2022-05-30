import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/login_screen.vm.dart';
import '../../widgets/overlays/screen_loader.dart';
import 'components/auth_input_form.dart';
import 'components/sso_block.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _LoginScreenView(),
      viewModel: LoginScreenViewModel(),
    );
  }
}

class _LoginScreenView extends HookView<LoginScreenViewModel>
    with HookScreenLoader<LoginScreenViewModel> {
  @override
  Widget screen(BuildContext context, LoginScreenViewModel vm) {
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _emailFocusNode = useFocusNode();
    final _passwordFocusNode = useFocusNode();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 325,
            automaticallyImplyLeading: false,
            backgroundColor: kYellowColor,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 5.0),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'LOKAL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kOrangeColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Your neighborhood plaza',
                    style: TextStyle(
                      fontSize: 16,
                      color: kTealColor,
                      fontFamily: 'Goldplay',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              background: Container(
                color: kYellowColor,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        kSvgBackgroundHouses,
                        fit: BoxFit.cover,
                        color: kOrangeColor,
                      ),
                    ),
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0, -30.0),
                        child: Hero(
                          tag: kSvgLokalLogoV2,
                          child: SvgPicture.asset(
                            kSvgLokalLogoV2,
                            fit: BoxFit.scaleDown,
                            color: kOrangeColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 30),
                    child: AuthInputForm(
                      formKey: vm.formKey,
                      emailController: _emailController,
                      emailFocusNode: _emailFocusNode,
                      passwordController: _passwordController,
                      passwordFocusNode: _passwordFocusNode,
                      submitButtonLabel: 'SIGN IN',
                      passwordInputError: vm.errorMessage,
                      onFormChanged: vm.onFormChanged,
                      onFormSubmit: () async => performFuture(
                        () async => vm.emailLogin(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      'FORGOT PASSWORD?',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SocialBlock(
                      fbLoginCallback: () async =>
                          performFuture(vm.facebookLogin),
                      googleLoginCallback: () async =>
                          performFuture(vm.googleLogin),
                      appleLoginCallback: () async =>
                          performFuture(vm.appleLogin),
                    ),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom != 0)
                    const SizedBox(height: kKeyboardActionHeight),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
