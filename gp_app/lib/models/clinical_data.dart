enum Symptoms {
  symptom_1,
  symptom_2,
  symptom_3,
  symptom_4,
  heat,
  electricity,
  chemical,
  radioactive,
  boiling,
  place,
  arm,
  leg,
head,
back,
chest

}
class ClinicalData {
  final List<Symptoms> firstGroupSymptoms;
  final Symptoms? secondGroupSymptom;

  ClinicalData({
    required this.firstGroupSymptoms,
    this.secondGroupSymptom,
  });
}

