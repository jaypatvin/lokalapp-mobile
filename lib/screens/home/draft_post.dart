import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';
import '../../widgets/photo_view_gallery/thumbnails/asset_photo_thumbnail.dart';
import '../../widgets/rounded_button.dart';

class DraftPost extends StatefulWidget {
  @override
  _DraftPostState createState() => _DraftPostState();
}

class _DraftPostState extends State<DraftPost> with TickerProviderStateMixin {
  final TextEditingController _userController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  CustomPickerDataProvider provider;
  bool showImagePicker = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CustomPickerDataProvider>(context, listen: false);
    provider.onPickMax.addListener(showMaxAssetsText);
    provider.pickedNotifier.addListener(onPick);
    providerInit();
  }

  @override
  void dispose() {
    provider.picked.clear();
    provider.removeListener(showMaxAssetsText);
    provider.pickedNotifier.removeListener(onPick);
    super.dispose();
  }

  void onPick() {
    setState(() {});
  }

  Future<void> providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    provider.resetPathList(pathList);
  }

  void showMaxAssetsText() {
    // TODO: use OKToast
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per post."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildCard() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 0),
      child: TextField(
        controller: _userController,
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: "What's on your mind?",
          hintStyle: kTextStyle.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        style: kTextStyle.copyWith(
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Row postButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 1, color: Colors.grey)),
            child: Icon(
              MdiIcons.fileImageOutline,
              color: Colors.grey,
            ),
          ),
          onTap: () =>
              setState(() => this.showImagePicker = !this.showImagePicker),
        ),
        Spacer(),
        RoundedButton(
          onPressed: () async {
            var service =
                Provider.of<LocalImageService>(context, listen: false);
            var activities = Provider.of<Activities>(context, listen: false);
            var user = Provider.of<CurrentUser>(context, listen: false);

            var gallery = <LokalImages>[];
            for (var asset in provider.picked) {
              var file = await asset.file;
              var url =
                  await service.uploadImage(file: file, name: 'post_photo');
              gallery.add(
                  LokalImages(url: url, order: provider.picked.indexOf(asset)));
            }

            bool postSuccess = await activities.post(
              user.idToken,
              {
                'community_id': user.communityId,
                'user_id': user.id,
                'message': _userController.text,
                'images': gallery.map((x) => x.toMap()).toList(),
              },
            );
            if (postSuccess) {
              Navigator.pop(context, true);
            }
          },
          label: "Post",
          fontFamily: "Goldplay",
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  void openGallery(
    BuildContext context,
    final int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryAssetPhotoView(
          galleryItems: this.provider.picked,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget buildPostImages({
    BuildContext context,
  }) {
    var count = provider.picked.length;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      crossAxisCount: 2,
      itemBuilder: (ctx, index) {
        return AssetPhotoThumbnail(
          galleryItem: this.provider.picked[index],
          onTap: () => openGallery(context, index),
          onRemove: () => setState(() => this.provider.picked.removeAt(index)),
        );
      },
      staggeredTileBuilder: (index) {
        if (count % 2 != 0 && index == 0) {
          return new StaggeredTile.count(2, 0.5);
        }
        return new StaggeredTile.count(1, 0.5);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: customAppBar(
        backgroundColor: const Color(0xFFF1FAFF),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: width * 0.02),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: kTextStyle.copyWith(
                      color: kPinkColor,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        titleText: "Write a Post",
        titleStyle: kTextStyle.copyWith(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Visibility(
              visible: provider.picked.length > 0,
              child: buildPostImages(context: context),
            ),
            Container(
              height: height * 0.30,
              child: buildCard(),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
                vertical: height * 0.02,
              ),
              child: postButton(),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: this.showImagePicker ? 200 : 0.0,
              child: ImageGalleryPicker(
                provider,
                pickerHeight: 200,
                assetHeight: 200,
                assetWidth: 200,
                thumbSize: 200,
                enableSpecialItemBuilder: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
