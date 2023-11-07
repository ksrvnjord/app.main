// ignore_for_file: type=lint
class Input$IBooleanContact {
  factory Input$IBooleanContact({
    bool? initials,
    bool? first_name,
    bool? last_name,
    bool? zipcode,
    bool? street,
    bool? housenumber,
    bool? housenumber_addition,
    bool? city,
    bool? country,
    bool? email,
    bool? phone_primary,
    bool? phone_secondary,
  }) =>
      Input$IBooleanContact._({
        if (initials != null) r'initials': initials,
        if (first_name != null) r'first_name': first_name,
        if (last_name != null) r'last_name': last_name,
        if (zipcode != null) r'zipcode': zipcode,
        if (street != null) r'street': street,
        if (housenumber != null) r'housenumber': housenumber,
        if (housenumber_addition != null)
          r'housenumber_addition': housenumber_addition,
        if (city != null) r'city': city,
        if (country != null) r'country': country,
        if (email != null) r'email': email,
        if (phone_primary != null) r'phone_primary': phone_primary,
        if (phone_secondary != null) r'phone_secondary': phone_secondary,
      });

  Input$IBooleanContact._(this._$data);

  factory Input$IBooleanContact.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('initials')) {
      final l$initials = data['initials'];
      result$data['initials'] = (l$initials as bool?);
    }
    if (data.containsKey('first_name')) {
      final l$first_name = data['first_name'];
      result$data['first_name'] = (l$first_name as bool?);
    }
    if (data.containsKey('last_name')) {
      final l$last_name = data['last_name'];
      result$data['last_name'] = (l$last_name as bool?);
    }
    if (data.containsKey('zipcode')) {
      final l$zipcode = data['zipcode'];
      result$data['zipcode'] = (l$zipcode as bool?);
    }
    if (data.containsKey('street')) {
      final l$street = data['street'];
      result$data['street'] = (l$street as bool?);
    }
    if (data.containsKey('housenumber')) {
      final l$housenumber = data['housenumber'];
      result$data['housenumber'] = (l$housenumber as bool?);
    }
    if (data.containsKey('housenumber_addition')) {
      final l$housenumber_addition = data['housenumber_addition'];
      result$data['housenumber_addition'] = (l$housenumber_addition as bool?);
    }
    if (data.containsKey('city')) {
      final l$city = data['city'];
      result$data['city'] = (l$city as bool?);
    }
    if (data.containsKey('country')) {
      final l$country = data['country'];
      result$data['country'] = (l$country as bool?);
    }
    if (data.containsKey('email')) {
      final l$email = data['email'];
      result$data['email'] = (l$email as bool?);
    }
    if (data.containsKey('phone_primary')) {
      final l$phone_primary = data['phone_primary'];
      result$data['phone_primary'] = (l$phone_primary as bool?);
    }
    if (data.containsKey('phone_secondary')) {
      final l$phone_secondary = data['phone_secondary'];
      result$data['phone_secondary'] = (l$phone_secondary as bool?);
    }
    return Input$IBooleanContact._(result$data);
  }

  Map<String, dynamic> _$data;

  bool? get initials => (_$data['initials'] as bool?);
  bool? get first_name => (_$data['first_name'] as bool?);
  bool? get last_name => (_$data['last_name'] as bool?);
  bool? get zipcode => (_$data['zipcode'] as bool?);
  bool? get street => (_$data['street'] as bool?);
  bool? get housenumber => (_$data['housenumber'] as bool?);
  bool? get housenumber_addition => (_$data['housenumber_addition'] as bool?);
  bool? get city => (_$data['city'] as bool?);
  bool? get country => (_$data['country'] as bool?);
  bool? get email => (_$data['email'] as bool?);
  bool? get phone_primary => (_$data['phone_primary'] as bool?);
  bool? get phone_secondary => (_$data['phone_secondary'] as bool?);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('initials')) {
      final l$initials = initials;
      result$data['initials'] = l$initials;
    }
    if (_$data.containsKey('first_name')) {
      final l$first_name = first_name;
      result$data['first_name'] = l$first_name;
    }
    if (_$data.containsKey('last_name')) {
      final l$last_name = last_name;
      result$data['last_name'] = l$last_name;
    }
    if (_$data.containsKey('zipcode')) {
      final l$zipcode = zipcode;
      result$data['zipcode'] = l$zipcode;
    }
    if (_$data.containsKey('street')) {
      final l$street = street;
      result$data['street'] = l$street;
    }
    if (_$data.containsKey('housenumber')) {
      final l$housenumber = housenumber;
      result$data['housenumber'] = l$housenumber;
    }
    if (_$data.containsKey('housenumber_addition')) {
      final l$housenumber_addition = housenumber_addition;
      result$data['housenumber_addition'] = l$housenumber_addition;
    }
    if (_$data.containsKey('city')) {
      final l$city = city;
      result$data['city'] = l$city;
    }
    if (_$data.containsKey('country')) {
      final l$country = country;
      result$data['country'] = l$country;
    }
    if (_$data.containsKey('email')) {
      final l$email = email;
      result$data['email'] = l$email;
    }
    if (_$data.containsKey('phone_primary')) {
      final l$phone_primary = phone_primary;
      result$data['phone_primary'] = l$phone_primary;
    }
    if (_$data.containsKey('phone_secondary')) {
      final l$phone_secondary = phone_secondary;
      result$data['phone_secondary'] = l$phone_secondary;
    }
    return result$data;
  }

  CopyWith$Input$IBooleanContact<Input$IBooleanContact> get copyWith =>
      CopyWith$Input$IBooleanContact(
        this,
        (i) => i,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$IBooleanContact) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$initials = initials;
    final lOther$initials = other.initials;
    if (_$data.containsKey('initials') !=
        other._$data.containsKey('initials')) {
      return false;
    }
    if (l$initials != lOther$initials) {
      return false;
    }
    final l$first_name = first_name;
    final lOther$first_name = other.first_name;
    if (_$data.containsKey('first_name') !=
        other._$data.containsKey('first_name')) {
      return false;
    }
    if (l$first_name != lOther$first_name) {
      return false;
    }
    final l$last_name = last_name;
    final lOther$last_name = other.last_name;
    if (_$data.containsKey('last_name') !=
        other._$data.containsKey('last_name')) {
      return false;
    }
    if (l$last_name != lOther$last_name) {
      return false;
    }
    final l$zipcode = zipcode;
    final lOther$zipcode = other.zipcode;
    if (_$data.containsKey('zipcode') != other._$data.containsKey('zipcode')) {
      return false;
    }
    if (l$zipcode != lOther$zipcode) {
      return false;
    }
    final l$street = street;
    final lOther$street = other.street;
    if (_$data.containsKey('street') != other._$data.containsKey('street')) {
      return false;
    }
    if (l$street != lOther$street) {
      return false;
    }
    final l$housenumber = housenumber;
    final lOther$housenumber = other.housenumber;
    if (_$data.containsKey('housenumber') !=
        other._$data.containsKey('housenumber')) {
      return false;
    }
    if (l$housenumber != lOther$housenumber) {
      return false;
    }
    final l$housenumber_addition = housenumber_addition;
    final lOther$housenumber_addition = other.housenumber_addition;
    if (_$data.containsKey('housenumber_addition') !=
        other._$data.containsKey('housenumber_addition')) {
      return false;
    }
    if (l$housenumber_addition != lOther$housenumber_addition) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (_$data.containsKey('city') != other._$data.containsKey('city')) {
      return false;
    }
    if (l$city != lOther$city) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (_$data.containsKey('country') != other._$data.containsKey('country')) {
      return false;
    }
    if (l$country != lOther$country) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (_$data.containsKey('email') != other._$data.containsKey('email')) {
      return false;
    }
    if (l$email != lOther$email) {
      return false;
    }
    final l$phone_primary = phone_primary;
    final lOther$phone_primary = other.phone_primary;
    if (_$data.containsKey('phone_primary') !=
        other._$data.containsKey('phone_primary')) {
      return false;
    }
    if (l$phone_primary != lOther$phone_primary) {
      return false;
    }
    final l$phone_secondary = phone_secondary;
    final lOther$phone_secondary = other.phone_secondary;
    if (_$data.containsKey('phone_secondary') !=
        other._$data.containsKey('phone_secondary')) {
      return false;
    }
    if (l$phone_secondary != lOther$phone_secondary) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$initials = initials;
    final l$first_name = first_name;
    final l$last_name = last_name;
    final l$zipcode = zipcode;
    final l$street = street;
    final l$housenumber = housenumber;
    final l$housenumber_addition = housenumber_addition;
    final l$city = city;
    final l$country = country;
    final l$email = email;
    final l$phone_primary = phone_primary;
    final l$phone_secondary = phone_secondary;
    return Object.hashAll([
      _$data.containsKey('initials') ? l$initials : const {},
      _$data.containsKey('first_name') ? l$first_name : const {},
      _$data.containsKey('last_name') ? l$last_name : const {},
      _$data.containsKey('zipcode') ? l$zipcode : const {},
      _$data.containsKey('street') ? l$street : const {},
      _$data.containsKey('housenumber') ? l$housenumber : const {},
      _$data.containsKey('housenumber_addition')
          ? l$housenumber_addition
          : const {},
      _$data.containsKey('city') ? l$city : const {},
      _$data.containsKey('country') ? l$country : const {},
      _$data.containsKey('email') ? l$email : const {},
      _$data.containsKey('phone_primary') ? l$phone_primary : const {},
      _$data.containsKey('phone_secondary') ? l$phone_secondary : const {},
    ]);
  }
}

