const String almanakProfileQuery = r'''
  query ($profileId: ID!) {
    user (id: $profileId) {
      identifier,
      email,
      username,
      fullContact {
          public{
            first_name,
            last_name
            email,
            street,
            housenumber,
            housenumber_addition,
            city,
            zipcode,
            phone_primary,
          }
      }
    }
  }
''';
