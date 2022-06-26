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
        }
      }
    }
  }
''';
