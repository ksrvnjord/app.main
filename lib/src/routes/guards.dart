import 'package:auto_route/auto_route.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.gr.dart';
import 'package:provider/provider.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;
    final auth = context!.read<AuthModel>();

    if (auth.client != null) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
