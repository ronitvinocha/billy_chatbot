import 'package:flutter/material.dart';
abstract class ListItem{
  Widget buildUsrTextMessge(BuildContext context);
  Widget buildBotTextMessge(BuildContext context);
  Widget buildBotImageMessge(BuildContext context);
  Widget buildBotButtonMessge(BuildContext context);
  Widget buildBotLinkMessage(BuildContext context);
}
class BotButtons implements ListItem{
  List<dynamic> buttonstext;
   var buttonWidget = List<Widget>();
    BotButtons(buttonstext, void Function(String text) handleSubmitted){
    this.buttonstext=buttonstext;
    for (var buttontext in buttonstext) {
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

  @override
  Widget buildBotLinkMessage(BuildContext context) =>null;

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

  @override
  Widget buildBotLinkMessage(BuildContext context)=>null;

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

  @override
  Widget buildBotLinkMessage(BuildContext context) => null;
}

 class BotImageMessage implements ListItem{
  final String url;
  BotImageMessage({this.url});
  @override
  Widget buildBotButtonMessge(BuildContext context) =>null;

  @override
  Widget buildBotImageMessge(BuildContext context) {
    return new Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(top: 5.0,bottom: 5,left: 50),
    child:Column(children:[Image.network(url)],crossAxisAlignment: CrossAxisAlignment.start));
  }

  @override
  Widget buildBotTextMessge(BuildContext context) => null;

  @override
  Widget buildUsrTextMessge(BuildContext context) => null;

  @override
  Widget buildBotLinkMessage(BuildContext context) => null;
  }

  class BotLinkMessage implements ListItem{
  @override
  Widget buildBotButtonMessge(BuildContext context) => null;

  @override
  Widget buildBotImageMessge(BuildContext context) =>null;

  @override
  Widget buildBotLinkMessage(BuildContext context) => null;

  @override
  Widget buildBotTextMessge(BuildContext context) => null;

  @override
  Widget buildUsrTextMessge(BuildContext context) => null;

  }