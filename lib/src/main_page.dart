import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPage = TabPage.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: tabPage.controller,
            tabs: const <Tab>[
              Tab(
                icon: Icon(Icons.home_filled),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.all_inbox_rounded),
                text: 'Aankondigingen',
              ),
              Tab(
                icon: Icon(Icons.book),
                text: 'Almanak',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabPage.controller,
          children: [
            for (final stack in tabPage.stacks)
              PageStackNavigator(stack: stack),
          ],
        ),
      ),
    );
  }
}
