
import 'package:firebase_database/firebase_database.dart';
import 'package:billy_chatbot/Messages_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';


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
  List<Widget> _messages = <Widget>[];
  final TextEditingController _textController = new TextEditingController();
  int count=0;
  var dbRef;
  MessagesTypes messagesTypes=MessagesTypes();
  @override
  void initState() {
    super.initState();
    _getId().then((value) {
       dbRef=FirebaseDatabase.instance.reference().child(value);
       List<dynamic> messagelist=<dynamic>[];
       dbRef.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> messages = snapshot.value;
          if(messages!=null)
            {
              messages.forEach((key,values) {
                messagelist.add(values);
                if (values["messageno"] > count) {
                  count = values["messageno"];
                }
              });
              messagelist.sort(( a,b){
                if(a["messageno"]>b["messageno"])
                  {
                    return 1;
                  }
                else
                  {
                    return -1;
                  }
              });
              debugPrint(count.toString());
              messagelist.forEach((message) {

                  debugPrint(message["messageno"].toString());
                  if(message["type"].toString().compareTo("usertextmessage")==0)
                  {
                    Widget usermessage=messagesTypes.buildUsrTextMessge(context, message["text"], message["timeofday"]);
                    _messages.add(usermessage);
                  }
                  else if(message["type"].toString().compareTo("bottextmessage")==0)
                  {
                    Widget botmessage=messagesTypes.buildBotTextMessge(context, message["text"], message["timeofday"]);
                    _messages.add(botmessage);
                  }
                  else if(message["type"].toString().compareTo("botimagemessage")==0)
                  {
                    Widget imagemessage=messagesTypes.buildBotImageMessge(context, message["url"]);
                    _messages.add(imagemessage);
                  }
                  else if(message["type"].toString().compareTo("linkcardmessage")==0)
                  {
                    Widget linkCardMessage=messagesTypes.buildBotLinkCard(context, message["title"], message["timeofday"], message["linkheading"], message["url"]);
                    _messages.add(linkCardMessage);
                  }
              });
             setState(() {
               _messages=new List.from(_messages.reversed);
             });
           }
          else
            {
              Response("Hi");
            }
       });
    });
//
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
    debugPrint(response.queryResult.intent.displayName.toString());
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('E hh:mm').format(date);
    if(response.queryResult.intent.displayName.compareTo("Welcome")==0)
      {
         if(response.getListMessage()[1]['payload']["buttons"]!=null){
           List<dynamic> buttons=response.getListMessage()[1]['payload']["buttons"];
           Widget chatButtons=messagesTypes.buildBotButtonMessge(context, buttons,_handleSubmitted);
           _messages.insert(0,chatButtons);
          }
          Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getMessage(), dateFormat);
            _messages.insert(1, botmessage);
            pushtextmessagetodatabase(response.getMessage(), dateFormat, "bottextmessage");

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
            pushtextmessagetodatabase(response.getListMessage()[0]['text']['text'][0], dateFormat, "bottextmessage");
            pushimagemessagetodatabse(url);
            pushtextmessagetodatabase(response.getListMessage()[1]['text']['text'][0], dateFormat, "bottextmessage");

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
             pushimagemessagetodatabse(url);
             pushlinkmessagetodatabse(response.getListMessage()[1]['payload']['LinkCard']['title'], dateFormat, response.getListMessage()[1]['payload']['LinkCard']['linkheading'], response.getListMessage()[1]['payload']['LinkCard']['url']);

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
        pushtextmessagetodatabase(response.getListMessage()[0]['text']['text'][0], dateFormat, "bottextmessage");
        pushimagemessagetodatabse(url);
        pushtextmessagetodatabase(response.getListMessage()[2]['text']['text'][0], dateFormat, "bottextmessage");
         pushtextmessagetodatabase(response.getListMessage()[3]['text']['text'][0], dateFormat, "bottextmessage");
      }
    else if(response.queryResult.intent.displayName.compareTo("response_intrested")==0)
      {
        Widget botmessage=messagesTypes.buildBotTextMessge(context, response.getListMessage()[1]['text']['text'][0], dateFormat);
        _messages.insert(0,botmessage);
        Widget botmessage2=messagesTypes.buildBotTextMessge(context, response.getListMessage()[0]['text']['text'][0], dateFormat);
        _messages.insert(1,botmessage2);
        pushtextmessagetodatabase(response.getListMessage()[0]['text']['text'][0], dateFormat, "bottextmessage");
         pushtextmessagetodatabase(response.getListMessage()[1]['text']['text'][0], dateFormat, "bottextmessage");
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
        pushtextmessagetodatabase(response.getListMessage()[0]['text']['text'][0], dateFormat, "bottextmessage");
         pushtextmessagetodatabase(response.getListMessage()[1]['text']['text'][0], dateFormat, "bottextmessage");
          pushimagemessagetodatabse(url);
      }
    else if(response.queryResult.intent.displayName.compareTo("get_posts")==0)
    {
       debugPrint(response.getListMessage().toString());
       Widget postmessage=messagesTypes.buildPostsMessage(context, response.getListMessage()[0]["text"]['text']);
       _messages.insert(0, postmessage);
    }
    setState(() {
      _messages;
    });
  }
  void pushtextmessagetodatabase(String message,String timeofday,String type)
  {
    dbRef.push().set({
    "text": message,
    "timeofday": timeofday,
    "type": type,
      "messageno":++count,
     }).catchError((onError) {
         debugPrint(onError.toString());
     });
  }
  void pushimagemessagetodatabse(String url)
  {
    dbRef.push().set({
      "url":url,
      "type":"botimagemessage",
       "messageno":++count,
     }).catchError((onError) {
         debugPrint(onError.toString());
     });
  }
  void pushlinkmessagetodatabse(String title,String timeofday,String linkheading,String linkurl)
  {
    dbRef.push().set({
    "title": title,
    "timeofday": timeofday,
    "linkheading": linkheading,
      "url":linkurl,
      "type":"linkcardmessage",
       "messageno":++count,
     }).catchError((onError) {
         debugPrint(onError.toString());
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
    pushtextmessagetodatabase(text, dateFormat, "usertextmessage");
    Response(text);
  }
  Future<String> _getId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.androidId}');
  return androidInfo.androidId;
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
