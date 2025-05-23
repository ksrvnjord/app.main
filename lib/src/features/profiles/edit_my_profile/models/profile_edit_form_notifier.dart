// ignore_for_file: prefer-single-declaration-per-file

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// ignore: prefer-static-class
final profileEditFormNotifierProvider =
    StateNotifierProvider<ProfileEditFormNotifier, ProfileForm>(
  (ref) => ProfileEditFormNotifier(),
);

class ProfileEditFormNotifier extends StateNotifier<ProfileForm> {
  ProfileEditFormNotifier() : super(const ProfileForm());

  void setBoard(String? board) {
    state = state.copyWith(board: board);
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

  void setProfilePicture(XFile? profilePicture) {
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
  final XFile? profilePicture;
  // ignore: sort_constructors_first
  const ProfileForm({
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
    XFile? profilePicture,
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

  // ToJson.
  Map<String, dynamic> toJson() {
    return {
      if (study != null) 'study': study,
      if (board != null) 'board': board,
      if (ploeg != null) 'ploeg': ploeg,
      if (dubbellid != null) 'dubbellid': dubbellid,
      if (otherAssociation != null) 'other_association': otherAssociation,
      if (substructures != null) 'substructures': substructures,
      if (huis != null) 'huis': huis,
    };
  }
}
