import 'package:collectors_app/screens/pickupsPage.dart';
import 'package:flutter/material.dart';

import '../components/errorPage.dart';
import '../models/collection.dart';
import '../services/collectionService.dart';
import 'dashboardScreen.dart';

class OnDemandScreen extends StatefulWidget {
  const OnDemandScreen({Key? key}) : super(key: key);

  @override
  State<OnDemandScreen> createState() => _OnDemandScreenState();
}

class _OnDemandScreenState extends State<OnDemandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("On Demand Pickups"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(622.0),
          child: getOnDemandRequests(),
        ),
      ),
    );

  }
}

FutureBuilder<List<Collection>> getOnDemandRequests() {
  return FutureBuilder<List<Collection>>(
    future: CollectionsService.getOnDemandRequests(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: NoInformation(errorDetail: snapshot.error.toString(), errorHeading: 'Connection Error'));
      } else if (snapshot.hasData) {
        if(snapshot.data!.isNotEmpty) {
          final collections = snapshot.data;
          return buildCollections(collections!);
        } else {
          return NoInformation(errorDetail: 'No On-demand Pickups', errorHeading: 'There are currently no on-demand requests');
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
