import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class Chatbot extends StatefulWidget {
  Chatbot({Key key}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final mensaje = TextEditingController();
  List<Map> historial = List();
  void respuesta(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: 'assets/credential.json').build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.spanish);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      historial.insert(0, {"data": 0, "mensaje": aiResponse.getMessage()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('chatbot'),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  reverse: true,
                  itemCount: historial.length,
                  itemBuilder: (context, index) => chat(
                      historial[index]["mensaje"].toString(),
                      historial[index]["data"]))),
          Divider(
            height: 3.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: mensaje,
                  decoration:
                      InputDecoration.collapsed(hintText: "Escribe tu mensaje"),
                )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.0,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      setState(() {
                        if (mensaje.text.isNotEmpty)
                          historial
                              .insert(0, {"data": 1, "mensaje": mensaje.text});
                      });
                      respuesta(mensaje.text);
                      mensaje.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.deepOrange : Colors.orangeAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
              padding: EdgeInsets.all(2.0),
              child: data == 0 ? msjBot(message) : msjUser(message))),
    );
  }

  Widget msjBot(String message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage("assets/bot.png"),
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
            child: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ))
      ],
    );
  }

  Widget msjUser(String message) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
            child: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        SizedBox(
          width: 10.0,
        ),
        CircleAvatar(
          backgroundImage: AssetImage("assets/user.png"),
        )
      ],
    );
  }
}
