import 'dart:convert';
import 'package:gp_app/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/chat_message.dart';

class DoctorMessagesWidget extends StatelessWidget {
  const DoctorMessagesWidget({
    Key? key,
    required this.doctorMessage,
  }) : super(key: key);

  final ChatMessage doctorMessage;

  @override
  Widget build(BuildContext context) {
    bool isDoctor = doctorMessage.senderId == 3;

    return Align(
      alignment: doctorMessage.receiver ?? false
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: (doctorMessage.receiver == false)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ((doctorMessage.receiver == false)
                      ? Theme.of(context).colorScheme.surface
                      : const Color.fromARGB(255, 106, 105, 105)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDoctor)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          'assets/images/Hilal.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    if (doctorMessage.image != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.memory(
                          base64Decode(doctorMessage.image!),
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (doctorMessage.message != null)
                      Text(
                        doctorMessage.message!,
                        style: TextStyle(
                          color: isDoctor
                              ? const Color.fromARGB(255, 233, 229, 229)
                              : Colors.white,
                        ),
                      ),
                    if (isDoctor)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                print('Confirm Button');

                                int patientID =
                                    await SessionManager.getScreenIndex() ?? 0;
                                print(
                                    "Patient ID Associated With the pressed thread");

                                int burnId = int.parse(
                                    await SessionManager.getBurnId() ?? '0');
                                print(
                                    "Burn ID Associated with that index tapped");

                                String reply =
                                    "The Degree of Burn Was Confirmed By the Doctor";

                                final message = ChatMessage(
                                    message: reply,
                                    receiver: true,
                                    image: null,
                                    timestamp: DateTime.now(),
                                    senderId: 3,
                                    receiverId: patientID,
                                    imgFlag: 0,
                                    burnId: burnId);

                                // Send the message to the server
                                sendMessageToServer(message);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fixedSize: const Size(110, 43),
                                backgroundColor:
                                    Color.fromARGB(255, 3, 206, 164),
                              ),
                              child: Text(
                                S.of(context).confirm,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 251, 251),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () async {
                                print('Reject Button');

                                int patientID =
                                    await SessionManager.getScreenIndex() ?? 0;
                                print(
                                    "Patient ID Associated With the pressed thread");

                                int burnId = int.parse(
                                    await SessionManager.getBurnId() ?? '0');
                                print(
                                    "Burn ID Associated with that index tapped");

                                String reply =
                                    "The Degree of Burn Was Rejected By the Doctor, Please wait for additional information about your condition";
                                final message = ChatMessage(
                                    message: reply,
                                    receiver: true,
                                    image: null,
                                    timestamp: DateTime.now(),
                                    senderId: 3,
                                    receiverId: patientID,
                                    imgFlag: 0,
                                    burnId: burnId);

                                // Send the message to the server
                                sendMessageToServer(message);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fixedSize: const Size(105, 43),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 115, 115),
                              ),
                              child: Text(
                                S.of(context).edit,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 255, 251, 251),
                                ),
                              ),
                            ),
                          ],
                        ),
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







// import 'dart:convert';
// import 'package:gp_app/apis/apis.dart';
// import 'package:flutter/material.dart';
// import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/models/chat_message.dart';

// class DoctorMessagesWidget extends StatelessWidget {
//   const DoctorMessagesWidget({
//     Key? key,
//     required this.doctorMessage,
//   }) : super(key: key);

//   final ChatMessage doctorMessage;

//   @override
//   Widget build(BuildContext context) {
//     bool isDoctor = doctorMessage.senderId == 3;

//     return Align(
//       alignment: doctorMessage.receiver ?? false
//           ? Alignment.topRight
//           : Alignment.topLeft,
//       child: Container(
//         padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: (doctorMessage.receiver == false)
//                   ? MainAxisAlignment.end
//                   : MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: ((doctorMessage.receiver == false)
//                           ? Theme.of(context).colorScheme.surface
//                           : const Color.fromARGB(255, 106, 105, 105)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (isDoctor)
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: Image.asset(
//                               'assets/images/Hilal.png',
//                               width: 40,
//                               height: 40,
//                             ),
//                           ),
//                         if (doctorMessage.image != null)
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: Image.memory(
//                               base64Decode(doctorMessage.image!),
//                               width: 200, // Adjust as needed
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         if (doctorMessage.message != null)
//                           Text(
//                             doctorMessage.message!,
//                             style: TextStyle(
//                               color: isDoctor
//                                   ? const Color.fromARGB(255, 233, 229, 229)
//                                   : Colors.white,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             if (isDoctor)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       print('Confirm Button');

//                       int patientID =
//                           await SessionManager.getScreenIndex() ?? 0;
//                       print("Patient ID Associated With the pressed thread");

//                       int burnId =
//                           int.parse(await SessionManager.getBurnId() ?? '0');
//                       print("Burn ID Associated with that index tapped");

//                       String reply =
//                           "The Degree of Burn Was Confirmed By the Doctor";

//                       final message = ChatMessage(
//                           message: reply,
//                           receiver: true,
//                           image: null,
//                           timestamp: DateTime.now(),
//                           senderId: 1,
//                           receiverId: patientID,
//                           imgFlag: 0,
//                           burnId: burnId);

//                       // Send the message to the server
//                       sendMessageToServer(message);
//                     },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                         fixedSize: const Size(110, 43),
//                         backgroundColor: Color.fromARGB(255, 3, 206, 164)),
//                     child: Text(
//                       S.of(context).confirm,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Color.fromARGB(255, 255, 251, 251),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       print('Reject Button');

//                       int patientID =
//                           await SessionManager.getScreenIndex() ?? 0;
//                       print("Patient ID Associated With the pressed thread");

//                       int burnId =
//                           int.parse(await SessionManager.getBurnId() ?? '0');
//                       print("Burn ID Associated with that index tapped");

//                       String reply =
//                           "The Degree of Burn Was Rejected By the Doctor, Please wait for additional information about your condition";
//                       final message = ChatMessage(
//                           message: reply,
//                           receiver: true,
//                           image: null,
//                           timestamp: DateTime.now(),
//                           senderId: 1,
//                           receiverId: patientID,
//                           imgFlag: 0,
//                           burnId: burnId);

//                       // Send the message to the server
//                       sendMessageToServer(message);
//                     },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                         fixedSize: const Size(105, 43),
//                         backgroundColor: Color.fromARGB(255, 255, 115, 115)),
//                     child: Text(
//                       S.of(context).edit,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         color: Color.fromARGB(255, 255, 251, 251),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
