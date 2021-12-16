import 'dart:async';
import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NormalPlayerPage extends StatefulWidget {
  @override
  _NormalPlayerPageState createState() => _NormalPlayerPageState();
}

class _NormalPlayerPageState extends State<NormalPlayerPage> {
  BetterPlayerController _betterPlayerController = new BetterPlayerController(BetterPlayerConfiguration(
    aspectRatio: 16 / 9,
    fit: BoxFit.contain,
    autoPlay: true,
    looping: true,
  ));
  int _itemCount = 0;
  String s = "";
  Timer timer;
  Future<String> getQuotes() async {
    List<dynamic> jsonResponse;
    String st;
    String _Query = "Mobile Programming/Lecture 5.1 - Adding Interactivity and Navigation to Your App.mp4";

    String url = "http://datlas01.pythonanywhere.com/query/?query=$_Query";
    http.Response response = await http.get(Uri.parse(url)) as http.Response;
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = convert.jsonDecode(response.body);
        _itemCount = jsonResponse.length;
      });

//      jsonResponse[0]["author"]; = author name
//      jsonResponse[0]["quote"]; = quotes text
      print("Number of quotes found : $_itemCount.");
      s = jsonResponse[0]["quote"].toString();
      print("s is:");
      print(s);
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
    return Future(()=>s);
  }



  @override
  void initState() {
    BetterPlayerDataSource _betterPlayerDataSource;

    String st = "";

    print("s is in init" + s);
    getQuotes().then((result) {
      _betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        result,
      );

      _betterPlayerController.setupDataSource(_betterPlayerDataSource);
      setState(() {});

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Normal player page"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ],
      ),
    );
  }
}