abstract class CopyWith$Input$IBooleanContact<TRes> {
  factory CopyWith$Input$IBooleanContact(
    Input$IBooleanContact instance,
    TRes Function(Input$IBooleanContact) then,
  ) = _CopyWithImpl$Input$IBooleanContact;

  factory CopyWith$Input$IBooleanContact.stub(TRes res) =
      _CopyWithStubImpl$Input$IBooleanContact;

  TRes call({
    bool? initials,
    bool? first_name,
    bool? last_name,
    bool? zipcode,
    bool? street,
    bool? housenumber,
    bool? housenumber_addition,
    bool? city,
    bool? country,
    bool? email,
    bool? phone_primary,
    bool? phone_secondary,
  });
}

class _CopyWithImpl$Input$IBooleanContact<TRes>
    implements CopyWith$Input$IBooleanContact<TRes> {
  _CopyWithImpl$Input$IBooleanContact(
    this._instance,
    this._then,
  );

  final Input$IBooleanContact _instance;

  final TRes Function(Input$IBooleanContact) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? initials = _undefined,
    Object? first_name = _undefined,
    Object? last_name = _undefined,
    Object? zipcode = _undefined,
    Object? street = _undefined,
    Object? housenumber = _undefined,
    Object? housenumber_addition = _undefined,
    Object? city = _undefined,
    Object? country = _undefined,
    Object? email = _undefined,
    Object? phone_primary = _undefined,
    Object? phone_secondary = _undefined,
  }) =>
      _then(Input$IBooleanContact._({
        ..._instance._$data,
        if (initials != _undefined) 'initials': (initials as bool?),
        if (first_name != _undefined) 'first_name': (first_name as bool?),
        if (last_name != _undefined) 'last_name': (last_name as bool?),
        if (zipcode != _undefined) 'zipcode': (zipcode as bool?),
        if (street != _undefined) 'street': (street as bool?),
        if (housenumber != _undefined) 'housenumber': (housenumber as bool?),
        if (housenumber_addition != _undefined)
          'housenumber_addition': (housenumber_addition as bool?),
        if (city != _undefined) 'city': (city as bool?),
        if (country != _undefined) 'country': (country as bool?),
        if (email != _undefined) 'email': (email as bool?),
        if (phone_primary != _undefined)
          'phone_primary': (phone_primary as bool?),
        if (phone_secondary != _undefined)
          'phone_secondary': (phone_secondary as bool?),
      }));
}

