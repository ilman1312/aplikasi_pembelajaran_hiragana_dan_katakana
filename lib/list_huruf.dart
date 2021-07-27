import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DataHiragana {
  String index;
  String huruf;
  String ejaan;
  String audio;

  DataHiragana(
    {
      this.index,
      this.huruf,
      this.ejaan,
      this.audio,
    }
  );

  factory DataHiragana.fromJson(Map<String, dynamic> json) {
    return DataHiragana(
      index: json['index_huruf'],
      huruf: json['huruf'],
      ejaan: json['ejaan_huruf'],
      audio: json['audio_huruf'],
    );
  }
}

class DataKatakana {
  String index;
  String huruf;
  String ejaan;
  String audio;

  DataKatakana(
    {
      this.index,
      this.huruf,
      this.ejaan,
      this.audio,
    }
  );

  factory DataKatakana.fromJson(Map<String, dynamic> json) {
    return DataKatakana(
      index: json['index_huruf'],
      huruf: json['huruf'],
      ejaan: json['ejaan_huruf'],
      audio: json['audio_huruf'],
    );
  }
}

class ListHuruf extends StatefulWidget {
  @override
  _ListHurufState createState() => _ListHurufState();
}

class _ListHurufState extends State<ListHuruf> with TickerProviderStateMixin{
  TabController tabController;

  final String urihiragana = 'https://hirakana.000webhostapp.com/hiragana.php';
  Future<List<DataHiragana>> fetchhhiragana() async {

    var response = await http.get(urihiragana);

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<DataHiragana> listOfHiragana = items.map<DataHiragana>((json) {
        return DataHiragana.fromJson(json);
      }).toList();

      return listOfHiragana;
      }
     else {
      throw Exception('Failed to load data.');
    }

  }

  
  final String urikatakana = 'https://hirakana.000webhostapp.com/katakana.php';
  Future<List<DataKatakana>> fetchkatakana() async {

    var response = await http.get(urikatakana);

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<DataKatakana> listOfkatakana = items.map<DataKatakana>((json) {
        return DataKatakana.fromJson(json);
      }).toList();

      return listOfkatakana;
      }
     else {
      throw Exception('Failed to load data.');
    }

  }


  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);

    var tabBarItem = new TabBar(
      tabs: [
        new Tab(
          child: Text('Hiragana'),
        ),
        new Tab(
          child: Text('Katakana'),
        ),
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );

    var hiraganaview = new FutureBuilder<List<DataHiragana>>(
      future: fetchhhiragana(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: new Card(
                    elevation: 5.0,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "${snapshot.data[index].huruf}",
                          style: TextStyle(fontSize: 40,),
                        ),
                      ),
                      Text(
                        "${snapshot.data[index].ejaan}",
                        style: TextStyle(fontSize: 25),
                      ),
                    ],),
                  ),

                  onTap: () {
                    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(
                      Audio('assets/${snapshot.data[index].audio}')
                    );
                  },
                );
              }
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return Center(
          child: SpinKitFadingCircle(color: Color(0xFF333366),),
        );
      },
    );

    var katakanaView = new FutureBuilder<List<DataKatakana>>(
      future: fetchkatakana(),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: new Card(
                    elevation: 5.0,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "${snapshot.data[index].huruf}",
                          style: TextStyle(fontSize: 40,),
                        ),
                      ),
                      Text(
                        "${snapshot.data[index].ejaan}",
                        style: TextStyle(fontSize: 25),
                      ),
                    ],),
                  ),

                  onTap: () {
                    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(
                      Audio('assets/${snapshot.data[index].audio}')
                    );
                  },
                );
              }
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return Center(
          child: SpinKitFadingCircle(color: Color(0xFF333366),),
        );
      },
    );

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Huruf"),
          bottom: tabBarItem,
        ),
        body: new TabBarView(
          controller: tabController,
          children: [
            hiraganaview,
            katakanaView,
          ],
        ),
      ),
    );
  }
}