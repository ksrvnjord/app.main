import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_filler.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler_body.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler_image.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_filler_title.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_move_arrows.dart';
import 'package:image_picker/image_picker.dart';

class CreateFormFiller extends ConsumerStatefulWidget {
  const CreateFormFiller({
    super.key,
    required this.index,
    required this.filler,
    required this.onChanged,
    required this.deleteFiller,
  });

  final int index;
  final FirestoreFormFiller filler;
  final VoidCallback onChanged;
  final Function(int) deleteFiller;

  @override
  ConsumerState<CreateFormFiller> createState() => _CreateFormFillerState();
}

class _CreateFormFillerState extends ConsumerState<CreateFormFiller> {
  late TextEditingController fillerTitleController;
  late TextEditingController fillerBodyController;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    fillerTitleController = TextEditingController(text: widget.filler.title);
    fillerBodyController = TextEditingController(text: widget.filler.body);

    fillerTitleController.addListener(() {
      if (widget.filler.title != fillerTitleController.text) {
        widget.filler.title = fillerTitleController.text;
        widget.onChanged();
      }
    });

    fillerBodyController.addListener(() {
      if (widget.filler.body != fillerBodyController.text) {
        widget.filler.body = fillerBodyController.text;
        widget.onChanged();
      }
    });
  }

  @override
  void didUpdateWidget(CreateFormFiller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filler.title != widget.filler.title) {
      fillerTitleController.text = widget.filler.title;
    }
    if (oldWidget.filler.body != widget.filler.body) {
      fillerBodyController.text = widget.filler.body;
    }
  }

  @override
  void dispose() {
    fillerTitleController.dispose();
    fillerBodyController.dispose();
    super.dispose();
  }

  void updateFillerImageProperties(XFile? image) {
    image == null
        ? widget.filler.hasImage = false
        : widget.filler.hasImage = true;
    widget.filler.image = image;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(),
      const SizedBox(
        height: 16,
      ),
      Row(children: [
        Expanded(
            child: Column(children: [
          // Title
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Title
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: CreateFormFillerTitle(
                              controller: fillerTitleController),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            onPressed: () =>
                                widget.deleteFiller(widget.filler.id),
                            child: const Text("Verwijder Info-blok"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Body
                    CreateFormFillerBody(controller: fillerBodyController),

                    const SizedBox(height: 16),
                    CreateFormFillerImage(
                      initialImage: widget.filler.image,
                      onChanged: updateFillerImageProperties,
                    ),
                  ],
                ),
              ),
              CreateFormMoveArrows(
                index: widget.index,
                contentIndex: widget.filler.id,
              ),
            ],
          ),
        ]))
      ])
    ]);
  }
}
