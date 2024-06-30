class Patient {
  final String name;
  final String info;
  final int id;
  final int? burn_id;

  Patient(
      {required this.name, required this.info, required this.id, this.burn_id});
}
