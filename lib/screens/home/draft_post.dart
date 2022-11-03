import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final nodePostText = useFocusNode();

    final kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: nodePostText,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    'Done',
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
      onWillPop: () => vm.onWillPop(const _ExitNotification()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          titleText: 'Write a Post',
          titleStyle: const TextStyle(color: Colors.black),
          leadingWidth: 100,
          backgroundColor: const Color(0xFFF1FAFF),
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: kPinkColor),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
        body: KeyboardActions(
          config: kbConfig,
          disableScroll: true,
          child: Column(
            children: [
              Visibility(
                visible: vm.imageProvider.picked.isNotEmpty,
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 7,
                  crossAxisSpacing: 8,
                  children:
                      vm.imageProvider.picked.map<StaggeredGridTile>((image) {
                    final index = vm.imageProvider.picked.indexOf(image);
                    final crossAxisCellCount =
                        vm.imageProvider.picked.length % 2 != 0 && index == 0
                            ? 2
                            : 1;
                    return StaggeredGridTile.count(
                      crossAxisCellCount: crossAxisCellCount,
                      mainAxisCellCount: 0.5,
                      child: AssetPhotoThumbnail(
                        key: Key(
                          'post_details_${vm.imageProvider.picked[index].id}',
                        ),
                        galleryItem: vm.imageProvider.picked[index],
                        onTap: () => vm.openGallery(index),
                        onRemove: () => vm.imageProvider.removeAt(index),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: nodePostText,
                  onChanged: vm.onPostMessageChanged,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () => vm.showImagePicker = false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    hintText: "What's on your mind?",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 18.0),
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: kInviteScreenColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: vm.onShowImagePicker,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: kTealColor,
                          ),
                        ),
                        child: const Icon(
                          MdiIcons.fileImageOutline,
                          color: kTealColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AppButton.filled(
                      height: 39,
                      width: 116,
                      text: 'POST',
                      onPressed: () async =>
                          performFuture<void>(vm.postHandler),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                color: kInviteScreenColor,
                duration: const Duration(milliseconds: 100),
                height: vm.showImagePicker ? 128 : 0.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                child: ImageGalleryPicker(
                  vm.imageProvider,
                  pickerHeight: 107,
                  assetHeight: 107,
                  assetWidth: 109,
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
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Leave post?',
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 76),
                child: Text(
                  'Any progress you made will not be saved.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: AppButton.transparent(
                      text: 'Exit',
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton.filled(
                      text: 'Continue Editing',
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
