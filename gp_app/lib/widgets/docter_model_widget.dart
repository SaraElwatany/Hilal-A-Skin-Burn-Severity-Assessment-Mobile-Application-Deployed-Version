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
    return Align(
      alignment: doctorMessage.receiver ?? false
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          children: [
            // Display image if available
            if (doctorMessage.image != null && doctorMessage.image!.isNotEmpty)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(
                      base64Decode(doctorMessage.image!),
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
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
                        // Display image if available
                        if (doctorMessage.image != null &&
                            doctorMessage.image!.isNotEmpty)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  base64Decode(doctorMessage.image!),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: (doctorMessage.receiver == false),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print('Confirm Button');

                      int patientID =
                          await SessionManager.getScreenIndex() ?? 0;
                      print("Patient ID Associated With the pressed thread");

                      String reply =
                          "The Degree of Burn Was Confirmed By the Doctor";

                      final message = ChatMessage(
                          message: reply,
                          receiver: true,
                          image: null,
                          timestamp: DateTime.now(),
                          senderId: 1,
                          receiverId: patientID);

                      // Send the message to the server
                      sendMessageToServer(message);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: const Size(105, 43),
                        backgroundColor: Color.fromARGB(255, 3, 206, 164)),
                    child: Text(
                      S.of(context).confirm,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 255, 251, 251),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print('Reject Button');

                      int patientID =
                          await SessionManager.getScreenIndex() ?? 0;
                      print("Patient ID Associated With the pressed thread");

                      String reply =
                          "The Degree of Burn Was Rejected By the Doctor, Please wait for additional information about your condition";
                      final message = ChatMessage(
                          message: reply,
                          receiver: true,
                          image: null,
                          timestamp: DateTime.now(),
                          senderId: 1,
                          receiverId: patientID);

                      // Send the message to the server
                      sendMessageToServer(message);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: const Size(105, 43),
                        backgroundColor: Color.fromARGB(255, 255, 115, 115)),
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
            )
          ],
        ),
      ),
    );
  }
}
