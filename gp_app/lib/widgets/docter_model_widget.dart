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
            Align(
              alignment: Alignment.topRight,
              child: (doctorMessage.receiver == false)
                  ? Image.asset(
                      doctorMessage.image!,
                    )
                  : null,
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
                        Visibility(
                          visible: (doctorMessage.receiver == false),
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
                    onPressed: () {},
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
                    onPressed: () {},
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
