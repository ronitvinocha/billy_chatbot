

import 'package:billy_chatbot/Messages_types.dart';
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
  final List<Widget> _messages = <Widget>[];
  final TextEditingController _textController = new TextEditingController();
  MessagesTypes messagesTypes=MessagesTypes();
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
                onSubmitted: handlesubmit,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text,false)),
            ),
          ],
        ),
      ),
    );
  }
  void handlesubmit(String text)
  {
    _handleSubmitted(text, false);
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
//           BotButtons chatButtons=new BotButtons(buttons,_handleSubmitted);
           Widget chatButtons=messagesTypes.buildBotButtonMessge(context, buttons,_handleSubmitted);
           _messages.insert(0,chatButtons);
          }
          Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getMessage(), dateFormat);
            _messages.insert(1, botmessage);

      }
    else if(response.queryResult.intent.displayName.compareTo("Who is Billy?")==0)
      {
         List<dynamic> buttons=response.getListMessage()[2]['payload']["buttons"];
          Widget chatButtons=messagesTypes.buildBotButtonMessge(context, buttons,_handleSubmitted);
           _messages.insert(0,chatButtons);
           Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getListMessage()[1]['text']['text'][0], dateFormat);
            _messages.insert(1,botmessage);
            String url=response.getListMessage()[2]['payload']['images'][0];
           Widget imagemessage=messagesTypes.buildBotImageMessge(context, url);
            _messages.insert(2, imagemessage);
           Widget botmessage2=messagesTypes.buildBotTextMessge(context, response.getListMessage()[0]['text']['text'][0], dateFormat);
            _messages.insert(3,botmessage2);

      }
    else if(response.queryResult.intent.displayName.compareTo("response_maybe")==0)
      {
        debugPrint(response.getListMessage().toString());
        List<dynamic> buttons=response.getListMessage()[1]['payload']["buttons"];
            Widget botbuttons=messagesTypes.buildBotButtonMessge(context, buttons, _handleSubmitted);
            _messages.insert(0, botbuttons);
        String url=response.getListMessage()[1]['payload']['images'][0];
        Widget linkcardmessage=messagesTypes.buildBotLinkCard(context, response.getListMessage()[1]['payload']['LinkCard']['title'], dateFormat, response.getListMessage()[1]['payload']['LinkCard']['linkheading'], response.getListMessage()[1]['payload']['LinkCard']['url']);
        _messages.insert(1, linkcardmessage);
        Widget imagemessage=messagesTypes.buildBotImageMessge(context, url);
            _messages.insert(2, imagemessage);
      }
    else if(response.queryResult.intent.displayName.compareTo("response_yes")==0)
      {
        List<dynamic> buttons=response.getListMessage()[1]['payload']["buttons"];
        Widget botbuttons=messagesTypes.buildBotButtonMessge(context, buttons, _handleSubmitted);
        _messages.insert(0, botbuttons);
        Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getListMessage()[3]['text']['text'][0], dateFormat);
        _messages.insert(1,botmessage);
        Widget botmessage2=messagesTypes.buildBotTextMessge(context, response.getListMessage()[2]['text']['text'][0], dateFormat);
        _messages.insert(2,botmessage2);
         String url=response.getListMessage()[1]['payload']['images'][0];
        Widget imagemessage=messagesTypes.buildBotImageMessge(context, url);
            _messages.insert(3, imagemessage);
        Widget botmessage3=messagesTypes.buildBotTextMessge(context, response.getListMessage()[0]['text']['text'][0], dateFormat);
        _messages.insert(4,botmessage3);
      }
    else if(response.queryResult.intent.displayName.compareTo("response_intrested")==0)
      {
        Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getListMessage()[1]['text']['text'][0], dateFormat);
        _messages.insert(0,botmessage);
        Widget botmessage2=messagesTypes.buildBotTextMessge(context, response.getListMessage()[0]['text']['text'][0], dateFormat);
        _messages.insert(1,botmessage2);
      }
    else if(response.queryResult.intent.displayName.compareTo("response_intrested_yes")==0)
      {
         String url=response.getListMessage()[2]['payload']['images'][0];
        Widget imagemessage=messagesTypes.buildBotImageMessge(context, url);
            _messages.insert(0, imagemessage);
        Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getListMessage()[1]['text']['text'][0], dateFormat);
        _messages.insert(1,botmessage);
        Widget botmessage2=messagesTypes.buildBotTextMessge(context, response.getListMessage()[0]['text']['text'][0], dateFormat);
        _messages.insert(2,botmessage2);

      }
    else
      {
          Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getMessage(), dateFormat);
         _messages.insert(0,botmessage);
      }
    setState(() {
      _messages;
    });
  }

  void _handleSubmitted(String text ,bool removelastitem) {
    _textController.clear();
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('E hh:mm').format(date);
    Widget usermessage=messagesTypes.buildUsrTextMessge(context, text, dateFormat);
    if(removelastitem)
      {
        _messages.removeAt(0);
      }
    setState(() {
      _messages.insert(0,usermessage);
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
            return _messages[index];
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