class _CopyWithStubImpl$Input$IBooleanContact<TRes>
    implements CopyWith$Input$IBooleanContact<TRes> {
  _CopyWithStubImpl$Input$IBooleanContact(this._res);

  TRes _res;

  call({
    bool? initials,
    bool? first_name,
    bool? last_name,
    bool? zipcode,
    bool? street,
    bool? housenumber,
    bool? housenumber_addition,
    bool? city,
    bool? country,
    bool? email,
    bool? phone_primary,
    bool? phone_secondary,
  }) =>
      _res;
}

class Input$IContact {
  factory Input$IContact({
    String? initials,
    String? first_name,
    String? last_name,
    String? zipcode,
    String? street,
    String? housenumber,
    String? housenumber_addition,
    String? city,
    String? country,
    String? email,
    String? phone_primary,
    String? phone_secondary,
  }) =>
      Input$IContact._({
        if (initials != null) r'initials': initials,
        if (first_name != null) r'first_name': first_name,
        if (last_name != null) r'last_name': last_name,
        if (zipcode != null) r'zipcode': zipcode,
        if (street != null) r'street': street,
        if (housenumber != null) r'housenumber': housenumber,
        if (housenumber_addition != null)
          r'housenumber_addition': housenumber_addition,
        if (city != null) r'city': city,
        if (country != null) r'country': country,
        if (email != null) r'email': email,
        if (phone_primary != null) r'phone_primary': phone_primary,
        if (phone_secondary != null) r'phone_secondary': phone_secondary,
      });

