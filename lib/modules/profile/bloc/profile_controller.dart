import 'package:disposable_provider/disposable_provider.dart';
import 'package:ed_tech/data/services/user_service.dart';

class ProfileController extends Disposable {
  ProfileController();

  UserData? get userData => UserService.instance.userData;

  @override
  void dispose() {}
}
