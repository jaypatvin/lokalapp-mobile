import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../models/conversation.dart';
import '../../../utils/themes.dart';
import '../../../widgets/input_images.dart';
import '../../../widgets/input_text_field.dart';
import 'reply_message.dart';

class ChatInput extends StatelessWidget {
  final void Function() onMessageSend;
  final void Function() onShowImagePicker;
  final void Function() onCancelReply;
  final void Function(int) onImageRemove;
  final TextEditingController chatInputController;
  final Conversation replyMessage;
  final List<AssetEntity> images;

  const ChatInput({
    Key key,
    @required this.onMessageSend,
    @required this.onShowImagePicker,
    @required this.onCancelReply,
    @required this.replyMessage,
    @required this.images,
    @required this.onImageRemove,
    @required this.chatInputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        replyMessage != null
            ? ReplyMessageWidget(
                message: replyMessage,
                onCancelReply: onCancelReply,
              )
            : Container(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: kTealColor),
                ),
                child: Icon(
                  MdiIcons.fileImageOutline,
                  color: kTealColor,
                ),
              ),
              onTap: onShowImagePicker,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
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
                        height: this.images.length > 0 ? 100 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: InputImages(
                          pickedImages: this.images,
                          onImageRemove: this.onImageRemove,
                        ),
                      ),
                      InputTextField(
                        chatInputController: this.chatInputController,
                        onSend: this.onMessageSend,
                        hintText: "Type a Message",
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
