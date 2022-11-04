import 'package:carbon_icons/carbon_icons.dart';
import 'package:collectors_app/screens/dashboardScreen.dart';
import 'package:collectors_app/screens/ticketInvestigationScreen.dart';
import 'package:flutter/material.dart';

import '../services/collectionService.dart';
import '../theme.dart';
import 'buttons.dart';

class PickupCard extends StatefulWidget {
  PickupCard({required this.collectionNumber,required this.address,required this.date,required this.fee,required this.status});
  int collectionNumber;
  String date;
  String address;
  double fee;
  String status;

  @override
  State<PickupCard> createState() => _PickupCardState();
}

class _PickupCardState extends State<PickupCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String collectionNumber = widget.collectionNumber.toString();
    String  date = widget.date.toString();
    String fee = widget.fee.toString();
    String status = widget.status.toString();

    TextEditingController descriptionController = TextEditingController();
    String description = "";

    var selectedItem;

    IconData icon = CarbonIcons.time;
    int iconColor = thirdYellowColor;
    List<Widget> actions = [
      SecondaryGreenButton(buttonText: 'Accept Request', onPressed: (){
        acceptRequest(collectionNumber, collector_id, context);
      })
    ];

    if(status == "Completed") {
      setState(() {
        icon = CarbonIcons.checkmark;
        iconColor = secondaryGreenColor;
        actions = [

        ];
      });
    } else if (status == "Canceled") {
      setState(() {
        icon = CarbonIcons.close;
        iconColor = cancelRedColor;
        actions = [];
      });
    } else if (status == "Under Investigation") {
      setState(() {
        icon = CarbonIcons.query;
        iconColor = infoCyanColor;
        actions = [
          GenericButton(buttonText: "View Investigation", onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketInvestigationScreen(collectionId: collectionNumber,)));
          }, color: infoCyanColor)
        ];
      });
    } else if (status == "In Transit") {
      setState(() {
        icon = CarbonIcons.delivery;
        iconColor = tealColor;
        actions = [

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
            onPressed: (){
            acceptRequest(collectionNumber,collector_id,context);
              setState((){
                isLoading = true;
              });
            },
            child: isLoading ? CircularProgressIndicator(
              color: Colors.white,
              ) : Text("Go To Map"),
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(tealColor)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            )
            ),
            ),
          ))
          // GenericButton(buttonText: "Go to Map", onPressed: (){
          //   acceptRequest(collectionNumber,collector_id,context);
          // }, color: tealColor)
        ];
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Container(
          alignment: Alignment.center,
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Icon(icon, size: 50,color: Color(iconColor),),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Collection Number: " + collectionNumber,style: Theme.of(context).textTheme.bodyText1,),
                  Text("Date: "+ date,style: Theme.of(context).textTheme.bodyText1,),
                  Text("Fee: K"+ fee,style: Theme.of(context).textTheme.bodyText1,),
                  Text("Status: "+ status,style: Theme.of(context).textTheme.bodyText1,)
                ],
              )
            ],
          ),
        ),
        children: actions,
      ),
    );
  }
}