  Input$IContact._(this._$data);

  factory Input$IContact.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('initials')) {
      final l$initials = data['initials'];
      result$data['initials'] = (l$initials as String?);
    }
    if (data.containsKey('first_name')) {
      final l$first_name = data['first_name'];
      result$data['first_name'] = (l$first_name as String?);
    }
    if (data.containsKey('last_name')) {
      final l$last_name = data['last_name'];
      result$data['last_name'] = (l$last_name as String?);
    }
    if (data.containsKey('zipcode')) {
      final l$zipcode = data['zipcode'];
      result$data['zipcode'] = (l$zipcode as String?);
    }
    if (data.containsKey('street')) {
      final l$street = data['street'];
      result$data['street'] = (l$street as String?);
    }
    if (data.containsKey('housenumber')) {
      final l$housenumber = data['housenumber'];
      result$data['housenumber'] = (l$housenumber as String?);
    }
    if (data.containsKey('housenumber_addition')) {
      final l$housenumber_addition = data['housenumber_addition'];
      result$data['housenumber_addition'] = (l$housenumber_addition as String?);
    }
    if (data.containsKey('city')) {
      final l$city = data['city'];
      result$data['city'] = (l$city as String?);
    }
    if (data.containsKey('country')) {
      final l$country = data['country'];
      result$data['country'] = (l$country as String?);
    }
    if (data.containsKey('email')) {
      final l$email = data['email'];
      result$data['email'] = (l$email as String?);
    }
    if (data.containsKey('phone_primary')) {
      final l$phone_primary = data['phone_primary'];
      result$data['phone_primary'] = (l$phone_primary as String?);
    }
    if (data.containsKey('phone_secondary')) {
      final l$phone_secondary = data['phone_secondary'];
      result$data['phone_secondary'] = (l$phone_secondary as String?);
    }
    return Input$IContact._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get initials => (_$data['initials'] as String?);
  String? get first_name => (_$data['first_name'] as String?);
  String? get last_name => (_$data['last_name'] as String?);
  String? get zipcode => (_$data['zipcode'] as String?);
  String? get street => (_$data['street'] as String?);
  String? get housenumber => (_$data['housenumber'] as String?);
  String? get housenumber_addition =>
      (_$data['housenumber_addition'] as String?);
  String? get city => (_$data['city'] as String?);
  String? get country => (_$data['country'] as String?);
  String? get email => (_$data['email'] as String?);
  String? get phone_primary => (_$data['phone_primary'] as String?);
  String? get phone_secondary => (_$data['phone_secondary'] as String?);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('initials')) {
      final l$initials = initials;
      result$data['initials'] = l$initials;
    }
    if (_$data.containsKey('first_name')) {
      final l$first_name = first_name;
      result$data['first_name'] = l$first_name;
    }
    if (_$data.containsKey('last_name')) {
      final l$last_name = last_name;
      result$data['last_name'] = l$last_name;
    }
    if (_$data.containsKey('zipcode')) {
      final l$zipcode = zipcode;
      result$data['zipcode'] = l$zipcode;
    }
    if (_$data.containsKey('street')) {
      final l$street = street;
      result$data['street'] = l$street;
    }
    if (_$data.containsKey('housenumber')) {
      final l$housenumber = housenumber;
      result$data['housenumber'] = l$housenumber;
    }
    if (_$data.containsKey('housenumber_addition')) {
      final l$housenumber_addition = housenumber_addition;
      result$data['housenumber_addition'] = l$housenumber_addition;
    }
    if (_$data.containsKey('city')) {
      final l$city = city;
      result$data['city'] = l$city;
    }
    if (_$data.containsKey('country')) {
      final l$country = country;
      result$data['country'] = l$country;
    }
    if (_$data.containsKey('email')) {
      final l$email = email;
      result$data['email'] = l$email;
    }
    if (_$data.containsKey('phone_primary')) {
      final l$phone_primary = phone_primary;
      result$data['phone_primary'] = l$phone_primary;
    }
    if (_$data.containsKey('phone_secondary')) {
      final l$phone_secondary = phone_secondary;
      result$data['phone_secondary'] = l$phone_secondary;
    }
    return result$data;
  }

  CopyWith$Input$IContact<Input$IContact> get copyWith =>
      CopyWith$Input$IContact(
        this,
        (i) => i,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$IContact) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$initials = initials;
    final lOther$initials = other.initials;
    if (_$data.containsKey('initials') !=
        other._$data.containsKey('initials')) {
      return false;
    }
    if (l$initials != lOther$initials) {
      return false;
    }
    final l$first_name = first_name;
    final lOther$first_name = other.first_name;
    if (_$data.containsKey('first_name') !=
        other._$data.containsKey('first_name')) {
      return false;
    }
    if (l$first_name != lOther$first_name) {
      return false;
    }
    final l$last_name = last_name;
    final lOther$last_name = other.last_name;
    if (_$data.containsKey('last_name') !=
        other._$data.containsKey('last_name')) {
      return false;
    }
    if (l$last_name != lOther$last_name) {
      return false;
    }
    final l$zipcode = zipcode;
    final lOther$zipcode = other.zipcode;
    if (_$data.containsKey('zipcode') != other._$data.containsKey('zipcode')) {
      return false;
    }
    if (l$zipcode != lOther$zipcode) {
      return false;
    }
    final l$street = street;
    final lOther$street = other.street;
    if (_$data.containsKey('street') != other._$data.containsKey('street')) {
      return false;
    }
    if (l$street != lOther$street) {
      return false;
    }
    final l$housenumber = housenumber;
    final lOther$housenumber = other.housenumber;
    if (_$data.containsKey('housenumber') !=
        other._$data.containsKey('housenumber')) {
      return false;
    }
    if (l$housenumber != lOther$housenumber) {
      return false;
    }
    final l$housenumber_addition = housenumber_addition;
    final lOther$housenumber_addition = other.housenumber_addition;
    if (_$data.containsKey('housenumber_addition') !=
        other._$data.containsKey('housenumber_addition')) {
      return false;
    }
    if (l$housenumber_addition != lOther$housenumber_addition) {
      return false;
    }
    final l$city = city;
    final lOther$city = other.city;
    if (_$data.containsKey('city') != other._$data.containsKey('city')) {
      return false;
    }
    if (l$city != lOther$city) {
      return false;
    }
    final l$country = country;
    final lOther$country = other.country;
    if (_$data.containsKey('country') != other._$data.containsKey('country')) {
      return false;
    }
    if (l$country != lOther$country) {
      return false;
    }
    final l$email = email;
    final lOther$email = other.email;
    if (_$data.containsKey('email') != other._$data.containsKey('email')) {
      return false;
    }
    if (l$email != lOther$email) {
      return false;
    }
    final l$phone_primary = phone_primary;
    final lOther$phone_primary = other.phone_primary;
    if (_$data.containsKey('phone_primary') !=
        other._$data.containsKey('phone_primary')) {
      return false;
    }
    if (l$phone_primary != lOther$phone_primary) {
      return false;
    }
    final l$phone_secondary = phone_secondary;
    final lOther$phone_secondary = other.phone_secondary;
    if (_$data.containsKey('phone_secondary') !=
        other._$data.containsKey('phone_secondary')) {
      return false;
    }
    if (l$phone_secondary != lOther$phone_secondary) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$initials = initials;
    final l$first_name = first_name;
    final l$last_name = last_name;
    final l$zipcode = zipcode;
    final l$street = street;
    final l$housenumber = housenumber;
    final l$housenumber_addition = housenumber_addition;
    final l$city = city;
    final l$country = country;
    final l$email = email;
    final l$phone_primary = phone_primary;
    final l$phone_secondary = phone_secondary;
    return Object.hashAll([
      _$data.containsKey('initials') ? l$initials : const {},
      _$data.containsKey('first_name') ? l$first_name : const {},
      _$data.containsKey('last_name') ? l$last_name : const {},
      _$data.containsKey('zipcode') ? l$zipcode : const {},
      _$data.containsKey('street') ? l$street : const {},
      _$data.containsKey('housenumber') ? l$housenumber : const {},
      _$data.containsKey('housenumber_addition')
          ? l$housenumber_addition
          : const {},
      _$data.containsKey('city') ? l$city : const {},
      _$data.containsKey('country') ? l$country : const {},
      _$data.containsKey('email') ? l$email : const {},
      _$data.containsKey('phone_primary') ? l$phone_primary : const {},
      _$data.containsKey('phone_secondary') ? l$phone_secondary : const {},
    ]);
  }
}

