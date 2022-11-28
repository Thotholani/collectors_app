import 'package:carbon_icons/carbon_icons.dart';
import 'package:collectors_app/models/reply.dart';
import 'package:collectors_app/models/ticketReply.dart';
import 'package:collectors_app/screens/dashboardScreen.dart';
import 'package:collectors_app/services/ticketsService.dart';
import 'package:collectors_app/theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../components/errorPage.dart';

class TicketInvestigationScreen extends StatefulWidget {
  TicketInvestigationScreen({required this.collectionId});
  final String collectionId;

  @override
  State<TicketInvestigationScreen> createState() =>
      _TicketInvestigationScreenState();
}

class _TicketInvestigationScreenState extends State<TicketInvestigationScreen> {
  TextEditingController replyController = TextEditingController();
  var ticketId;

  List<TicketReply> ticketReplies = [
    TicketReply(replyText: "You are communicating to city council", ticketId: "SAMPLE TICKET", userId: "LCC", collectorId: "NULL", date: DateTime.now().toString())
  ].reversed.toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          title: Text("Ticket Investigation"),
          leading: IconButton(
            icon: Icon(
              EvaIcons.arrowIosBack,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: 80,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: GroupedListView<TicketReply, DateTime>(
                  order: GroupedListOrder.ASC,
                  padding: const EdgeInsets.all(8),
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  elements: ticketReplies,
                  groupBy: (reply) {
                    var replyAsDate = DateTime.parse(reply.date);
                    return DateTime(
                        replyAsDate.year, replyAsDate.month, replyAsDate.day);
                  },
                  groupHeaderBuilder: (TicketReply reply) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        color: Color(greyishBlueColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            DateFormat.yMMMd().format(DateTime.parse(reply.date)),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ),
                itemBuilder: (context, TicketReply reply) => Container(
                  child: getTicketReplies(),
                ),
              )),
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(style: BorderStyle.none),
                    color: Colors.white),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    // Text input
                    Flexible(
                      child: TextField(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0),
                        controller: replyController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                              color: Color(greyishBlueColor)
                          ),
                        ),
                      ),
                    ),
                    // Send Message Button
                    Material(
                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: Icon(CarbonIcons.send_filled,color: Color(secondaryGreenColor),),
                          onPressed: () {
                            var text = replyController.text;
                            if(text.isNotEmpty) {
                              final reply = TicketReply(ticketId: ticketReplies.last.ticketId, date: DateTime.now().toString(), collectorId: collector_id, replyText: text, userId: 'Collector Replied');
                              TicketsService.addReply(ticketId, text, collector_id);
                              setState(() => ticketReplies);
                              replyController.clear();
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please type in a message before clicking send",
                                backgroundColor: Color(cancelRedColor),
                              );
                            }
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  FutureBuilder<List<TicketReply>> getTicketReplies() {
    return FutureBuilder<List<TicketReply>>(
      future: TicketsService.getTicketReplies(widget.collectionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: NoInformation(errorDetail: snapshot.error.toString(), errorHeading: 'Connection Error'));
        } else if (snapshot.hasData) {
          if(snapshot.data!.isNotEmpty) {
            final collections = snapshot.data;
            return buildReplies(collections!);
          } else {
            return Center(
              child: Text("You are communicating with City Council"),
            );
          }
        } else {
          return Center(
            child: Column(
                children: [
                  Image.asset("assets/images/404.png"),
                  Text("Page Not Found",style: Theme.of(context).textTheme.headline3,)
                ]
            ),
          );
        }
      },
    );
  }

  Widget buildReplies(List<TicketReply> ticketReplies) => ListView.builder(
      shrinkWrap: true,
      itemCount: ticketReplies.length,
      itemBuilder: (context, index) {
        final ticketReply = ticketReplies[index];
        ticketId = ticketReply.ticketId;
        return Align(
          alignment: ticketReply.collectorId == collector_id
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Card(
            color: ticketReply.collectorId == collector_id ? Color(secondaryGreenColor): Color(primaryBlueColor),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(ticketReply.replyText,style: TextStyle(color: Colors.white),),
            ),
          ),
        );
      });
}


