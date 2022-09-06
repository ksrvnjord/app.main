const String changeVisibilityQuery = r'''
  query {
    me {
      fullContact {
          privacy{
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
      listed
    }
  }
''';
