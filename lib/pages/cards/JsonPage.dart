import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/pages/cards/normal_player_page.dart';

String name = "Mobile Programming";
class JsonPage extends StatefulWidget {
  final String s;
  JsonPage(this.s, { Key key}) : super(key: key);
  @override
  _JsonPageState createState() => _JsonPageState();
}

class _JsonPageState extends State<JsonPage> {

  @override
  Widget build(BuildContext context) {
    int i = 0;
    print("s is: " + widget.s);
    if (widget.s == name) {
      return Scaffold(
        body: Center(
          child: FutureBuilder(builder: (context, snapshot) {
            var showData = json.decode(snapshot.data.toString());
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                i+=1;
                return ListTile(
                  title: Text(showData[index]['videoName']),
                  subtitle: Text(showData[index]['courseName']),
                  onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => NormalPlayerPage(),
                ),
                ),
                );
              },
              itemCount: showData.length,
            );
          },
            future: DefaultAssetBundle.of(context).loadString(
                "assets/example.json"),

          ),
        ),

      );
    }
    else{
      return Scaffold(
        appBar: AppBar(title: Text("Load JSON File From Local"),),
        body: Center(
          child: FutureBuilder(builder: (context, snapshot) {
            var showData = json.decode(snapshot.data.toString());
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(showData[index]['videoName']),
                  subtitle: Text(showData[index]['courseName']),
                //   onTap: Navigator.push(
                // context,
                // MaterialPageRoute(
                // builder: (context) => YourNewPage(),
                // ),
                // );
                // },
                );
              },
              itemCount: showData.length,
            );
          },
            future: DefaultAssetBundle.of(context).loadString(
                "assets/course.json"),
          ),
        ),

      );
    }
  }
}