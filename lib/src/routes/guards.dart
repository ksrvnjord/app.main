import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final auth = GetIt.I<AuthModel>();

    if (auth.client != null) {
      resolver.next(true);
    } else {
      router.push(LoginRoute(loginCallback: (isSuccess) {
        if (isSuccess) {
          resolver.next(true);
        }
      }));
    }
  }
}
