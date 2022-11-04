import 'package:avatar_glow/avatar_glow.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:collectors_app/components/buttons.dart';
import 'package:collectors_app/services/collectionService.dart';
import 'package:collectors_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../screens/dashboardScreen.dart';
import '../screens/mapPage.dart';

class CollectionDialog extends StatefulWidget {
  CollectionDialog({required this.address, required this.serviceFee, required this.setPage, required this.collection_id, required this.acceptedRequest});

  final void Function(bool) setPage;
  final void Function(bool) acceptedRequest;

  final String address;
  final String serviceFee;
  final String collection_id;

  @override
  State<CollectionDialog> createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<CollectionDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * .4;
    return AlertDialog(
      title: AvatarGlow(child: Container(
          height: 75,width: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color(primaryBlueColor),
          ),
          child: Icon(CarbonIcons.delivery_truck,size: 50,color: Colors.white,)), endRadius: 60,glowColor: Color(primaryBlueColor),),
      content: Container(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(child:Text(textAlign: TextAlign.center,'Incoming pickup request...',style: Theme.of(context).textTheme.headline6,)
                , baseColor: Color(secondaryGreenColor), highlightColor: Color(primaryBlueColor)),
            SizedBox(height: 5,),
            Text("Location",style: Theme.of(context).textTheme.bodyText2),
            Text(widget.address,style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",style: Theme.of(context).textTheme.headline3),
                Text("K${widget.serviceFee}.00",style: Theme.of(context).textTheme.headline3)
              ],
            ),
            SizedBox(height: 20,),
            SizedBox(
               height: 55,
               width: double.infinity,
               child: ElevatedButton(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all<Color>(Color(secondaryGreenColor)),
                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(5.0),
                         )
                     ),
                   ),
                   onPressed: (){
                     acceptRequest(widget.collection_id,collector_id,context);
                     widget.setPage(false);
                     widget.acceptedRequest(true);
                     setState((){
                       isLoading = true;
                     });
                   }, child: isLoading ? CircularProgressIndicator(
                 color: Colors.white,
               ) : Text("Accpet")
               ),
             ),
             // SecondaryGreenButton(buttonText: "Accept", onPressed: (){
             SizedBox(height: 10,),
             CancelRedButton(buttonText: "Deny", onPressed: (){
               Navigator.pop(context);
               widget.setPage(false);
             })
          ],
        ),
      ),
    );
  }
}
