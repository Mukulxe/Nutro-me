import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static SharedPreferences? _preferences;

  static const _keyUserName = 'username';
  static const _keyUserEmail = 'useremail';
  static const _keyUserPhone = 'userphone';
  static const _keyPostalCode = 'postalcode';
  static const _keyHouseNo = 'houseno';
  static const _keyStreet = 'street';
  static const _keyCity = 'city';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future removeAll() async => await _preferences!.clear();

  static Future setUsername(String username) async =>
      await _preferences!.setString(_keyUserName, username);

  static String getUserName() => _preferences!.getString(_keyUserName)!;

  static Future setUserEmail(String useremail) async =>
      await _preferences!.setString(_keyUserEmail, useremail);

  static String getUserEmail() => _preferences!.getString(_keyUserEmail)!;

  static Future setUserPhone(String userphone) async =>
      await _preferences!.setString(_keyUserPhone, userphone);

  static String getUserPhone() => _preferences!.getString(_keyUserPhone)!;

  static Future setPostalCode(String postalCode) async =>
      await _preferences!.setString(_keyPostalCode, postalCode);

  static String getPostalCode() => _preferences!.getString(_keyPostalCode)!;

  static Future setHouseNo(String houseNo) async =>
      await _preferences!.setString(_keyHouseNo, houseNo);

  static String getHouseNo() => _preferences!.getString(_keyHouseNo)!;

  static Future setStreet(String street) async =>
      await _preferences!.setString(_keyStreet, street);

  static String getStreet() => _preferences!.getString(_keyStreet)!;
  static Future setCity(String city) async =>
      await _preferences!.setString(_keyCity, city);

  static String getCity() => _preferences!.getString(_keyCity)!;

  static Future setAreaAvailable(String areaAvailable) async =>
      await _preferences!.setString("availability", areaAvailable);

  static String getAreaAvailable() => _preferences!.getString("availability")!;

  static Future setPortalOpenTime(int portalOpenTime) async =>
      await _preferences!.setInt("portalOpenTime", portalOpenTime);

  static int getPortalOpenTime() => _preferences!.getInt("portalOpenTime")!;

  static Future setPortalCloseTime(int portalCloseTime) async =>
      await _preferences!.setInt("portalCloseTime", portalCloseTime);

  static int getPortalCloseTime() => _preferences!.getInt("portalCloseTime")!;
}
