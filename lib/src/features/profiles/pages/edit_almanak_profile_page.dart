import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';

class EditAlmanakProfilePage extends StatefulWidget {
  const EditAlmanakProfilePage({Key? key}) : super(key: key);

  @override
  createState() => _EditAlmanakProfilePageState();
}

class _EditAlmanakProfilePageState extends State<EditAlmanakProfilePage> {
  var _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wijzig mijn almanak profiel'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Center(
        child: Column(
      children: [
        // Display the selected profile picture, or a placeholder if no picture has been selected
        _selectedFile != null
            ? Image.file(_selectedFile)
            : Image.asset(Images.placeholderProfilePicture),
        MaterialButton(
          onPressed: () async {
            // Open a file picker dialog
            _selectedFile = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: false
            );
            // Update the UI to show the selected profile picture
            setState(() {});
          },
          color: Colors.lightBlue,
          textColor: Colors.white,
          child: const Text('Kies foto'),
        ),
      ],
    ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to save the profile changes goes here
        },
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
