import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class EditAlmanakForm extends StatefulWidget {
  const EditAlmanakForm({Key? key}) : super(key: key);

  @override
  createState() => _EditAlmanakFormState();
}

class _EditAlmanakFormState extends State<EditAlmanakForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const double fieldPadding = 8;

    return Form(
      key: _formKey,
      child: <Widget>[
        // create a field to enter Field of Study
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Studie',
            hintText: 'Wat studeer je?',
          ),
        ),
        DropdownButtonFormField(
          hint: const Text('Welk boord?'),
          items: const [
            DropdownMenuItem(value: 'Bakboord', child: Text('Bakboord')),
            DropdownMenuItem(value: 'Stuurboord', child: Text('Stuurboord')),
            DropdownMenuItem(value: 'Scull', child: Text('Scull')),
            DropdownMenuItem(value: 'Multiboord', child: Text('Multiboord')),
          ],
          onChanged: (_) => {},
        ).padding(vertical: fieldPadding),
        // Add button to submit form
        ElevatedButton(
          onPressed: submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          child: const Text('Opslaan'),
        ),
      ].toColumn(),
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }
}
