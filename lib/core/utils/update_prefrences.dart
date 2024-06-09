import '../../dependency_injection.dart';
import '../constants/shared_keys.dart';

void updatingPrefrences(Map<String, dynamic> response) {
  preferences.setString(SharedKeys.userId, response['id'].toString());
  preferences.setString(
      SharedKeys.name, "${response["firstName"]} ${response["lastName"]}");
  preferences.setString(SharedKeys.accessToken, response['token']);
  preferences.setString(SharedKeys.refreshToken, response['refreshToken']);
}
