import 'package:collectors_app/screens/dashboardScreen.dart';
import 'package:collectors_app/services/collectionService.dart';
import 'package:collectors_app/theme.dart';
import 'package:flutter/material.dart';

import '../components/cards.dart';
import '../components/errorPage.dart';
import '../models/collection.dart';

class PickupsPage extends StatefulWidget {
  const PickupsPage({Key? key}) : super(key: key);

  @override
  State<PickupsPage> createState() => _PickupsPageState();
}

class _PickupsPageState extends State<PickupsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
           title: Text("Pickup Requests"),
          bottom: TabBar(
            labelColor: Color(primaryBlueColor),
            indicatorWeight: 3,
            indicatorColor: Color(secondaryGreenColor),
            tabs: [
              Tab(text: "Current Requests",),
              Tab(text: "Previous Requests",)
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: TabBarView(
            children: [
              Expanded(child: getCurrentRequests(),),
              Expanded(child: getPreviousRequests(),),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentRequestsPage extends StatelessWidget {
  const CurrentRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getCurrentRequests();
  }
}

// FUNCTIONS

FutureBuilder<List<Collection>> getCurrentRequests() {
  return FutureBuilder<List<Collection>>(
    future: CollectionsService.getCurrentCollections(collector_id),
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
          return NoInformation(errorDetail: 'You have no present pickup requests', errorHeading: 'No Collections Available');
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

FutureBuilder<List<Collection>> getPreviousRequests() {
  return FutureBuilder<List<Collection>>(
    future: CollectionsService.getPreviousCollections(collector_id),
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
          return NoInformation(errorDetail: 'You have no previous pickup requests', errorHeading: 'No Collections Available');
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

Widget buildCollections(List<Collection> collections) => ListView.builder(
    itemCount: collections.length,
    itemBuilder: (context, index) {
      final collection = collections[index];
      return PickupCard(
          collectionNumber: int.parse(collection.collection_id),
          date: collection.date,
          fee: double.parse(collection.fee.toString()),
          status: collection.status,
          address: '',
      );
    });