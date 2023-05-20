import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/current_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

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

  CommissieEntry _formData = CommissieEntry(
    startYear: DateTime.now().year - 1,
    endYear: DateTime.now().year,
    firstName: GetIt.I<CurrentUser>().user!.fullContact.public.first_name!,
    lastName: GetIt.I<CurrentUser>().user!.fullContact.public.last_name!,
    identifier: FirebaseAuth.instance.currentUser!.uid,
    name: "",
  );

  @override
  void initState() {
    _formData = _formData.copyWith(name: widget.commissie);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const int startYear = 1874;
    final List<Tuple2<int, int>> years = List.generate(
      DateTime.now().year - startYear,
      (index) => Tuple2<int, int>(
        // '2022-2023', '2021-2022', ...
        DateTime.now().year - index - 1,
        DateTime.now().year - index,
      ),
    ).toList();

    const double saveButtonVerticalPadding = 8;
    const double formPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vul commissie info in'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
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
              items: years
                  .map((tuple) => DropdownMenuItem(
                        value: tuple,
                        child: Text("${tuple.item1}-${tuple.item2}"),
                      ))
                  .toList(),
              onChanged: (_) => {},
              decoration: const InputDecoration(
                labelText: "Welk jaar?*",
                hintText: 'Selecteer je commissiejaar',
              ),
              onSaved: (newValue) => {
                if (newValue != null)
                  {
                    _formData.startYear = newValue.item1,
                    _formData.endYear = newValue.item2,
                  },
              },
              validator: (value) =>
                  value == null ? 'Dit veld is verplicht' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Vervulde je een functie binnen de commissie?',
                helperText: "Kan je ook leeg laten",
                hintText: 'Praeses, Abactis, etc.',
              ),
              onSaved: (newValue) => newValue != null && newValue.isNotEmpty
                  ? _formData.function = newValue
                  : null,
            ),
            ElevatedButton(
              onPressed: () => submitForm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
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
          content: Text('Er is iets fout gegaan met het opslaan'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Je commissie is opgeslagen'),
          backgroundColor: Colors.green,
        ),
      );
      Routemaster.of(context)
          .replace('/almanak/edit/commissies'); // go to overzicht of commissies
    }
  }
}
