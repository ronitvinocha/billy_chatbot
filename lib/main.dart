import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

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
    BotButtons chatButtons;
    debugPrint(response.getMessage());
    if(response.getListMessage().length>1)
      {
        List<dynamic> buttons=response.getListMessage()[1]['payload']["buttons"];
        chatButtons=new BotButtons(buttons,_handleSubmitted);
      }
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('E hh:mm').format(date);
    BotTextMessage message = new BotTextMessage(
      text: response.getMessage() ,
      name: "Bot",
      timeofday: dateFormat
    );
    setState(() {
       if(chatButtons!=null)
        {
          _messages.insert(0, chatButtons);
           _messages.insert(1, message);
        }
        else
          {
             _messages.insert(0, message);
          }

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
    setState(() {
      _messages.insert(0, message);
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
abstract class ListItem{
  Widget buildUsrTextMessge(BuildContext context);
  Widget buildBotTextMessge(BuildContext context);
  Widget buildBotImageMessge(BuildContext context);
  Widget buildBotButtonMessge(BuildContext context);
}
class BotButtons implements ListItem{
  List<dynamic> buttonstext;
   var buttonWidget = List<Widget>();
    BotButtons(buttonstext, void Function(String text) handleSubmitted){
    this.buttonstext=buttonstext;
    for (var buttontext in buttonstext) {
      debugPrint(buttontext.toString());
      buttonWidget.add(new OutlineButton(
      child: new Text(buttontext.toString()),
      onPressed: (){
        handleSubmitted(buttontext.toString());
      },
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
));
    }
  }



  @override
  Widget buildBotButtonMessge(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.only(top: 5.0,bottom: 5,left: 50),
    child:Column(children: buttonWidget,crossAxisAlignment: CrossAxisAlignment.start,));
  }

  @override
  Widget buildBotImageMessge(BuildContext context) =>null;

  @override
  Widget buildBotTextMessge(BuildContext context) =>null;

  @override
  Widget buildUsrTextMessge(BuildContext context)=>null;

}

class UserTextMessage implements ListItem{
  final String message;
  final String timeofday;
  UserTextMessage({this.message,this.timeofday});
  @override
  Widget buildBotButtonMessge(BuildContext context)=>null;

  @override
  Widget buildBotImageMessge(BuildContext context) => null;

  @override
  Widget buildBotTextMessge(BuildContext context) => null;

  @override
  Widget buildUsrTextMessge(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(left: 10,right: 20,top: 10,bottom: 10),
              child: new Text(message,style: TextStyle(color: Colors.white),),
               decoration: BoxDecoration(
                   border: Border.all(color: Colors.blue),
                   borderRadius: BorderRadius.circular(20),
                   color:   Colors.blue
            ),
            ),
            new Container(margin:const EdgeInsets.only(right: 4,top:5),child:Text(timeofday,style: TextStyle(fontSize: 11),))
          ],
        ),
    );
  }

}
class BotTextMessage implements ListItem {
  BotTextMessage({this.text, this.name,this.timeofday});

  final String text;
  final String name;
  final String timeofday;
  
  @override
  Widget buildBotButtonMessge(BuildContext context) =>null;

  @override
  Widget buildBotImageMessge(BuildContext context) =>null;

  @override
  Widget buildBotTextMessge(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(children:[
    new Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: new CircleAvatar(radius: 20,backgroundImage: AssetImage('assets/bot.png'))
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(10),
              child: new Text(text),
               decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey),
                   borderRadius: BorderRadius.circular(10),
                   color: Color.fromRGBO(220, 220, 220, 1)
            ),
            ),
            new Container(margin:const EdgeInsets.only(left: 2,top:5),child:Text(timeofday,style: TextStyle(fontSize: 11),))
          ],
        ),
      ),
    ])
    );
  }

  @override
  Widget buildUsrTextMessge(BuildContext context) =>null;
}