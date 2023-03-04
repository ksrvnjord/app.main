import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:routemaster/routemaster.dart';
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

  final CommissieEntry _formData =
      CommissieEntry(name: "", startYear: DateTime.now().year);

  @override
  void initState() {
    _formData.name = widget.commissie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const int startYear = 1874;
    final List<int> years = List.generate(
      // create a list from current year to startYear
      DateTime.now().year - startYear + 1,
      (index) => DateTime.now().year - index,
    ).toList();

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
                // The asterisk is a hint to the user that this field is required
                // ignore: unnecessary_string_escapes
                labelText: "Wanneer ben je begonnen?\*",
                hintText: 'Selecteer je beginjaar',
              ),
              validator: (value) =>
                  value == null ? 'Dit veld is verplicht' : null,
              onSaved: (newValue) =>
                  newValue != null ? _formData.startYear = newValue : null,
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
              onSaved: (newValue) =>
                  newValue != null ? _formData.endYear = newValue : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Vervulde je een functie binnen de commissie?',
                hintText: 'Praeses, Abactis, etc.',
                helperText: "Kan je ook leeg laten",
              ),
              onSaved: (newValue) =>
                  newValue != null ? _formData.function = newValue : null,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onPressed: () => submitForm(context),
              child: const Text('Opslaan'),
            ).padding(vertical: saveButtonVerticalPadding),
          ],
        ),
      ).padding(all: formPadding),
    );
  }

  // function that submits the form
  void submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // don't submit if form is invalid
      return;
    }
    _formKey.currentState?.save();

    try {
      await addMyCommissie(_formData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Er is iets fout gegaan met het opslaan'),
        ),
      );

      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Je commissie is opgeslagen'),
        ),
      );
      Routemaster.of(context)
          .replace('/almanak/edit/commissies'); // go to overzicht of commissies
    }
  }
}
