const String changeVisibilityQuery = r'''
  query {
    me {
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
            phone_primary
        }
      }
    }
  }
''';
