import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/chat_model.dart';
import '../../providers/auth.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/chat/chat_details.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import 'chat_bubble.dart';
import 'chat_profile.dart';
import 'components/chat_input.dart';
import 'components/message_stream.dart';

class ChatDetails extends StatelessWidget {
  static const routeName = '/chat/details';
  const ChatDetails({
    Key? key,
    required this.members,
    this.chat,
    this.shopId,
    this.productId,
  }) : super(key: key);

  final List<String> members;
  final ChatModel? chat;
  final String? shopId;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => ChatDetailsView(),
      viewModel: ChatDetailsViewModel(
        members: members,
        chat: chat,
        shopId: shopId,
        productId: productId,
      ),
    );
  }
}

class ChatDetailsView extends HookView<ChatDetailsViewModel> {
  Widget _buildMessageStream(ChatDetailsViewModel viewModel) {
    if (viewModel.messageStream == null && viewModel.isSendingMessage) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: 1,
        itemBuilder: (ctx, index) {
          return ChatBubble(
            conversation: viewModel.currentSendingMessage,
          );
        },
      );
    }
    if (viewModel.messageStream == null) {
      return Center(
        child: Text(
          'No messages here yet...',
          style: TextStyle(
            fontSize: 24.0.sp,
            color: Colors.black,
          ),
        ),
      );
    }
    return MessageStream(
      messageStream: viewModel.messageStream,
      onReply: viewModel.onReply,
      onDelete: viewModel.onDeleteMessage,
      trailing: _buildAdditionalStates(viewModel),
    );
  }

  Widget _buildAdditionalStates(ChatDetailsViewModel viewModel) {
    Widget child = const SizedBox();
    if (viewModel.isSendingMessage) {
      child = ChatBubble(
        conversation: viewModel.currentSendingMessage,
        images: viewModel.sendingImages,
      );
    } else if (viewModel.didUserSendLastMessage) {
      child = const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            right: 10,
            bottom: 5,
          ),
          child: Text(
            'Delivered',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: child,
    );
  }

  @override
  Widget render(BuildContext context, ChatDetailsViewModel viewModel) {
    final _indicatorColor = useMemoized<Color>(() {
      final _userId = context.read<Auth>().user?.id;
      return viewModel.members.contains(_userId) ? kTealColor : kPurpleColor;
    });

    final _chatInputNode = useFocusNode();
    final _chatInputController = useTextEditingController();

    useEffect(() {
      void listener() {
        viewModel.message = _chatInputController.text;
      }

      _chatInputController.addListener(listener);
    }, [
      _chatInputController,
      viewModel,
    ]);

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: _indicatorColor,
        titleText: viewModel.chat?.title ?? '',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 16.0),
        onPressedLeading: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 30.r,
            ),
            onPressed: () {
              if (viewModel.chat != null) {
                Navigator.push(
                  context,
                  AppNavigator.appPageRoute(
                    builder: (_) => ChatProfile(
                      viewModel.chat!,
                      viewModel.conversations,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardBarColor: Colors.transparent,
          actions: [
            KeyboardActionsItem(
              focusNode: _chatInputNode,
              displayActionBar: false,
              toolbarButtons: [
                (node) {
                  return TextButton(
                    onPressed: () => node.unfocus(),
                    child: Text(
                      'Done',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.black),
                    ),
                  );
                },
              ],
            ),
          ],
        ),
        disableScroll: true,
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: Builder(
          builder: (context) {
            if (viewModel.isLoading) {
              return SizedBox.expand(
                child: Lottie.asset(kAnimationLoading),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: _buildMessageStream(viewModel),
                  ),
                ),
                Container(
                  color: kInviteScreenColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0.w,
                    vertical: 10.0.h,
                  ),
                  child: ChatInput(
                    onMessageSend: () {
                      viewModel.onSendMessage();
                      _chatInputController.clear();
                    },
                    onShowImagePicker: viewModel.onShowImagePicker,
                    onCancelReply: () => viewModel.replyTo = null,
                    onImageRemove: viewModel.onImageRemove,
                    chatInputController: _chatInputController,
                    replyMessage: viewModel.replyTo,
                    images: viewModel.imageProvider.picked,
                    onTextFieldTap: () => viewModel.showImagePicker = false,
                    chatFocusNode: _chatInputNode,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: viewModel.showImagePicker ? 150.0.h : 0.0.h,
                  child: ImageGalleryPicker(
                    viewModel.imageProvider,
                    pickerHeight: 150.h,
                    assetHeight: 150.h,
                    assetWidth: 150.h,
                    thumbSize: 200,
                    enableSpecialItemBuilder: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
