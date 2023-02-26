import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';

class FillCommissieInfoPage extends StatefulWidget {
  const FillCommissieInfoPage({Key? key}) : super(key: key);

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
            const Text('Wanneer ben je begonnen?').fontSize(16),
            // create a year picker field that lets user select a year
            DropdownButtonFormField(
              // make this field required
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
            const Text('Wanneer ben je gestopt?'),
            DropdownButtonFormField(
              items: years
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      ))
                  .toList(),
              onChanged: (_) => {},
            ),
            const Text('Had je een bepaalde functie binnen de commissie?'),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Praeses, Abactis, etc.',
              ),
            ),
            ElevatedButton(
              onPressed: () => submitForm(),
              child: const Text('Opslaan'),
            ),
          ],
        ),
      ).padding(all: 8),
    );
  }

  // function that submits the form
  void submitForm() {
    // save the form state
    _formKey.currentState?.save();
  }
}
