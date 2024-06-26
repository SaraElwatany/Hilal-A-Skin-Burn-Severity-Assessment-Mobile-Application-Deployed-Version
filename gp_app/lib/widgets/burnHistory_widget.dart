import 'package:flutter/material.dart';
import 'package:gp_app/models/burn_history.dart';
// import 'package:gp_app/screens/doctor_model_screen.dart';
import 'package:gp_app/screens/patient_model_screen.dart';

class BurnHistoryWidget extends StatefulWidget {
  final BurnHistory burnhistory;

  const BurnHistoryWidget({
    Key? key,
    required this.burnhistory,
  }) : super(key: key);

  @override
  _BurnHistoryState createState() => _BurnHistoryState();
}

class _BurnHistoryState extends State<BurnHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const PatientModelChat(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.transparent,
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 03, 48, 73),
            ),
            child: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 3, 206, 164),
            ),
          ),
          title: Text(widget.burnhistory.degree,
              style: const TextStyle(
                color: Color.fromARGB(255, 03, 48, 73),
              )),
        ),
      ),
    );
  }
}
