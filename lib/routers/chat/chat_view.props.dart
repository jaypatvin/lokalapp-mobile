import '../../models/chat_model.dart';

class ChatViewProps {
  const ChatViewProps({
    this.chat,
    this.createMessage = true,
    this.members,
    this.shopId,
    this.productId,
  });

  final ChatModel? chat;
  final bool createMessage;
  final List<String>? members;
  final String? shopId;
  final String? productId;
}
