import 'dart:convert';
import 'package:gp_app/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/screens/doctor_model_screen.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart'
    as langdetect; // recommend to import 'as langdetect' because this package shows a simple function name 'detect'

class DoctorMessagesWidget extends StatelessWidget {
  const DoctorMessagesWidget({
    Key? key,
    required this.doctorMessage,
    required this.addMessage,
  }) : super(key: key);

  final ChatMessage doctorMessage;
  final Function(String, int) addMessage;

  @override
  Widget build(BuildContext context) {
    bool isDoctor = doctorMessage.senderId == 3;
    bool btn_tap = false; // Add this flag to track navigation

    // Function to detect if the given text is English
    Future<bool> isEnglish(String text) async {
      await langdetect
          .initLangDetect(); // This is needed once in your application after ensureInitialized()

      final language = langdetect.detect(text);
      print('Detected language: $language'); // -> "en"

      final probs = langdetect.detectLangs(text);
      for (final p in probs) {
        print("Language: ${p.lang}"); // -> "en"
        print("Probability: ${p.prob}"); // -> 0.9999964132193504
      }

      if (language == 'en') {
        return true;
      } else {
        return false;
      }
    }

    Future<void> confirmButton(
        BuildContext context, ChatMessage doctorMessage) async {
      print('Confirm Button');

      int patientID = await SessionManager.getScreenIndex() ?? 0;
      print("Patient ID Associated With the pressed thread");

      int burnId = int.parse(await SessionManager.getBurnId() ?? '0');
      print("Burn ID Associated with that index tapped");

      String text = doctorMessage.message;
      bool isEnglishText = await isEnglish(text);
      String reply = '';

      if (isEnglishText) {
        print("The patient wants English language.");
        reply = "The Degree of Burn Was Confirmed By the Doctor.";
      } else {
        print("The patient wants Arabic language");
        reply = "الدكتور أكد درجة الحرق.";
      }

      String dr_msg = S.of(context).doctorTapButton;

      final message_patient = ChatMessage(
          message: reply,
          receiver: true,
          show_btn: false,
          image: null,
          timestamp: DateTime.now(),
          senderId: 3,
          receiverId: patientID,
          imgFlag: 0,
          burnId: burnId);

      // Update the widget with the new message
      addMessage(dr_msg, 1);
      // Send the message to the server
      sendMessageToServer(message_patient);
    }

    Future<void> editButton(
        BuildContext context, ChatMessage doctorMessage) async {
      print('Reject Button');

      int patientID = await SessionManager.getScreenIndex() ?? 0;
      print("Patient ID Associated With the pressed thread");

      int burnId = int.parse(await SessionManager.getBurnId() ?? '0');
      print("Burn ID Associated with that index tapped");

      String text = doctorMessage.message;
      bool isEnglishText = await isEnglish(text);
      String reply = '';

      if (isEnglishText) {
        print("The patient wants English language.");
        reply =
            "The Degree of Burn Was Rejected By the Doctor, Please wait for additional information about your condition";
      } else {
        print("The patient wants Arabic language");
        reply =
            "الدكتور رفض اقتراح الحرق ،ممكن تستني معلومات أكتر عن حالتك منه.";
      }

      String dr_msg = S.of(context).doctorTapButton;

      final message_patient = ChatMessage(
          message: reply,
          receiver: true,
          show_btn: false,
          image: null,
          timestamp: DateTime.now(),
          senderId: 3,
          receiverId: patientID,
          imgFlag: 0,
          burnId: burnId);

      // Send the message of the dr to the server
      addMessage(dr_msg, 1);
      // Send the message of the patient to the server
      sendMessageToServer(message_patient);
    }

    return Align(
      alignment: doctorMessage.receiver ?? false
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          children: [
            if (doctorMessage.image != null)
              Align(
                alignment: Alignment.topRight,
                child: Image.memory(
                  base64Decode(doctorMessage.image!),
                  fit: BoxFit.fill,
                ),

                // (doctorMessage.receiver == false)
                //     ? Image.asset(
                //         doctorMessage.image!,
                //       )
                //     : null,
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
                          : Color.fromARGB(255, 243, 240, 240)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (doctorMessage.show_btn ==
                              true), // (doctorMessage.receiver == false),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                            child: (doctorMessage.receiver == false
                                ? Image.asset(
                                    'assets/images/Hilal.png',
                                    width: 40,
                                    height: 40,
                                  )
                                : null),
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
                      if (!btn_tap) {
                        await confirmButton(context, doctorMessage);
                      }
                      btn_tap = true;
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: const Size(110, 43),
                        backgroundColor: Color.fromARGB(255, 3, 206, 164)),
                    child: Text(
                      S.of(context).confirm,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 251, 251),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!btn_tap) {
                        await editButton(context, doctorMessage);
                      }
                      btn_tap = true;
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

//     return Align(
//       alignment: doctorMessage.receiver ?? false
//           ? Alignment.topRight
//           : Alignment.topLeft,
//       child: Container(
//         padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           mainAxisAlignment: (doctorMessage.receiver == false)
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: ((doctorMessage.receiver == false)
//                       ? Theme.of(context).colorScheme.surface
//                       : const Color.fromARGB(255, 106, 105, 105)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (isDoctor)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Image.asset(
//                           'assets/images/Hilal.png',
//                           width: 40,
//                           height: 40,
//                         ),
//                       ),
//                     if (doctorMessage.image != null)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Image.memory(
//                           base64Decode(doctorMessage.image!),
//                           width: 200,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     if (doctorMessage.message != null)
//                       Text(
//                         doctorMessage.message!,
//                         style: TextStyle(
//                           color: isDoctor
//                               ? const Color.fromARGB(255, 233, 229, 229)
//                               : Colors.white,
//                         ),
//                       ),
//                     if (isDoctor)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () async {
//                                 if (!btn_tap) {
//                                   await confirmButton(context, doctorMessage);
//                                 }
//                                 btn_tap = true;
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 fixedSize: const Size(110, 43),
//                                 backgroundColor:
//                                     Color.fromARGB(255, 3, 206, 164),
//                               ),
//                               child: Text(
//                                 S.of(context).confirm,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Color.fromARGB(255, 255, 251, 251),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             ElevatedButton(
//                               onPressed: () async {
//                                 if (!btn_tap) {
//                                   await editButton(context, doctorMessage);
//                                 }
//                                 btn_tap = true;
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 fixedSize: const Size(105, 43),
//                                 backgroundColor:
//                                     Color.fromARGB(255, 255, 115, 115),
//                               ),
//                               child: Text(
//                                 S.of(context).edit,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   color: Color.fromARGB(255, 255, 251, 251),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








