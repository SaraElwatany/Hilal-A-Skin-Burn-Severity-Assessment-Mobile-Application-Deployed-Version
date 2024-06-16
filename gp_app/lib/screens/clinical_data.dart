import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/apis/apis.dart';

import 'package:gp_app/widgets/clinical_data_widget.dart';
import 'package:gp_app/screens/patient_model_screen.dart';
import 'package:gp_app/models/clinical_data.dart';


class ClinicalDataScreen extends StatefulWidget {
  final int senderId;
  final int receiverId;
 
  const ClinicalDataScreen({
    Key? key,
    required this.senderId, // Patient
    required this.receiverId, // Doctor
  }) : super(key: key);

  @override
  State<ClinicalDataScreen> createState() {
    return ClinicalDataState();
  }
}



class ClinicalDataState extends State<ClinicalDataScreen> {
  List<Symptoms> selectedFirstGroupSymptoms = [];
  Symptoms? selectedSecondGroupSymptom;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).clinictitle,
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).symptoms,
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 20),
            ),
          ),
          Row(
            children: [
              ClinicalDataCheckbox(
                symptom: Symptoms.symptom_1,
                selectedSymptoms: selectedFirstGroupSymptoms,
                onSymptomSelected: (symptom) {
                  _handleFirstGroupSymptomSelected(symptom);
                },
              ),
              ClinicalDataCheckbox(
                symptom: Symptoms.symptom_2,
                selectedSymptoms: selectedFirstGroupSymptoms,
                onSymptomSelected: (symptom) {
                  _handleFirstGroupSymptomSelected(symptom);
                },
              ),
            ],
          ),
          Row(
            children: [
              ClinicalDataCheckbox(
                symptom: Symptoms.symptom_3,
                selectedSymptoms: selectedFirstGroupSymptoms,
                onSymptomSelected: (symptom) {
                  _handleFirstGroupSymptomSelected(symptom);
                },
              ),
              ClinicalDataCheckbox(
                symptom: Symptoms.symptom_4,
                selectedSymptoms: selectedFirstGroupSymptoms,
                onSymptomSelected: (symptom) {
                  _handleFirstGroupSymptomSelected(symptom);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).cause,
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 20),
            ),
          ),
          Row(
            children: [
              ClinicalDataCheckbox(
                symptom: Symptoms.heat,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
              ClinicalDataCheckbox(
                symptom: Symptoms.electricity,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
            ],
          ),
          Row(
            children: [
              ClinicalDataCheckbox(
                symptom: Symptoms.chemical,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
              ClinicalDataCheckbox(
                symptom: Symptoms.radioactive,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
                ClinicalDataCheckbox(
                symptom: Symptoms.boiling,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),

            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).place,
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 20),
            ),
          ),
             Row(
            children: [
              ClinicalDataCheckbox(
                symptom: Symptoms.head,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
              ClinicalDataCheckbox(
                symptom: Symptoms.chest,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
            ],
          ),
             Row(
            children: [
              ClinicalDataCheckbox(
                symptom: Symptoms.back,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
              ClinicalDataCheckbox(
                symptom: Symptoms.leg,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
               ClinicalDataCheckbox(
                symptom: Symptoms.arm,
                selectedSymptoms: selectedSecondGroupSymptom != null
                    ? [selectedSecondGroupSymptom!]
                    : [],
                onSymptomSelected: (symptom) {
                  _handleSecondGroupSymptomSelected(symptom);
                },
              ),
            ],
          ),





          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  addClinicalData(selectedFirstGroupSymptoms,
                      selectedSecondGroupSymptom, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientModelChat(
                        senderId: widget.senderId,
                        receiverId: widget.receiverId,
                      ),));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fixedSize: const Size(140, 45),
                  backgroundColor: const Color.fromARGB(255, 29, 49, 78),
                ),
                child: Text(
                  S.of(context).confirm,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 251, 251),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                onPressed: () {
                  skipClinicalData(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                  builder: (context) => PatientModelChat(
                    senderId: widget.senderId,
                    receiverId: widget.receiverId,
                  ),),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fixedSize: const Size(140, 45),
                  backgroundColor: const Color.fromARGB(255, 29, 49, 78),
                ),
                child: Text(
                  S.of(context).skip,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 251, 251),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleFirstGroupSymptomSelected(Symptoms symptom) {
    setState(() {
      if (selectedFirstGroupSymptoms.contains(symptom)) {
        selectedFirstGroupSymptoms.remove(symptom);
      } else {
        selectedFirstGroupSymptoms.add(symptom);
      }
    });
  }

  void _handleSecondGroupSymptomSelected(Symptoms symptom) {
    setState(() {
      selectedSecondGroupSymptom = symptom;
    });
  }
}
