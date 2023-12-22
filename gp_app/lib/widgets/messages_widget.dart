
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/Data/messages.dart';
import 'package:gp_app/models/chat_message.dart';

class MessagesWidget extends StatelessWidget{
  const MessagesWidget({
    super.key,
    required this.chatMessage
  });
    final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {


    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Align(
          alignment: (!chatMessage.reciever? Alignment.topLeft : Alignment.topRight),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (!chatMessage.reciever? Theme.of(context).colorScheme.surface:const Color.fromARGB(255, 106, 105, 105)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chatMessage.message,
                style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          
          ),
          


    );
  }
}