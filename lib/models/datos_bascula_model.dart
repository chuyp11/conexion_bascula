class DatosBasculaModel {
  double height;
  int age;
  int sex;
  int impedance;
  double weight;
  double bmi;
  double fatRate;
  double fatKg;
  double subcutaneousFatRate;
  double subcutaneousFatKg;
  double muscleRate;
  double muscleKg;
  double waterRate;
  double waterKg;
  int visceralFat;
  double visceralFatKg;
  double boneRate;
  double boneKg;
  double bmr;
  double proteinPercentageRate;
  double proteinPercentageKg;
  int bodyAge;
  int bodyScore;
  double standardWeight;
  double notFatWeight;
  double controlWeight;
  double controlFatKg;
  double controlMuscleKg;
  int obesityLevel;
  int healthLevel;
  int bodyType;
  int impedanceStatus;
  String mac;

  DatosBasculaModel({
    this.height = 0,
    this.age = 0,
    this.sex = 0,
    this.impedance = 0,
    this.weight = 0,
    this.bmi = 0,
    this.fatRate = 0,
    this.fatKg = 0,
    this.subcutaneousFatRate = 0,
    this.subcutaneousFatKg = 0,
    this.muscleRate = 0,
    this.muscleKg = 0,
    this.waterRate = 0,
    this.waterKg = 0,
    this.visceralFat = 0,
    this.visceralFatKg = 0,
    this.boneRate = 0,
    this.boneKg = 0,
    this.bmr = 0,
    this.proteinPercentageRate = 0,
    this.proteinPercentageKg = 0,
    this.bodyAge = 0,
    this.bodyScore = 0,
    this.standardWeight = 0,
    this.notFatWeight = 0,
    this.controlWeight = 0,
    this.controlFatKg = 0,
    this.controlMuscleKg = 0,
    this.obesityLevel = 0,
    this.healthLevel = 0,
    this.bodyType = 0,
    this.impedanceStatus = 0,
    this.mac = '',
  });

  factory DatosBasculaModel.fromJson(Map<String, dynamic> parsedJson) {
    print('parsedJson: ' + parsedJson.toString());
    return DatosBasculaModel(
      height: (parsedJson['height'] != null) ? parsedJson['height'] : 0,
      age: (parsedJson['age'] != null) ? parsedJson['age'] : 0,
      sex: (parsedJson['sex'] != null) ? parsedJson['sex'] : 0,
      impedance:
          (parsedJson['impedance'] != null) ? parsedJson['impedance'] : 0,
      weight: (parsedJson['weight'] != null) ? parsedJson['weight'] : 0,
      bmi: (parsedJson['BMI'] != null) ? parsedJson['BMI'] : 0,
      fatRate: (parsedJson['fatRate'] != null) ? parsedJson['fatRate'] : 0,
      fatKg: (parsedJson['fatKg'] != null) ? parsedJson['fatKg'] : 0,
      subcutaneousFatRate: (parsedJson['subcutaneousFatRate'] != null)
          ? parsedJson['subcutaneousFatRate']
          : 0,
      subcutaneousFatKg: (parsedJson['subcutaneousFatKg'] != null)
          ? parsedJson['subcutaneousFatKg']
          : 0,
      muscleRate:
          (parsedJson['muscleRate'] != null) ? parsedJson['muscleRate'] : 0,
      muscleKg: (parsedJson['muscleKg'] != null) ? parsedJson['muscleKg'] : 0,
      waterRate:
          (parsedJson['waterRate'] != null) ? parsedJson['waterRate'] : 0,
      waterKg: (parsedJson['waterKg'] != null) ? parsedJson['waterKg'] : 0,
      visceralFat:
          (parsedJson['visceralFat'] != null) ? parsedJson['visceralFat'] : 0,
      visceralFatKg: (parsedJson['visceralFatKg'] != null)
          ? parsedJson['visceralFatKg']
          : 0,
      boneRate: (parsedJson['boneRate'] != null) ? parsedJson['boneRate'] : 0,
      boneKg: (parsedJson['boneKg'] != null) ? parsedJson['boneKg'] : 0,
      bmr: (parsedJson['BMR'] != null) ? parsedJson['BMR'] : 0,
      proteinPercentageRate: (parsedJson['proteinPercentageRate'] != null)
          ? parsedJson['proteinPercentageRate']
          : 0,
      proteinPercentageKg: (parsedJson['proteinPercentageKg'] != null)
          ? parsedJson['proteinPercentageKg']
          : 0,
      bodyAge: (parsedJson['bodyAge'] != null) ? parsedJson['bodyAge'] : 0,
      bodyScore:
          (parsedJson['bodyScore'] != null) ? parsedJson['bodyScore'] : 0,
      standardWeight: (parsedJson['standardWeight'] != null)
          ? parsedJson['standardWeight']
          : 0,
      notFatWeight:
          (parsedJson['notFatWeight'] != null) ? parsedJson['notFatWeight'] : 0,
      controlWeight: (parsedJson['controlWeight'] != null)
          ? parsedJson['controlWeight']
          : 0,
      controlFatKg:
          (parsedJson['controlFatKg'] != null) ? parsedJson['controlFatKg'] : 0,
      controlMuscleKg: (parsedJson['controlMuscleKg'] != null)
          ? parsedJson['controlMuscleKg']
          : 0,
      obesityLevel:
          (parsedJson['obesityLevel'] != null) ? parsedJson['obesityLevel'] : 0,
      healthLevel:
          (parsedJson['healthLevel'] != null) ? parsedJson['healthLevel'] : 0,
      bodyType: (parsedJson['bodyType'] != null) ? parsedJson['bodyType'] : 0,
      impedanceStatus: (parsedJson['impedanceStatus'] != null)
          ? parsedJson['impedanceStatus']
          : 0,
    );
  }

  List<DatosBasculaModel> fromJsonList(
      List<Map<String, dynamic>> listaParsedJson) {
    List<DatosBasculaModel> catFormaPago = [];

    DatosBasculaModel formaPago;

    for (int i = 0; i < listaParsedJson.length; i++) {
      formaPago = new DatosBasculaModel.fromJson(listaParsedJson[i]);

      catFormaPago.add(formaPago);
    }

    return catFormaPago;
  }
}
