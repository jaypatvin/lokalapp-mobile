import '../../../models/chat_model.dart';

class ChatDetailsProps {
  final List<String> members;
  final ChatModel? chat;
  final String? shopId;
  final String? productId;

  ChatDetailsProps({
    required this.members,
    this.chat,
    this.shopId,
    this.productId,
  });
}
