// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:gp_app/Data/messages.dart';
// import 'package:gp_app/models/chat_message.dart';

// class MessagesWidget extends StatelessWidget {
//   const MessagesWidget({
//     Key? key,
//     required this.chatMessage,
//     required this.showImage,
//   }) : super(key: key);

//   final ChatMessage chatMessage;
//     final bool showImage;


//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: chatMessage.receiver ? Alignment.topRight : Alignment.topLeft,
//       child: Container(
//         padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           mainAxisAlignment: chatMessage.receiver
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           children: [
//             Container(
//               // constraints: BoxConstraints(
//               //   maxWidth: MediaQuery.of(context).size.width * 0.7,
//               // ),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: (!chatMessage.receiver
//                     ? Theme.of(context).colorScheme.surface
//                     : const Color.fromARGB(255, 106, 105, 105)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Visibility(
//                     visible: !chatMessage.receiver,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 4.0, left: 4.0),
//                       child: (!chatMessage.receiver
//                           ? Image.asset(
//                               'assets/images/Hilal.png',
//                               width: 40, // Adjust the width as needed
//                               height: 40, // Adjust the height as needed
//                             )
//                           : null),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Column(
//                   //   crossAxisAlignment: CrossAxisAlignment.start,
//                   //   children: [
//                   Text(
//                     chatMessage.message,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//                 //   ),
//                 // ],
//               ),
//             ),
//             // Visibility(
//             //   visible: chatMessage.reciever,
//             //   child: Padding(
//             //     padding: const EdgeInsets.only(left: 8.0),
//             //     child:
//             //     CircleAvatar(
//             //       radius: 20,
//             //       backgroundImage: chatMessage.reciever
//             //           ? const AssetImage('assets/images/Hilal.png')
//             //           : null,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:gp_app/models/chat_message.dart';

// class MessagesWidget extends StatelessWidget {
//   const MessagesWidget({
//     Key? key,
//     required this.chatMessage,
//     this.showImage = false,
//   }) : super(key: key);

//   final ChatMessage chatMessage;
//   final bool showImage;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: chatMessage.receiver ? Alignment.topRight : Alignment.topLeft,
//       child: Container(
//         padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           mainAxisAlignment: chatMessage.receiver
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: (!chatMessage.receiver
//                     ? Theme.of(context).colorScheme.surface
//                     : const Color.fromARGB(255, 106, 105, 105)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (showImage) ...[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0, left: 4.0),
//                       child: Image.asset(
//                         'assets/images/Hilal.png',
//                         width: 40,
//                         height: 40,
//                       ),
//                     ),
//                   ],
//                   const SizedBox(width: 8),
//                   Text(
//                     chatMessage.message,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/chat_message.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({
    Key? key,
    required this.chatMessage,
    required this.introMessage,
  }) : super(key: key);

  final ChatMessage chatMessage;
  final String? introMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: chatMessage.receiver ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: chatMessage.receiver
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (!chatMessage.receiver
                      ? Theme.of(context).colorScheme.surface
                      : const Color.fromARGB(255, 106, 105, 105)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !chatMessage.receiver,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                        child: (!chatMessage.receiver
                            ? Image.asset(
                                'assets/images/Hilal.png',
                                width: 40, 
                                height: 40, 
                              )
                            : null),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      introMessage ?? chatMessage.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