abstract class CopyWith$Input$IContact<TRes> {
  factory CopyWith$Input$IContact(
    Input$IContact instance,
    TRes Function(Input$IContact) then,
  ) = _CopyWithImpl$Input$IContact;

  factory CopyWith$Input$IContact.stub(TRes res) =
      _CopyWithStubImpl$Input$IContact;

  TRes call({
    String? initials,
    String? first_name,
    String? last_name,
    String? zipcode,
    String? street,
    String? housenumber,
    String? housenumber_addition,
    String? city,
    String? country,
    String? email,
    String? phone_primary,
    String? phone_secondary,
  });
}

class _CopyWithImpl$Input$IContact<TRes>
    implements CopyWith$Input$IContact<TRes> {
  _CopyWithImpl$Input$IContact(
    this._instance,
    this._then,
  );

  final Input$IContact _instance;

  final TRes Function(Input$IContact) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? initials = _undefined,
    Object? first_name = _undefined,
    Object? last_name = _undefined,
    Object? zipcode = _undefined,
    Object? street = _undefined,
    Object? housenumber = _undefined,
    Object? housenumber_addition = _undefined,
    Object? city = _undefined,
    Object? country = _undefined,
    Object? email = _undefined,
    Object? phone_primary = _undefined,
    Object? phone_secondary = _undefined,
  }) =>
      _then(Input$IContact._({
        ..._instance._$data,
        if (initials != _undefined) 'initials': (initials as String?),
        if (first_name != _undefined) 'first_name': (first_name as String?),
        if (last_name != _undefined) 'last_name': (last_name as String?),
        if (zipcode != _undefined) 'zipcode': (zipcode as String?),
        if (street != _undefined) 'street': (street as String?),
        if (housenumber != _undefined) 'housenumber': (housenumber as String?),
        if (housenumber_addition != _undefined)
          'housenumber_addition': (housenumber_addition as String?),
        if (city != _undefined) 'city': (city as String?),
        if (country != _undefined) 'country': (country as String?),
        if (email != _undefined) 'email': (email as String?),
        if (phone_primary != _undefined)
          'phone_primary': (phone_primary as String?),
        if (phone_secondary != _undefined)
          'phone_secondary': (phone_secondary as String?),
      }));
}

