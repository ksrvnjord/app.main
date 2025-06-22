import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/firestorm_filler_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler_body.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler_image.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler_title.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_move_arrows.dart';
import 'package:image_picker/image_picker.dart';

class CreateFormFiller extends StatefulWidget {
  const CreateFormFiller({
    super.key,
    required this.index,
    required this.fillerNotifier,
    required this.deleteFiller,
  });

  final int index;
  final FirestoreFormFillerNotifier fillerNotifier;
  final Function(int) deleteFiller;

  @override
  State<CreateFormFiller> createState() => _CreateFormFillerState();
}

class _CreateFormFillerState extends State<CreateFormFiller> {
  late TextEditingController fillerTitleController;
  late TextEditingController fillerBodyController;

  FirestoreFormFillerNotifier get fillerNotifier => widget.fillerNotifier;

  @override
  void initState() {
    super.initState();

    fillerTitleController = TextEditingController(text: fillerNotifier.title);
    fillerBodyController = TextEditingController(text: fillerNotifier.body);

    fillerTitleController.addListener(() {
      if (fillerNotifier.title != fillerTitleController.text) {
        fillerNotifier.title = fillerTitleController.text;
      }
    });

    fillerBodyController.addListener(() {
      if (fillerNotifier.body != fillerBodyController.text) {
        fillerNotifier.body = fillerBodyController.text;
      }
    });

    fillerNotifier.addListener(_onFillerChanged);
  }

  void _onFillerChanged() {
    setState(() {
      // Trigger rebuild when this specific filler changes
    });
  }

  @override
  void didUpdateWidget(CreateFormFiller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fillerNotifier != fillerNotifier) {
      oldWidget.fillerNotifier.removeListener(_onFillerChanged);
      fillerNotifier.addListener(_onFillerChanged);
    }
  }

  @override
  void dispose() {
    fillerNotifier.removeListener(_onFillerChanged);
    fillerTitleController.dispose();
    fillerBodyController.dispose();
    super.dispose();
  }

  void updateFillerImageProperties(XFile? image) {
    fillerNotifier.updateImage(image);
  }

  @override
  Widget build(BuildContext context) {
    final filler = fillerNotifier.value;

    return Column(children: [
      const Divider(),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: CreateFormFillerTitle(
                              controller: fillerTitleController,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () => widget.deleteFiller(filler.id),
                              child: const Text("Verwijder Info-blok"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CreateFormFillerBody(controller: fillerBodyController),
                      const SizedBox(height: 16),
                      CreateFormFillerImage(
                        initialImage: filler.image,
                        onChanged: updateFillerImageProperties,
                      ),
                    ],
                  ),
                ),
                CreateFormMoveArrows(
                  index: widget.index,
                  contentIndex: filler.id,
                ),
              ],
            ),
          ]),
        ),
      ])
    ]);
  }
}
