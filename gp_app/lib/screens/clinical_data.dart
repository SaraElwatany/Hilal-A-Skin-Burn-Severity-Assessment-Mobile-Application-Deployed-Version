import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/patient_model_screen.dart';
import 'package:gp_app/widgets/clinical_data_widget.dart';
import 'package:gp_app/widgets/localization_icon.dart';

class ClinicalDataScreen extends StatefulWidget {
  const ClinicalDataScreen({Key? key}) : super(key: key);

  @override
  State<ClinicalDataScreen> createState() {
    return ClinicalDataState();
  }
}

enum Symptoms {
  symptom_1,
  symptom_2,
  symptom_3,
  symptom_4,
  heat,
  electricity,
  chemical,
  radioactive
}

class ClinicalDataState extends State<ClinicalDataScreen> {
  Symptoms? selectedSymptom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            alignment: Alignment.topCenter,
            child: Text(
              S.of(context).clinictitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30),
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).symptoms,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20),
            ),
          ),
          Row(
            children: [
          ClinicalData(symptom:Symptoms.symptom_1),
          const SizedBox(width: 80), 
          ClinicalData(symptom:Symptoms.symptom_2),
            ],

          )
          ,
          Row(
            children: [
          ClinicalData(symptom:Symptoms.symptom_3),
          const SizedBox(width: 80), 
          ClinicalData(symptom:Symptoms.symptom_4),
            ],

          ),
          const SizedBox(height: 40,),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).cause,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20),
            ),
          ),
          Row(
            children: [
          ClinicalData(symptom:Symptoms.heat),
          const SizedBox(width: 125), 
          ClinicalData(symptom:Symptoms.electricity),
            ],
          ),
          Row(
            children: [
          ClinicalData(symptom:Symptoms.chemical),
          const SizedBox(width: 108), 
          ClinicalData(symptom:Symptoms.radioactive),
            ],

          ),
          const SizedBox(height: 50), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatScreen()),
              );
            }, 
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              fixedSize: const Size(140, 45),
              backgroundColor:  const Color.fromARGB(255, 29, 49, 78)

              ),
            child: Text(
              S.of(context).confirm,
              style: const TextStyle(
              fontSize: 25,
              color:  Color.fromARGB(255, 255, 251, 251),
            )
            ),
            ),
             const SizedBox(width: 30), 
             ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatScreen()),
              );
            }, 
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
              fixedSize: const Size(140, 45),
              backgroundColor:  const Color.fromARGB(255, 29, 49, 78)

              ),
            child: Text(
              S.of(context).skip,
              style: const TextStyle(
                   fontSize: 25,
                color:  Color.fromARGB(255, 255, 251, 251),
            )
            ),
            ),

            ],
          ),
        
          
          
        ],
      ),
    );
  }
}

