import 'package:flutter/material.dart';

import 'package:bubble/bubble.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/message.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatBotState createState() => new _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff00A699),
        primarySwatch: Colors.blue,
      ),
      home: ChatBotScreen(),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final message = TextEditingController();
  List<Map> messageList = List();

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/amicorp.json").build();
    DialogFlow dialogFlow = DialogFlow(authGoogle: authGoogle, language: "en");
    AIResponse response = await dialogFlow.detectIntent(query);
    setState(() {
      messageList.insert(0, {
        "data": 0,
        "message": response.getMessage() ??
            CardDialogflow(response.getListMessage()[0]).title
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        elevation: 10,
        title: Text("Customer Support"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) => chat(
                        messageList[index]["message"].toString(),
                        messageList[index]["data"]))),
            Divider(
              height: 6.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    controller: message,
                    decoration: InputDecoration.collapsed(
                        hintText: "Send your message",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        )),
                  )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                        onPressed: () {
                          if (message.text.isEmpty) {
                            print("Please enter something..");
                          } else {
                            setState(() {
                              messageList.insert(
                                  0, {"data": 1, "message": message.text});
                              response(message.text);
                              message.clear();
                            });
                          }
                        },
                        icon: Icon(Icons.send)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
        radius: Radius.circular(15.0),
        color: data == 0 ? Color(0xff00A699) : Colors.grey[350],
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(data == 0
                    ? "assets/images/chat/bot.png"
                    : "assets/images/chat/user.png"),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                      color: data == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
