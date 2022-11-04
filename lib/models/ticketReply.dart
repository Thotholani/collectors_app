class TicketReply {
  String replyText;
  String ticketId;
  String userId;
  String collectorId;
  String date;

  TicketReply({required this.replyText, required this.ticketId, required this.userId, required this.collectorId, required this.date});

  static TicketReply fromJson(json) => TicketReply(
      replyText: json['reply_text'],
      ticketId:json['ticket_id'],
      userId: json['user'],
      collectorId: json['collector_id'],
      date: json['date'],
  );
}