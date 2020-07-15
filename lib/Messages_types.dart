import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class MessagesTypes {

  Widget buildBotButtonMessge(BuildContext context,List<dynamic> buttonstext, void Function(String text,bool removelastitem) handleSubmitted) {
        var buttonWidget = List<Widget>();
        for (var buttontext in buttonstext) {
          buttonWidget.add(
              new OutlineButton(
                  child: new Text(buttontext.toString()),
                  onPressed: () {
                    handleSubmitted(buttontext.toString(),true);
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))));
        }
          debugPrint(buttonWidget.length.toString());
        return new Container(
            margin: const EdgeInsets.only(top: 5.0,bottom: 5,left: 50),
        child:Column(children: buttonWidget,crossAxisAlignment: CrossAxisAlignment.start,));
        }

    Widget buildUsrTextMessge(BuildContext context,String message,String timeofday) {
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

  Widget buildBotImageMessge(BuildContext context,String url) {
    return new Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(top: 5.0,bottom: 5,left: 50),
    child:Column(children:[Image.network(url)],crossAxisAlignment: CrossAxisAlignment.center));

  }


   Widget buildBotTextMessge(BuildContext context,String message,String timeofday) {
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
              child: new Text(message),
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


  Widget buildBotLinkCard(BuildContext context,String title,String timeofday, String linkheading,String linkurl )
  {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(children:[
         new Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: new CircleAvatar(radius: 20,backgroundImage: AssetImage('assets/bot.png'))
      ),
      new Expanded(
        child:new Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [new Container(
            width: 250,
       decoration: BoxDecoration(
                   border: Border.all(color: Colors.grey),
                   borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        child: new Column(children: [
                new Text(title,style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                new Divider(height: 1.0,color: Colors.black12,),
                SizedBox(height: 10,),
                new InkWell(
                     child: new Text(linkheading,textAlign:TextAlign.center,style: TextStyle(color: Colors.blue,fontSize: 18),),
                     onTap: () => launch(linkurl))],

        )
      ),
          new Container(margin:const EdgeInsets.only(left: 2,top:5),child:Text(timeofday,style: TextStyle(fontSize: 11),))
        ],)

    )
    ])
    );
  }

}