
import '../../../models/chat_model.dart';
import '../../../models/conversation.dart';

class ChatProfileProps {
  const ChatProfileProps(this.chat, this.conversations);
  final ChatModel chat;
  final List<Conversation>? conversations;
}
