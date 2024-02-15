import 'package:flutter/material.dart';
import 'package:gp_app/Data/doctor_msg.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/models/patient_list.dart';
import 'package:gp_app/widgets/patients_list.dart';

class DocterProfile extends StatefulWidget {
  const DocterProfile({Key? key}) : super(key: key);

  @override
  State<DocterProfile> createState() => DocterProfileState();
}

class DocterProfileState extends State<DocterProfile> {
  // Sample list of patients
  List<Patient> patients = [
    Patient(name: 'Patient 1', info: 'Info for Patient 1'),
    Patient(name: 'Patient 2', info: 'Info for Patient 2'),
    // Add more patients as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (BuildContext context, int index) {
          return PatientList(
            patient: patients[index],
          );
        },
      ),
    );
  }
}
