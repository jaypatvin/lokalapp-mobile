import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/home/report_post.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/input_description_field.dart';
import '../../widgets/overlays/constrained_scrollview.dart';
import '../../widgets/overlays/screen_loader.dart';

class ReportPost extends StatelessWidget {
  const ReportPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _ReportPostView(),
      viewModel: ReportPostViewModel(),
    );
  }
}

class _ReportPostView extends HookView<ReportPostViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, ReportPostViewModel viewModel) {
    final _reportFocusNode = useFocusNode();

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: _reportFocusNode,
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
      backgroundColor: kInviteScreenColor,
      appBar: CustomAppBar(
        titleText: 'Report Post',
        titleStyle: const TextStyle(color: Colors.white),
        backgroundColor: kTealColor,
        leadingWidth: 100,
        leading: GestureDetector(
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ConstrainedScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: KeyboardActions(
            disableScroll: true,
            config: _kbConfig,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  'Let us know why this post needs to be reported.',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 7),
                Text(
                  'Enter a short description below and our team will review '
                  'the post.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 20),
                InputDescriptionField(
                  maxLines: 11,
                  focusNode: _reportFocusNode,
                  hintText: 'Enter report here',
                  contentPadding: const EdgeInsets.all(20),
                  onChanged: viewModel.onReportMessageChanged,
                ),
                const Spacer(),
                const SizedBox(height: 12),
                AppButton.filled(
                  width: double.infinity,
                  text: 'Report',
                  color: kPinkColor,
                  onPressed: () async => performFuture(viewModel.onSubmit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
