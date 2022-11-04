import 'dart:convert';

import 'package:collectors_app/models/ticketReply.dart';

import '../main.dart';
import '../models/reply.dart';
import 'package:http/http.dart' as http;

class TicketsService{
  static Future<List<TicketReply>> getTicketReplies(String collectionId) async {
    String url = MyApp().url + "/getTicketReplies.php";

    // print("Collection Id before getting ticket replies: $collectionId");

    var response = await http.post(Uri.parse(url), body: {
      'collection_id': collectionId,
    });

    final body = json.decode(response.body);
    // print("This is the body");
    // print(body);
    return List.from(body.map<TicketReply>(TicketReply.fromJson).toList());
  }

  static addReply(String ticketId, String message, String collectorId) async {
    print("Running insert reply code");
    String url = MyApp().url + "/addReply.php";

    print("Printing ids and message before sending to server:");
    print("Ticket ID: $ticketId");
    print("Message: $message");
    print("Collector ID: $collectorId");

    var response = await http.post(Uri.parse(url), body: {
      'ticket_id': ticketId,
      'message': message,
      'collector_id': collectorId,
    });

    if (response.statusCode == 200) {
      // print(response);
      // print(response.body);
      var jsondata = jsonDecode(response.body.toString());
      if(jsondata["success"]) {
        print(jsondata["message"]);
      } else {
        print(jsondata["error"]);
      }
    } else {
      print("Error connecting to server");
    }
  }
}