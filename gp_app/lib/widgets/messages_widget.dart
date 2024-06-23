import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/screens/HospitalLocationScreen.dart';

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
      alignment:
          chatMessage.receiver == true ? Alignment.topRight : Alignment.topLeft,
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
                    Visibility(
                      visible: chatMessage.receiver == false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                        child: chatMessage.receiver == false
                            ? Image.asset(
                                'assets/images/Hilal.png',
                                width: 40,
                                height: 40,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMessageContent(context,
                        chatMessage.message), // Call to render message content
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Related to Location Clickable Links
  Widget _buildMessageContent(BuildContext context, String message) {
    final linkRegExp = RegExp(r'\[(.*?)\]\((.*?)\)');

    final matches = linkRegExp.allMatches(message);

    List<TextSpan> textSpans = [];
    int start = 0;

    for (Match match in matches) {
      final linkText = match.group(1)!;
      final url = match.group(2)!;

      if (match.start > start) {
        textSpans.add(TextSpan(
          text: message.substring(start, match.start),
          style: const TextStyle(color: Colors.white),
        ));
      }

      textSpans.add(TextSpan(
        text: linkText,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Pass latitude, longitude, hospitalNameEn, and hospitalNameAr to HospitalLocationScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HospitalLocationScreen(
                  latitude: chatMessage.latitude!,
                  longitude: chatMessage.longitude!,
                  hospitalNameEn: chatMessage.hospitalNameEn!,
                  hospitalNameAr: chatMessage.hospitalNameAr!,
                ),
              ),
            );
          },
      ));

      start = match.end;
    }

    if (start < message.length) {
      textSpans.add(TextSpan(
        text: message.substring(start),
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
