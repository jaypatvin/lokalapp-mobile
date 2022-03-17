import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/home/post_details.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/input_images_picker.dart';
import '../../widgets/inputs/input_text_field.dart';
import '../../widgets/keyboard_visibility_builder.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import 'components/post_options.dart';
import 'post_details/post_details.comment_feed.dart';
import 'post_details/post_details.footer.dart';
import 'post_details/post_details.header.dart';
import 'post_details/post_details.images.dart';

class PostDetails extends StatelessWidget {
  static const routeName = '/home/post_details';
  const PostDetails({
    Key? key,
    required this.activityId,
    required this.onUserPressed,
    required this.onLike,
  }) : super(key: key);

  final String activityId;
  final void Function(String) onUserPressed;
  final void Function() onLike;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _PostDetailsView(),
      viewModel: PostDetailViewModel(
        activityId: activityId,
        onUserPressed: onUserPressed,
        onLike: onLike,
      ),
    );
  }
}

class _PostDetailsView extends HookView<PostDetailViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, PostDetailViewModel vm) {
    final _scrollController = useScrollController();
    final _commentInputFocusNode = useFocusNode();
    // final _showImagePicker = useState<bool>(false);

    useEffect(
      () {
        void listener() {
          Timer(const Duration(milliseconds: 300), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          });
        }

        vm.imageProvider.addListener(listener);
        return () => vm.imageProvider.removeListener(listener);
      },
      [vm.imageProvider],
    );

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: _commentInputFocusNode,
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

    return NestedWillPopScope(
      onWillPop: vm.onWillPop,
      child: Consumer<Activities>(
        builder: (ctx, activities, _) {
          final activity = activities.findById(vm.activityId)!;
          final user = context.read<Users>().findById(activity.userId)!;
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              backgroundColor: kTealColor,
              titleText: "${user.firstName}'s Post",
              titleStyle: const TextStyle(color: Colors.white),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                  onPressed: context.read<Auth>().user!.id == activity.userId
                      ? () => vm.onPostOptionsPressed(
                            PostOptions(
                              onDeletePost: () async =>
                                  performFuture<void>(vm.onDelete),
                            ),
                          )
                      : null,
                ),
              ],
            ),
            body: KeyboardActions(
              disableScroll: true,
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              config: _kbConfig,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20.0.h,
                                  ),
                                  child: PostDetailsHeader(
                                    onTap: () => vm.onUserPressed(user.id),
                                    firstName: user.firstName,
                                    lastName: user.lastName,
                                    photo: user.profilePhoto,
                                    spacing: 10.0.w,
                                  ),
                                ),
                                Text(
                                  activity.message,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20.0.h),
                                PostDetailsImages(activity),
                                SizedBox(height: 15.0.h),
                                Text(
                                  DateFormat('hh:mm a • dd MMMM yyyy')
                                      .format(activity.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0.h),
                          CommentAndLikeRow(
                            activity: activity,
                            onLike: vm.onLike,
                          ),
                          SizedBox(height: 10.0.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            child: CommentFeed(
                              vm.commentFeed,
                              activity.id,
                            ), //_buildComments(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: kInviteScreenColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0.w,
                      vertical: 10.0.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: kTealColor),
                            ),
                            child: const Icon(
                              MdiIcons.fileImageOutline,
                              color: kTealColor,
                            ),
                          ),
                          onTap: () async {
                            await vm.onShowImagePicker();
                            Future.delayed(const Duration(milliseconds: 300), () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                            });
                          },
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              border: Border.all(color: kTealColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    height: vm.imageProvider.picked.isNotEmpty
                                        ? 100
                                        : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: InputImagesPicker(
                                      pickedImages: vm.imageProvider.picked,
                                      onImageRemove: vm.onImageRemove,
                                    ),
                                  ),
                                  InputTextField(
                                    inputController: vm.inputController,
                                    inputFocusNode: _commentInputFocusNode,
                                    onSend: vm.createComment,
                                    onTap: () => vm.showImagePicker = false,
                                    hintText: 'Add a comment...',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: vm.showImagePicker ? 150.0.h : 0,
                    child: ImageGalleryPicker(
                      vm.imageProvider,
                      pickerHeight: 150.h,
                      assetHeight: 150.h,
                      assetWidth: 150.h,
                      thumbSize: 200,
                      enableSpecialItemBuilder: true,
                    ),
                  ),
                  KeyboardVisibilityBuilder(
                    builder: (_, __, isVisible) {
                      if (isVisible) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        });
                      }
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: isVisible ? kKeyboardActionHeight : 0,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
