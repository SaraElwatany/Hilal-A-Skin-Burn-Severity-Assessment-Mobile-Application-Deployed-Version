import 'package:flutter/material.dart';
import 'package:gp_app/Data/doctor_msg.dart';
import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/screens/patient_model_screen.dart';
import 'package:gp_app/widgets/docter_model_widget.dart';
import 'package:gp_app/widgets/localization_icon.dart';
// import 'package:gp_app/widgets/messages_widget.dart';
import 'package:gp_app/models/doctor_message.dart';
import 'package:gp_app/apis/apis.dart';

class DocterModelChat extends StatefulWidget {
  final int senderId;
  final int receiverId;

  const DocterModelChat({
    super.key,
    required this.senderId, //dr
    required this.receiverId, //patient 
  });

  @override
  State<DocterModelChat> createState() => DocterModelChatState();
}


class DocterModelChatState extends State<DocterModelChat> {

  //marina
  List<DoctorMessage> messages = [];

  @override
  void initState() {
    super.initState();
    loadChatHistory();
  }

  void loadChatHistory() async {
    try {
      // Pass senderId and receiverId to fetchChatHistory
      List<DoctorMessage> messages = await fetchChatHistory(widget.senderId, widget.receiverId);
      setState(() {
        this.messages = messages;
      });
    } catch (e) {
      print("Failed to load chat history: $e");
    }
  }
//marina

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: messages.length, 
            itemBuilder: (context, index) {
              return DoctorMessagesWidget(doctorMessage: messages[index]);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(left: 16, bottom: 10, right: 16),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 106, 105, 105),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      // controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration:
                          InputDecoration(hintText: S.of(context).message),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