class _CopyWithStubImpl$Input$IContact<TRes>
    implements CopyWith$Input$IContact<TRes> {
  _CopyWithStubImpl$Input$IContact(this._res);

  TRes _res;

  call({
    String? initials,
    String? first_name,
    String? last_name,
    String? zipcode,
    String? street,
    String? housenumber,
    String? housenumber_addition,
    String? city,
    String? country,
    String? email,
    String? phone_primary,
    String? phone_secondary,
  }) =>
      _res;
}

class Input$OrderByClause {
  factory Input$OrderByClause({
    required String column,
    required Enum$SortOrder order,
  }) =>
      Input$OrderByClause._({
        r'column': column,
        r'order': order,
      });

  Input$OrderByClause._(this._$data);

  factory Input$OrderByClause.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$column = data['column'];
    result$data['column'] = (l$column as String);
    final l$order = data['order'];
    result$data['order'] = fromJson$Enum$SortOrder((l$order as String));
    return Input$OrderByClause._(result$data);
  }

  Map<String, dynamic> _$data;

  String get column => (_$data['column'] as String);
  Enum$SortOrder get order => (_$data['order'] as Enum$SortOrder);
  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$column = column;
    result$data['column'] = l$column;
    final l$order = order;
    result$data['order'] = toJson$Enum$SortOrder(l$order);
    return result$data;
  }

  CopyWith$Input$OrderByClause<Input$OrderByClause> get copyWith =>
      CopyWith$Input$OrderByClause(
        this,
        (i) => i,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Input$OrderByClause) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$column = column;
    final lOther$column = other.column;
    if (l$column != lOther$column) {
      return false;
    }
    final l$order = order;
    final lOther$order = other.order;
    if (l$order != lOther$order) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$column = column;
    final l$order = order;
    return Object.hashAll([
      l$column,
      l$order,
    ]);
  }
}

