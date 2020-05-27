import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:math';

dynamic res;

/*Future fetchAlbum() async {
  final rand = Random();
  String s =  rand.nextInt(15).toString();
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/' + s);
  print("fetch");
  if (response.statusCode == 200) {
     res = json.decode(response.body);
     print(res);
  } else {
    throw Exception('Failed to load album');
  }
}
*/

Future fetchAlbum(String text) async {
  final rand = Random();
  print(text);
  String s =  rand.nextInt(15).toString();
  String url = "http://arcane-shelf-11603.herokuapp.com/conversation/";
  Map<String, String> headers = {"Content-type": "application/json"};
  String body = '{"mensagemUsuario": "${text}"}';
  final response = await http.post(url,headers: headers, body: body);
  
  print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  print("fetch");
  
  if (response.statusCode == 200) {
     res = json.decode(response.body);
     print(res['result']['output']['generic'][0]['text']);
    
  } else {
    throw Exception('Failed to load album');
  }
}
  
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatTwoPage()
    );
  }
}

class ChatTwoPage extends StatefulWidget {
  static final String path = "lib/src/pages/misc/chat2.dart";
  @override
  _ChatTwoPageState createState() => _ChatTwoPageState();
}

class _ChatTwoPageState extends State<ChatTwoPage> {
  String text;
  TextEditingController _controller;
  final List<String> avatars = [
  
  ];
  final List<Message> messages = [
   
  ];
  final rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BotBr"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10.0);
              },
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                Message m = messages[index];
                if (m.user == 0) return _buildMessageRow(m, current: true);
                return _buildMessageRow(m, current: false);
              },
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Aa"),
              onEditingComplete: _save,
              onChanged: (String value){
                print(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
       messages.insert(0, Message(1, _controller.text));
    });
   await fetchAlbum(_controller.text);
    setState(() {
      
     
      _controller.clear(); 
     messages.insert(0, Message(0, res['result']['output']['generic'][0]['text'].toString()));
    });
  }

  Row _buildMessageRow(Message message, {bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        if (!current) ...[
          const SizedBox(width: 5.0),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
              color: current ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            message.quebraLinha(),
            style: TextStyle(
                color: current ? Colors.white : Colors.black, fontSize: 18.0),
          ),
        ),
        if (current) ...[
          const SizedBox(width: 5.0),
        ],
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }
}

class Message {
  final int user;
  final String description;

  Message(this.user, this.description);

  
  String quebraLinha(){
    if(description.length > 38){
      double parti = description.length / 2;
      String comeco = description.substring(0, parti.toInt()); 
      String fim =  description.substring(parti.toInt(), description.length);
      String all = "";
     
      
     if(comeco.length > 30 || fim.length > 30){
       
          for(int i = 0; i < comeco.length; i++){
             if(i%25 == 0){
              all += comeco[i]  + "\n"  ;
           }else{
             all += comeco[i];
           }
          
       }
      for(int i = 0; i < fim.length; i++){
             if(i%25 == 0){
              all += fim[i]  + " \n"  ;
           } else{
              all += fim[i];
           } 
       }
     }else{
       all = comeco + "\n" + fim;
     }
     

      return all; 
    }
     return description;
  }
  }
