import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/screens/HospitalLocationScreen.dart';
import 'package:gp_app/models/voice_note_model.dart';
import 'package:gp_app/widgets/voice_note_card.dart';

class MessagesWidget extends StatelessWidget {
  MessagesWidget({
    Key? key,
    required this.chatMessage,
    required this.introMessage,
    this.isIntro =
        true, // Add a parameter to check if the message is the intro message
  }) : super(key: key);

  final ChatMessage chatMessage;
  final String? introMessage;
  final bool isIntro;

  // // Helper function to decode base64 string to Uint8List
  // Uint8List _decodeBase64ToImage(String base64String) {
  //   return Uint8List.fromList(base64.decode(base64String));
  // }

  get context => null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 16), // Adjust as per your requirement
      child: Align(
        alignment: chatMessage.receiver == true
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: chatMessage.receiver == true
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: chatMessage.receiver == false
                        ? Theme.of(context).colorScheme.surface
                        : const Color.fromARGB(255, 106, 105, 105),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display image if available
                      if (chatMessage.image != null &&
                          chatMessage.image!.isNotEmpty)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(
                                base64Decode(chatMessage
                                    .image!), //  base64Decode(chatMessage.image!)
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),
                      // VoiceNoteCard(voiceNoteInfo: voiceNoteInfo),

                      // Display text message
                      _buildMessageContent(context, chatMessage),
                      if (chatMessage.voiceNote != null)
                        VoiceNoteCard(
                          voiceNoteInfo: VoiceNoteModel(
                            name:
                                'Voice Note', // Provide a name for the voice note
                            createAt:
                                DateTime.now(), // Timestamp for voice note
                            path: chatMessage.voiceNote!, // Voice note path
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Related to Location Clickable Links
  Widget _buildMessageContent(BuildContext context, ChatMessage chatMessage) {
    final linkRegExp = RegExp(r'\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)');
    final matches = linkRegExp.allMatches(chatMessage.message);

    List<TextSpan> textSpans = [];
    int start = 0;

    for (Match match in matches) {
      final linkText = match.group(1)!;
      final url = match.group(2)!;

      if (match.start > start) {
        textSpans.add(TextSpan(
          text: chatMessage.message.substring(start, match.start),
          style: const TextStyle(color: Colors.white),
        ));
      }

      // Extract latitude and longitude from the URL
      final uri = Uri.parse(url);
      final lat = uri.queryParameters['lat'];
      final lon = uri.queryParameters['lon'];
      final key = '$lat,$lon';

      String hospitalNameEn = '';
      String hospitalNameAr = '';

      if (chatMessage.hospitalDetails != null) {
        for (var detail in chatMessage.hospitalDetails!) {
          if (detail.containsKey(key)) {
            var names = detail[key]!.split(' - ');
            hospitalNameEn = names[0];
            hospitalNameAr = names[1];
            break;
          }
        }
      }

      textSpans.add(TextSpan(
        text: linkText,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HospitalLocationScreen(
                  latitude: double.parse(lat!),
                  longitude: double.parse(lon!),
                  hospitalNameEn: hospitalNameEn,
                  hospitalNameAr: hospitalNameAr,
                ),
              ),
            );
          },
      ));

      start = match.end;
    }

    if (start < chatMessage.message.length) {
      textSpans.add(TextSpan(
        text: chatMessage.message.substring(start),
        style: const TextStyle(color: Colors.white),
      ));
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
