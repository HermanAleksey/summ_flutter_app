import 'package:summ_flutter_app/entity/Role.dart';

import 'entity/User.dart';

class CurrentUser {
  CurrentUser._privateConstructor();

  static final CurrentUser _instance = CurrentUser._privateConstructor();

  factory CurrentUser() {
    return _instance;
  }

  static User user = new User(roles: ["GUEST"]);
}
