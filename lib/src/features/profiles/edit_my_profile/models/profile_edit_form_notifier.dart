import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileEditFormNotifierProvider =
    StateNotifierProvider<ProfileEditFormNotifier, ProfileForm>(
  (ref) => ProfileEditFormNotifier(),
);

class ProfileEditFormNotifier extends StateNotifier<ProfileForm> {
  ProfileEditFormNotifier() : super(ProfileForm());

  void setStudy(String? study) {
    state = state.copyWith(study: study);
  }

  void setBoard(String? board) {
    state = state.copyWith(board: board);
  }

  void setPloeg(String? ploeg) {
    state = state.copyWith(ploeg: ploeg);
  }

  void setDubbellid(bool? dubbellid) {
    state = state.copyWith(dubbellid: dubbellid);
  }

  void setOtherAssociation(String? otherAssociation) {
    state = state.copyWith(otherAssociation: otherAssociation);
  }

  void setSubstructuren(List<String>? substructuren) {
    state = state.copyWith(substructures: substructuren);
  }

  void setHuis(String? huis) {
    state = state.copyWith(huis: huis == "Geen" ? null : huis);
  }

  void setProfilePicture(File? profilePicture) {
    state = state.copyWith(profilePicture: profilePicture);
  }
}

class ProfileForm {
  final String? study;
  final String? board;
  final String? ploeg;
  final bool? dubbellid;
  final String? otherAssociation;
  final List<String>? substructures;
  final String? huis;
  final File? profilePicture;

  ProfileForm({
    this.study,
    this.board,
    this.ploeg,
    this.dubbellid,
    this.otherAssociation,
    this.substructures,
    this.huis,
    this.profilePicture,
  });

  ProfileForm copyWith({
    String? study,
    String? board,
    String? ploeg,
    bool? dubbellid,
    String? otherAssociation,
    List<String>? substructures,
    String? huis,
    File? profilePicture,
  }) {
    return ProfileForm(
      study: study ?? this.study,
      board: board ?? this.board,
      ploeg: ploeg ?? this.ploeg,
      dubbellid: dubbellid ?? this.dubbellid,
      otherAssociation: otherAssociation ?? this.otherAssociation,
      substructures: substructures ?? this.substructures,
      huis: huis ?? this.huis,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      if (study != null) 'study': study,
      if (board != null) 'board': board,
      if (ploeg != null) 'ploeg': ploeg,
      if (dubbellid != null) 'dubbellid': dubbellid,
      if (otherAssociation != null) 'otherAssociation': otherAssociation,
      if (substructures != null) 'substructures': substructures,
      if (huis != null) 'huis': huis,
    };
  }
}
