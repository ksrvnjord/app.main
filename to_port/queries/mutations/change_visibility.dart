const String changeVisibilityMutation = '''
  mutation UpdateVisibility(\$listed: Boolean!, \$contact: IBooleanContact!) {
  toggleListed(state: \$listed)
  updatePublicContact(contact: \$contact) {
    first_name
    last_name
    email
    street
    housenumber
    housenumber_addition
    city
    zipcode
    phone_primary
  }
}
''';
