// TODO: maybe start looking a bit more into the json_serializable package
class AlmanakProfile {
  String? study;
  String? board;
  String? ploeg;
  bool? dubbellid;
  String? otherAssociation;
  List<String>? commissies;
  String? huis;

  AlmanakProfile({
    this.study,
    this.board,
    this.ploeg,
    this.dubbellid,
    this.otherAssociation,
    this.commissies,
    this.huis,
  });

  // Add a factory constructor that takes a Map<String, dynamic> and returns an AlmanakProfile
  factory AlmanakProfile.fromJson(Map<String, dynamic> json) {
    return AlmanakProfile(
      study: json['study'] as String?,
      board: json['board'] as String?,
      ploeg: json['ploeg'] as String?,
      dubbellid: json['dubbellid'] as bool?,
      otherAssociation: json['other_association'] as String?,
      commissies: json.containsKey('commissies')
          ? List<String>.from(json['commissies'])
          : null,
      huis: json['huis'] as String?,
    );
  }

  // Add a toJson method that returns a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'study': study,
      'board': board,
      'ploeg': ploeg,
      'dubbellid': dubbellid,
      'other_association': otherAssociation,
      'commissies': commissies,
      'huis': huis,
    };
  }
}
