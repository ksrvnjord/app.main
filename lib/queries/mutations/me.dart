String meMutation = '''
      mutation (\$contact: IContact!){
        updateContactDetails(contact: \$contact) {
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
      ''';
