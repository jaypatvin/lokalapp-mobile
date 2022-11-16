import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../providers/community.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/auth/register_screen.vm.dart';
import '../../widgets/overlays/screen_loader.dart';
import 'components/auth_input_form.dart';
import 'components/sso_block.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _RegisterScreenView(),
      viewModel: RegisterScreenViewModel(),
    );
  }
}

class _RegisterScreenView extends HookView<RegisterScreenViewModel>
    with HookScreenLoader<RegisterScreenViewModel> {
  @override
  Widget screen(BuildContext context, RegisterScreenViewModel vm) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            // expandedHeight: 280.0.h,
            expandedHeight: 325,
            automaticallyImplyLeading: false,
            backgroundColor: kYellowColor,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 5.0),
              collapseMode: CollapseMode.pin,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    context.watch<CommunityProvider>().community?.name ??
                        'the Community',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              background: SvgPicture.asset(
                kSvgBackgroundHouses,
                fit: BoxFit.cover,
                color: kOrangeColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Create an account below',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: AuthInputForm(
                      formKey: vm.formKey,
                      emailController: emailController,
                      emailFocusNode: emailFocusNode,
                      passwordController: passwordController,
                      passwordFocusNode: passwordFocusNode,
                      passwordValidator: vm.passwordValidator,
                      submitButtonLabel: 'REGISTER',
                      onFormChanged: vm.onFormChanged,
                      emailInputError: vm.errorMessage,
                      onFormSubmit: () async => performFuture(
                        () async => vm.emailSignUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      ),
                    ),
                  ),
                  SocialBlock(
                    appleLoginCallback: () async =>
                        performFuture(vm.appleSignUp),
                    fbLoginCallback: () async =>
                        performFuture(vm.facebookSignUp),
                    googleLoginCallback: () async =>
                        performFuture(vm.googleSignUp),
                  ),
                  const SizedBox(height: 5),
                  if (MediaQuery.of(context).viewInsets.bottom > 0)
                    const SizedBox(height: kKeyboardActionHeight)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
