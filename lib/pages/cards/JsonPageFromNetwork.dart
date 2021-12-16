import 'dart:convert';
import 'package:flutter/material.dart';

class JsonPageFromNetwork extends StatefulWidget {

  @override
  _JsonPageFromNetworkState createState() => _JsonPageFromNetworkState();
}

class _JsonPageFromNetworkState extends State<JsonPageFromNetwork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder(builder: (context, snapshot){
              var showData = json.decode(snapshot.data.toString());
              return ListView.builder(
                itemCount: showData.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(showData[index]['videoName']),
                    subtitle: Text(showData[index]['courseName']),
                  );
                },
              );
            }, future: DefaultAssetBundle.of(context).loadString('assets/courseNetworkSubtitle.json'),
            )
        )
    );
  }
}
