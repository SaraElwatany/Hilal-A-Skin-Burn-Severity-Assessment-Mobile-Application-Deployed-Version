import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/Data/messages.dart';
import 'package:gp_app/models/chat_message.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: chatMessage.reciever
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: chatMessage.reciever
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              // constraints: BoxConstraints(
              //   maxWidth: MediaQuery.of(context).size.width * 0.7,
              // ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (!chatMessage.reciever
                    ? Theme.of(context).colorScheme.surface
                    : const Color.fromARGB(255, 106, 105, 105)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: !chatMessage.reciever,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                      child: (!chatMessage.reciever
                          ? Image.asset(
                              'assets/images/Hilal.png',
                              width: 40, // Adjust the width as needed
                              height: 40, // Adjust the height as needed
                            )
                          : null),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                      Text(
                        chatMessage.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                //   ),
                // ],
              ),
            ),
            // Visibility(
            //   visible: chatMessage.reciever,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 8.0),
            //     child: 
            //     CircleAvatar(
            //       radius: 20,
            //       backgroundImage: chatMessage.reciever
            //           ? const AssetImage('assets/images/Hilal.png')
            //           : null,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
