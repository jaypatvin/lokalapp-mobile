import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/home/draft_post.vm.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_view_gallery/thumbnails/asset_photo_thumbnail.dart';

class DraftPost extends StatelessWidget {
  static const routeName = '/home/draft_post';
  const DraftPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _DraftPostView(),
      viewModel: DraftPostViewModel(),
    );
  }
}

class _DraftPostView extends HookView<DraftPostViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, DraftPostViewModel vm) {
    final _nodePostText = useFocusNode();
    final _showImagePicker = useState<bool>(false);

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: _nodePostText,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    "Done",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                );
              },
            ],
          ),
        ],
      );
    });

    return NestedWillPopScope(
      onWillPop: () => vm.onWillPop(_ExitNotification()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          leadingWidth: 62.0.w,
          backgroundColor: const Color(0xFFF1FAFF),
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(left: 15.0.w),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: kPinkColor),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).maybePop();
                },
              );
            },
          ),
          titleText: "Write a Post",
          titleStyle: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black,
                fontSize: 16.0.sp,
              ),
        ),
        body: KeyboardActions(
          config: _kbConfig,
          disableScroll: true,
          child: Column(
            children: [
              Visibility(
                visible: vm.imageProvider.picked.length > 0,
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vm.imageProvider.picked.length,
                  crossAxisCount: 2,
                  itemBuilder: (ctx, index) {
                    return AssetPhotoThumbnail(
                      galleryItem: vm.imageProvider.picked[index],
                      onTap: () => vm.openGallery(index),
                      onRemove: () => vm.imageProvider.picked.removeAt(index),
                    );
                  },
                  staggeredTileBuilder: (index) {
                    if (vm.imageProvider.picked.length % 2 != 0 && index == 0) {
                      return new StaggeredTile.count(2, 0.5);
                    }
                    return new StaggeredTile.count(1, 0.5);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 0),
                  child: TextField(
                    focusNode: _nodePostText,
                    onChanged: vm.onPostMessageChanged,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () => _showImagePicker.value = false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 11.0,
                      ),
                      hintText: "What's on your mind?",
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0.h,
                  horizontal: 15.0.w,
                ),
                color: kInviteScreenColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            width: 1,
                            color: kTealColor,
                          ),
                        ),
                        child: Icon(
                          MdiIcons.fileImageOutline,
                          color: kTealColor,
                        ),
                      ),
                      onTap: () =>
                          _showImagePicker.value = !_showImagePicker.value,
                    ),
                    Spacer(),
                    SizedBox(
                      height: 40.0.h,
                      width: 100.0.w,
                      child: AppButton(
                        "POST",
                        kTealColor,
                        true,
                        () async => await performFuture<void>(vm.postHandler),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: _showImagePicker.value ? 150.0.h : 0.0.h,
                child: ImageGalleryPicker(
                  vm.imageProvider,
                  pickerHeight: 150.h,
                  assetHeight: 150.h,
                  assetWidth: 150.h,
                  thumbSize: 200,
                  enableSpecialItemBuilder: true,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: MediaQuery.of(context).viewInsets.bottom > 0
                    ? kKeyboardActionHeight
                    : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExitNotification extends StatelessWidget {
  const _ExitNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Wrap(
      children: [
        Container(
          height: 200.0.h,
          child: Container(
            margin: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Leave post?",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 70.0.w),
                  child: Text(
                    "Any progress you made will not be saved.",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        "Exit",
                        kTealColor,
                        false,
                        () => Navigator.of(context).pop(true),
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: AppButton(
                        "Continue Editing",
                        kTealColor,
                        true,
                        () => Navigator.of(context).pop(false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
