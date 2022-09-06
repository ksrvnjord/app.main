const String meQuery = r'''
  query {
    me {
      identifier,
      email,
      username,
      fullContact {
          private{
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
        update{
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
