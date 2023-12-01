import 'package:flutter/material.dart';

class CreateFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<CreateFormPage> {
  List<Map<String, dynamic>> questions = [];

  DateTime openUntil = DateTime.now();
  String? description;
  String formName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Form Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Formulier naam',
            ),
            onFieldSubmitted: (String value) => formName = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Beschrijving form',
            ),
            onFieldSubmitted: (String value) => description = value,
          ),
          SizedBox(
            height: 16,
          ),
          InputDatePickerFormField(
            fieldLabelText: 'Open tot',
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateSubmitted: (DateTime selectedDate) {
              openUntil = selectedDate;
            },
          ),
          ...questions.map((label) {
            return Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Question',
                  ),
                  onChanged: (String value) {
                    // You can handle the changes in each TextFormField here
                  },
                ),
                DropdownButton<String>(
                  value: label['type'],
                  onChanged: (String? newValue) {
                    setState(() {
                      label['type'] = newValue!;
                    });
                    // You can handle the changes in the dropdown selection here
                  },
                  items: <String>['Single Select', 'Text']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                questions.add({
                  'label': '', // Add an empty label for the new TextFormField
                  'type': 'Single Select',
                }); // Add an empty label for the new TextFormField
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
                




// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
// import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
// import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
// import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
// import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_question.dart';
// import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
// import 'package:styled_widget/styled_widget.dart';

// class CreateFormPage extends ConsumerWidget {
//   // Constructor which takes a String formId.
//   // const FormPage({Key? key, required this.formId}) : super(key: key);

//   // final String formId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     String formName;
//     DateTime openUntil;
//     String? description;

//     final List<FirestoreFormQuestion> questions = [
//       // final String label;
//       // final FormQuestionType type;
//       // final List<String>? options;
//     ];

//     List<CreateFormQuestion> formQuestions = [];

//     List<Widget> generalQuestions = [
//       TextFormField(
//         decoration: const InputDecoration(
//           labelText: 'Formulier naam',
//         ),
//         onFieldSubmitted: (String value) => formName = value,
//       ),
//       TextFormField(
//         decoration: const InputDecoration(
//           labelText: 'Beschrijving form',
//         ),
//         onFieldSubmitted: (String value) => description = value,
//       ),
//       Text(""),
//       InputDatePickerFormField(
//         fieldLabelText: 'Open tot',
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100),
//         onDateSubmitted: (DateTime selectedDate) {
//           openUntil = selectedDate;
//         },
//       ),
//     ];

//     List<String> questionLabels = [];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Form aanmaken'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           ...generalQuestions,
//           ElevatedButton(
//             onPressed: () {
//               questionLabels
//                   .add(""); // Add an empty label for the new TextFormField
//             },
//             child: Icon(Icons.add),
//           ),
//           // Create a list of TextFormField based on questionLabels
//           Column(
//             children: questionLabels.map((label) {
//               return TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Question',
//                 ),
//                 onChanged: (String value) {
//                   // You can handle the changes in each TextFormField here
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