abstract class CopyWith$Input$OrderByClause<TRes> {
  factory CopyWith$Input$OrderByClause(
    Input$OrderByClause instance,
    TRes Function(Input$OrderByClause) then,
  ) = _CopyWithImpl$Input$OrderByClause;

  factory CopyWith$Input$OrderByClause.stub(TRes res) =
      _CopyWithStubImpl$Input$OrderByClause;

  TRes call({
    String? column,
    Enum$SortOrder? order,
  });
}

class _CopyWithImpl$Input$OrderByClause<TRes>
    implements CopyWith$Input$OrderByClause<TRes> {
  _CopyWithImpl$Input$OrderByClause(
    this._instance,
    this._then,
  );

  final Input$OrderByClause _instance;

  final TRes Function(Input$OrderByClause) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? column = _undefined,
    Object? order = _undefined,
  }) =>
      _then(Input$OrderByClause._({
        ..._instance._$data,
        if (column != _undefined && column != null)
          'column': (column as String),
        if (order != _undefined && order != null)
          'order': (order as Enum$SortOrder),
      }));
}

class _CopyWithStubImpl$Input$OrderByClause<TRes>
    implements CopyWith$Input$OrderByClause<TRes> {
  _CopyWithStubImpl$Input$OrderByClause(this._res);

  TRes _res;

  call({
    String? column,
    Enum$SortOrder? order,
  }) =>
      _res;
}

enum Enum$OrderByRelationAggregateFunction { COUNT, $unknown }

