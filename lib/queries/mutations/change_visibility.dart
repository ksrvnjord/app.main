const String changeVisibilityMutation = '''
  mutation ToggleListed(\$listed: Boolean!) {
  toggleListed(state: \$listed)
}
''';
