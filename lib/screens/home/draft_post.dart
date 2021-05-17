import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../services/local_image_service.dart';
import '../../utils/themes.dart';
import '../../utils/utility.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_view_gallery/gallery_file_photo_thumbnail.dart';
import '../../widgets/photo_view_gallery/gallery_file_photo_view.dart';
import '../../widgets/rounded_button.dart';

class DraftPost extends StatefulWidget {
  @override
  _DraftPostState createState() => _DraftPostState();
}

class _DraftPostState extends State<DraftPost> {
  TextEditingController _userController = TextEditingController();
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<File> _images = [];

  @override
  void initState() {
    // _user = Provider.of<CurrentUser>(context, listen: false);
    super.initState();
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
          onTap: () async {
            var _utils = Provider.of<MediaUtility>(context, listen: false);
            var file = await _utils.showMediaDialog(context);
            if (_images.length > 5) {
              _images.remove(_images.first);
            }
            _images.add(file);
          },
        ),
        Spacer(),
        RoundedButton(
          onPressed: () async {
            var service =
                Provider.of<LocalImageService>(context, listen: false);
            var activities = Provider.of<Activities>(context, listen: false);
            var user = Provider.of<CurrentUser>(context, listen: false);

            var gallery = <LokalImages>[];
            for (var image in _images) {
              var url =
                  await service.uploadImage(file: image, name: "post_photo");
              gallery.add(LokalImages(url: url, order: _images.indexOf(image)));
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
        builder: (context) => GalleryFilePhotoView(
          galleryItems: this._images,
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
    var images = this._images;
    var count = images.length;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      crossAxisCount: 2,
      itemBuilder: (ctx, index) {
        return GalleryFilePhotoThumbnail(
          galleryItem: images[index],
          onTap: () {
            openGallery(context, index);
          },
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
          children: <Widget>[
            Visibility(
              visible: _images.length > 0,
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
          ],
        ),
      ),
    );
  }
}
