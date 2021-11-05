import '../../models/chat_model.dart';

class ChatViewProps {
  const ChatViewProps(
    this.createMessage, {
    this.chat,
    this.members,
    this.shopId,
    this.productId,
  });

  final ChatModel? chat;
  final bool createMessage;
  final List<String?>? members;
  final String? shopId;
  final String? productId;
}
