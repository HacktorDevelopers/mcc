import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mcc/notifier/login_notifier.dart';
import 'package:mcc/pages/login.dart';
import 'package:mcc/utils/constants.dart';
import 'package:mcc/utils/page_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  bool _isLoggedIn;
  SharedPreferences _sharedPref;
  String _userFirstName = 'First Name';
  String _userLastName = 'Last Name';
  String _userEmail = 'email@domain.com';
  String _userPassword;
  String _userPhone = '08066682929';
  String _dipatches = '0';
  bool loading = true;

  String _statFood = '0';
  String _statMed = '0';
  String _statHouse = '0';
  String _statToday = '0';

  bool get userIsLoggedIn => _isLoggedIn;
  String get getUserDispatches => _dipatches;
  String get getUserFirstName => _userFirstName;
  String get getUserLastName => _userLastName;
  String get getUserPhone => _userPhone;
  String get getUserEmail => _userEmail;
  String get getUserStatFood => _statFood;
  String get getUserStatMed => _statMed;
  String get getUserStatHouse => _statHouse;
  String get getUserStatToday => _statToday;

  set _userIsLoggedIn(bool status) => _isLoggedIn = status;
  set _setUserDispatches(String dispatches) => _dipatches = dispatches;
  set _setUserFirstName(String name) => _userFirstName = name;
  set _setUserLastName(String name) => _userLastName = name;
  set _setUserPhone(String phone) => _userPhone = phone;
  set _setUserEmail(String email) => _userEmail = email;

  set _setUserStatHouse(String statHouse) => _statHouse = statHouse;
  set _setUserStatMed(String statMed) => _statMed = statMed;
  set _setUserStatToday(String statToday) => _statToday = statToday;
  set _setUserStatFood(String statFood) => _statFood = statFood;

  void logout(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Message'),
              content: Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                child: Column(
                  children: <Widget>[
                    Text('Do you want to logout?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                          elevation: 2,
                          color: Colors.green,
                          onPressed: () async {
                            SharedPreferences _sharedPref =
                                await SharedPreferences.getInstance();
                            await _sharedPref.setBool(USER_ONLINE_KEY, false);

                            Navigator.of(context).pushReplacement(FadeRoute(
                                page: ChangeNotifierProvider(
                                    create: (context) => LoginNotifier(),
                                    child: LoginPage())));
                          },
                          child: Text('Yes'),
                        ),
                        MaterialButton(
                          elevation: 2,
                          color: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  void init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  void initialize() async {
    _userIsLoggedIn = _sharedPref.getBool(USER_ONLINE_KEY) ?? false;
    _setUserDispatches = _sharedPref.getString(USER_DISPATCHES_KEY) ?? getUserDispatches;
    _setUserFirstName = _sharedPref.getString(FIRST_NAME_KEY) ?? getUserFirstName;
    _setUserLastName = _sharedPref.getString(LAST_NAME_KEY) ?? getUserLastName;
    _setUserEmail = _sharedPref.getString(EMAIL_KEY) ?? getUserEmail;
    _setUserPhone = _sharedPref.getString(PHONE_NUMBER_KEY) ?? getUserPhone;

    _setUserStatFood = _sharedPref.getString(USER_DISPATCHES_FOOD_KEY) ?? getUserStatFood;
    _setUserStatMed = _sharedPref.getString(USER_DISPATCHES_MED_KEY) ?? getUserStatMed;
    _setUserStatToday = _sharedPref.getString(USER_DISPATCHES_TODAY_KEY) ?? getUserStatToday;
    _setUserStatHouse = _sharedPref.getString(USER_DISPATCHES_HOUSEHOLD_KEY) ?? getUserStatHouse;
    loading = false;
    notifyListeners();
  }

  void update() async {
    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      initialize();
    });
  }

  UserNotifier() {
    init();
    initialize();
    update();
  }
}
