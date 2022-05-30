import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/activity_feed.dart';
import '../../../utils/functions.utils.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class PostDetailsImages extends StatelessWidget {
  const PostDetailsImages(
    this.activity, {
    Key? key,
  }) : super(key: key);

  final ActivityFeed activity;

  @override
  Widget build(BuildContext context) {
    final images = activity.images;
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: images.map<StaggeredGridTile>((image) {
        final index = images.indexOf(image);
        final crossAxisCellCount = images.length % 2 != 0 && index == 0 ? 2 : 1;
        return StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount,
          mainAxisCellCount: 1,
          child: NetworkPhotoThumbnail(
            key: Key('post_details_${images[index].url}'),
            heroTag: 'post_details_${images[index].url}',
            galleryItem: images[index],
            onTap: () => openGallery(context, index, images),
          ),
        );
      }).toList(),
    );
  }
}
