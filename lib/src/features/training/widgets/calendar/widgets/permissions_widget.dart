import 'package:flutter/material.dart';

class PermissionsWidget extends StatelessWidget {
  const PermissionsWidget({
    super.key,
    required this.permissions,
  });

  final List<String> permissions;

  @override
  Widget build(BuildContext context) {
    const double permissionChipSpacing = 4;

    Map<String, Color> permissionColors = {
      'Coachcatamaran': Colors.greenAccent,
      'Speciaal': Colors.redAccent,
      '1e permissie': Colors.blueAccent,
      '2e permissie': Colors.orangeAccent,
      'Top C4+': Colors.purpleAccent,
      'Specifiek': Colors.pinkAccent,
    };

    return ListTile(
      title: const Text(
        'Permissies',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Wrap(
        spacing: permissionChipSpacing,
        children: permissions
            .map((permission) => Chip(
                  label: Text(
                    permission,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: () {
                    if (permissionColors.containsKey(permission)) {
                      return permissionColors[permission];
                    } else {
                      return Colors.grey;
                    }
                  }(),
                ))
            .toList(),
      ),
    );
  }
}
