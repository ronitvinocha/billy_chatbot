import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

import 'messagestypes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Example Dialogflow Flutter',
      debugShowCheckedModeBanner: false,
      home: new HomePageDialogflow(),
    );
  }
}

class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageDialogflow createState() => new _HomePageDialogflow();
}

class _HomePageDialogflow extends State<HomePageDialogflow> {
  final List<ListItem> _messages = <ListItem>[];
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    Response("What is your name?");
  }
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    debugPrint(response.queryResult.intent.displayName);
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('E hh:mm').format(date);
    if(response.queryResult.intent.displayName.compareTo("welcomefollowup")==0)
      {
         if(response.getListMessage()[1]['payload']["buttons"]!=null){
           List<dynamic> buttons=response.getListMessage()[1]['payload']["buttons"];
           BotButtons chatButtons=new BotButtons(buttons,_handleSubmitted);
           _messages.insert(0,chatButtons);
          }
        BotTextMessage message = new BotTextMessage(
            text: response.getMessage() ,
            name: "Bot",
            timeofday: dateFormat
           );
            _messages.insert(1, message);

      }
    else if(response.queryResult.intent.displayName.compareTo("Who is Billy?")==0)
      {
         List<dynamic> buttons=response.getListMessage()[2]['payload']["buttons"];
           BotButtons chatButtons=new BotButtons(buttons,_handleSubmitted);
           _messages.insert(0,chatButtons);
          BotTextMessage message2 = new BotTextMessage(
            text: response.getListMessage()[1]['text']['text'][0] ,
            name: "Bot",
            timeofday: dateFormat
           );
            _messages.insert(1,message2);
            String url=response.getListMessage()[2]['payload']['images'][0];
            BotImageMessage imageMessage=new BotImageMessage(url:url);
            _messages.insert(2, imageMessage);
          BotTextMessage message = new BotTextMessage(
            text: response.getListMessage()[0]['text']['text'][0] ,
            name: "Bot",
            timeofday: dateFormat
           );
            _messages.insert(3,message);

      }
    else
      {
         BotTextMessage message = new BotTextMessage(
            text: response.getMessage() ,
            name: "Bot",
            timeofday: dateFormat
           );
         _messages.insert(0,message);
      }
    setState(() {
      _messages;
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('E hh:mm').format(date);
    UserTextMessage message = new UserTextMessage(
      message: text,
      timeofday:dateFormat
    );
    if(_messages[0] is BotButtons)
      {
        _messages.removeAt(0);
      }
    setState(() {
      _messages.insert(0,message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          centerTitle: false,
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                "BILLY",style: TextStyle(color: Colors.white, fontSize: 16.0,fontStyle: FontStyle.normal),
              ),
              Text('Yellow Messenger Assistant',style: TextStyle(color: Colors.white, fontSize: 14.0,fontStyle: FontStyle.normal)),
            ]),
          leading: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(radius: 25,backgroundImage: AssetImage('assets/bot.png'),
            ),
          ),
        ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (context, index) {
            if(_messages[index].buildBotButtonMessge(context)!=null)
              {
                return _messages[index].buildBotButtonMessge(context);
              }
            else if(_messages[index].buildBotImageMessge(context)!=null){
               return _messages[index].buildBotImageMessge(context);
            }
            else if(_messages[index].buildBotTextMessge(context)!=null){
               return _messages[index].buildBotTextMessge(context);
            }
            else {
                return _messages[index].buildUsrTextMessge(context);
            }
          },
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}