String toJson$Enum$OrderByRelationAggregateFunction(
    Enum$OrderByRelationAggregateFunction e) {
  switch (e) {
    case Enum$OrderByRelationAggregateFunction.COUNT:
      return r'COUNT';
    case Enum$OrderByRelationAggregateFunction.$unknown:
      return r'$unknown';
  }
}

Enum$OrderByRelationAggregateFunction
    fromJson$Enum$OrderByRelationAggregateFunction(String value) {
  switch (value) {
    case r'COUNT':
      return Enum$OrderByRelationAggregateFunction.COUNT;
    default:
      return Enum$OrderByRelationAggregateFunction.$unknown;
  }
}

enum Enum$OrderByRelationWithColumnAggregateFunction {
  AVG,
  MIN,
  MAX,
  SUM,
  COUNT,
  $unknown
}

String toJson$Enum$OrderByRelationWithColumnAggregateFunction(
    Enum$OrderByRelationWithColumnAggregateFunction e) {
  switch (e) {
    case Enum$OrderByRelationWithColumnAggregateFunction.AVG:
      return r'AVG';
    case Enum$OrderByRelationWithColumnAggregateFunction.MIN:
      return r'MIN';
    case Enum$OrderByRelationWithColumnAggregateFunction.MAX:
      return r'MAX';
    case Enum$OrderByRelationWithColumnAggregateFunction.SUM:
      return r'SUM';
    case Enum$OrderByRelationWithColumnAggregateFunction.COUNT:
      return r'COUNT';
    case Enum$OrderByRelationWithColumnAggregateFunction.$unknown:
      return r'$unknown';
  }
}

Enum$OrderByRelationWithColumnAggregateFunction
    fromJson$Enum$OrderByRelationWithColumnAggregateFunction(String value) {
  switch (value) {
    case r'AVG':
      return Enum$OrderByRelationWithColumnAggregateFunction.AVG;
    case r'MIN':
      return Enum$OrderByRelationWithColumnAggregateFunction.MIN;
    case r'MAX':
      return Enum$OrderByRelationWithColumnAggregateFunction.MAX;
    case r'SUM':
      return Enum$OrderByRelationWithColumnAggregateFunction.SUM;
    case r'COUNT':
      return Enum$OrderByRelationWithColumnAggregateFunction.COUNT;
    default:
      return Enum$OrderByRelationWithColumnAggregateFunction.$unknown;
  }
}

enum Enum$SortOrder { ASC, DESC, $unknown }

String toJson$Enum$SortOrder(Enum$SortOrder e) {
  switch (e) {
    case Enum$SortOrder.ASC:
      return r'ASC';
    case Enum$SortOrder.DESC:
      return r'DESC';
    case Enum$SortOrder.$unknown:
      return r'$unknown';
  }
}

Enum$SortOrder fromJson$Enum$SortOrder(String value) {
  switch (value) {
    case r'ASC':
      return Enum$SortOrder.ASC;
    case r'DESC':
      return Enum$SortOrder.DESC;
    default:
      return Enum$SortOrder.$unknown;
  }
}

enum Enum$Trashed { ONLY, WITH, WITHOUT, $unknown }

String toJson$Enum$Trashed(Enum$Trashed e) {
  switch (e) {
    case Enum$Trashed.ONLY:
      return r'ONLY';
    case Enum$Trashed.WITH:
      return r'WITH';
    case Enum$Trashed.WITHOUT:
      return r'WITHOUT';
    case Enum$Trashed.$unknown:
      return r'$unknown';
  }
}

Enum$Trashed fromJson$Enum$Trashed(String value) {
  switch (value) {
    case r'ONLY':
      return Enum$Trashed.ONLY;
    case r'WITH':
      return Enum$Trashed.WITH;
    case r'WITHOUT':
      return Enum$Trashed.WITHOUT;
    default:
      return Enum$Trashed.$unknown;
  }
}

const possibleTypesMap = <String, Set<String>>{};
