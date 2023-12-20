

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CreateFormQuestion extends ConsumerWidget {
//     const CreateFormQuestion({
//     Key? key,
//     required this.formQuestion,
//     required this.formPath,
//     required this.form,
//     required this.docRef,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final textTheme = Theme.of(context).textTheme;

//     final type = formQuestion.type;

//     final List<Widget> questionWidgets = [
//       TextFormField(
//         formQuestion.label,
//         style: textTheme.titleLarge,
//       ),
//     ];

//     switch (type) {
//       case FormQuestionType.text:
//         questionWidgets.add(
//           TextFormField(
//             onFieldSubmitted: (String value) => {
//               FormRepository.upsertFormAnswer(
//                 newValue: value,
//                 question: formQuestion.label,
//                 form: form,
//                 docRef: docRef,
//                 ref: ref,
//               ),
//             },
//           ),
//         );
//         break;
//       case FormQuestionType.singleChoice:
//         questionWidgets.add(SingleChoiceWidget(
//           initialValue: null,
//           formQuestion: formQuestion,
//           form: form,
//           docRef: docRef,
//           ref: ref,
//           onChanged: (String? value) => FormRepository.upsertFormAnswer(
//             newValue: value,
//             question: formQuestion.label,
//             docRef: docRef,
//             form: form,
//             ref: ref,
//           ),
//         ));
//         break;
//       default:
//         return const ErrorCardWidget(
//           errorMessage: 'Onbekend type vraag',
//         );
//     }

//     return questionWidgets.toColumn(
//       crossAxisAlignment: CrossAxisAlignment.start,
//     );
//   }
// }