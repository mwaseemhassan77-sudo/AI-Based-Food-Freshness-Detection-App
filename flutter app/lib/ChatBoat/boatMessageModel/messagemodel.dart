class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime time;
  bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.time,
    this.isRead = false,
  });
}
