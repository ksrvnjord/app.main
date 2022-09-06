import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/pages/login_page.dart';
import 'package:ksrvnjord_main_app/src/graphql_wrapper.dart';
import 'package:provider/provider.dart';

class _Routes extends StatelessWidget {
  const _Routes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ApplicationRouter extends StatelessWidget {
  const ApplicationRouter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(builder: ((context, value, child) {
      if (value.client != null) {
        return const GraphQLWrapper(child: _Routes());
      }

      return const LoginPage();
    }));
  }
}
