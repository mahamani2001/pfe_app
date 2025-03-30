class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final int receiverId;
  final String content;
  final String nonce;
  final String encryptedAESKey;
  final String? authTag;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.nonce,
    required this.encryptedAESKey,
    this.authTag,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    print('🔎 Message reçu : $json');

    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      nonce: json['nonce'],
      encryptedAESKey: json['encrypted_aes_key'],
      authTag: json['auth_tag'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
