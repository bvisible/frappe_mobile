import 'package:frappe_app/model/config.dart';
import 'package:stacked/stacked.dart';
import 'package:frappe_app/app/app.locator.dart';
import 'package:frappe_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  Future runStartupLogic() async {
    if (Config().isLoggedIn) {
      _navigationService.replaceWithHomeView();
    } else {
      _navigationService.navigateToLoginView();
    }
  }
}
