import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class FillCommissieInfoPage extends StatefulWidget {
  const FillCommissieInfoPage({Key? key, required this.commissie})
      : super(key: key);

  final String commissie;

  @override
  FillCommissieInfoPageState createState() => FillCommissieInfoPageState();
}

class FillCommissieInfoPageState extends State<FillCommissieInfoPage> {
  // create a form key to identify the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // generate a list of years from 1726 to now
    final List<int> years =
        List.generate(DateTime.now().year - 1726, (index) => index + 1726)
            .toList();

    const double saveButtonVerticalPadding = 8;
    const double formPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vul commissie info in'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            DataTextListTile(name: "Commissie", value: widget.commissie),
            // create a year picker field that lets user select a year
            DropdownButtonFormField(
              // make this field required
              decoration: const InputDecoration(
                labelText: "Wanneer ben je begonnen?\*",
                hintText: 'Selecteer je beginjaar',
              ),
              validator: (value) =>
                  value == null ? 'Dit veld is verplicht' : null,
              items: years
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      ))
                  .toList(),
              onChanged: (_) => {},
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: "Wanneer ben je gestopt?",
                hintText: 'Selecteer je eindjaar',
                helperText: "Laat leeg als je nog steeds in de commissie zit",
              ),
              items: years
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      ))
                  .toList(),
              onChanged: (_) => {},
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Vervulde je een functie binnen de commissie?',
                hintText: 'Praeses, Abactis, etc.',
                helperText: "Kan je ook leeg laten",
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onPressed: () => submitForm(),
              child: const Text('Opslaan'),
            ).padding(vertical: saveButtonVerticalPadding),
          ],
        ),
      ).padding(all: formPadding),
    );
  }

  // function that submits the form
  void submitForm() {
    // save the form state
    _formKey.currentState?.save();
  }
}
