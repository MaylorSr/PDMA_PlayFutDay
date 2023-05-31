import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';

class CardMessageScreen extends StatelessWidget {
  const CardMessageScreen({Key? key, required this.message}) : super(key: key);

  final Message message;
  @override
  Widget build(BuildContext context) {
    //  return ChatBubble(
    //   clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
    //   alignment: Alignment.topRight,
    //   margin: EdgeInsets.only(top: 20),
    //   backGroundColor: Colors.blue,
    //   child: Container(
    //     constraints: BoxConstraints(
    //       maxWidth: MediaQuery.of(context).size.width * 0.7,
    //     ),
    //     child: Text(
    //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    // );
    return Card(
      color: Colors.amber,
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          // ""${message.bodyMessage}","
          "",
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
