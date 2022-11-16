import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../models/conversation.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/functions.utils.dart';
import '../../../widgets/inputs/input_images_picker.dart';
import '../../../widgets/inputs/input_text_field.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class ChatInput extends StatelessWidget {
  final void Function() onMessageSend;
  final void Function() onShowImagePicker;
  final void Function() onCancelReply;
  final void Function()? onTextFieldTap;
  final void Function(int) onImageRemove;
  final TextEditingController chatInputController;
  final FocusNode? chatFocusNode;
  final Conversation? replyMessage;
  final List<AssetEntity> images;

  const ChatInput({
    super.key,
    required this.onMessageSend,
    required this.onShowImagePicker,
    required this.onCancelReply,
    required this.replyMessage,
    required this.images,
    required this.onImageRemove,
    required this.chatInputController,
    this.chatFocusNode,
    this.onTextFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (replyMessage != null)
          _ReplyToWidget(
            key: ValueKey('reply-to-${replyMessage!.id}'),
            message: replyMessage!,
            onCancelReply: onCancelReply,
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onShowImagePicker,
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
                        height: images.isNotEmpty ? 100 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: InputImagesPicker(
                          pickedImages: images,
                          onImageRemove: onImageRemove,
                        ),
                      ),
                      InputTextField(
                        inputController: chatInputController,
                        onSend: onMessageSend,
                        hintText: 'Type a Message',
                        onTap: onTextFieldTap,
                        inputFocusNode: chatFocusNode,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReplyToWidget extends StatelessWidget {
  const _ReplyToWidget({super.key, required this.message, this.onCancelReply});

  final Conversation message;
  final void Function()? onCancelReply;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(color: kTealColor, width: 2.0),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 13, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Replying to',
                          style: TextStyle(
                            fontFamily: 'Goldplay',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: kTealColor,
                          ),
                        ),
                      ),
                      if (onCancelReply != null)
                        GestureDetector(
                          onTap: onCancelReply,
                          child: const Icon(Icons.close, size: 9),
                        )
                    ],
                  ),
                  if (message.media != null && message.media!.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        // this shrinkWrap is okay since there are only 5 media
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: message.media!.length,
                        itemBuilder: (ctx, index) {
                          return NetworkPhotoThumbnail(
                            galleryItem: message.media![index],
                            onTap: () =>
                                openGallery(context, index, message.media),
                          );
                        },
                      ),
                    ),
                  if (message.message != null)
                    Text(
                      message.message!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
