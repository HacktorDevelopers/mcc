import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mcc/pages/dashboard_two.dart';
import 'package:mcc/pages/login.dart';
import 'package:mcc/utils/constants.dart';
import 'package:mcc/utils/page_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  String _email;
  String _password;
  bool loggingIn = false;
  bool loading = true;

  set _setIsLoading(bool status) {
    loading = status;
    print(loading);
    notifyListeners();
  }

  void login({context, String email, String password}) async {
    _setIsLoading = true;
    bool _loginDone = false;
    String msg = '';
    if (email.length == 0 && password.length == 0) {
      msg = 'All Fields are required!';
    } else if (email.length != 0 && password.length == 0) {
      msg = 'Password Fields is required!';
    } else if (email.length == 0 && password.length != 0) {
      msg = 'Email Fields is required!';
    } else if (email.length != 0 && !email.contains('@')) {
      msg = 'Invalid Email Address';
    } else {
      var loginCredentials = {
        "email": email,
        "password": password,
      };
      // print(loginCredentials.toString());
      try {
        http.Response response = await http.post(
          SERVER_BASE_URL + 'login_post',
          body: loginCredentials,
        );
        if (response.statusCode == 200) {
          var res = json.decode(response.body);
          if (res['status'] == true) {
            msg = res['message'].toString();
            SharedPreferences _sharefPref =
                await SharedPreferences.getInstance();
            await _sharefPref.setString(
                FIRST_NAME_KEY, res['data']['first_name']);
            await _sharefPref.setString(
                LAST_NAME_KEY, res['data']['last_name']);
            await _sharefPref.setString(EMAIL_KEY, res['data']['email']);
            await _sharefPref.setString(
                PHONE_NUMBER_KEY, res['data']['phone_number']);
            await _sharefPref.setBool(USER_ONLINE_KEY, res['status']);
            await _sharefPref.setString(USER_ID_KEY, res['data']['id']);
            await _sharefPref.setString(USER_DISPATCHES_KEY, res['stat']['td']);
            await _sharefPref.setString(
                USER_DISPATCHES_HOUSEHOLD_KEY, res['stat']['th']);
            await _sharefPref.setString(
                USER_DISPATCHES_MED_KEY, res['stat']['tm'].toString());
            await _sharefPref.setString(
                USER_DISPATCHES_TODAY_KEY, res['stat']['todayD']);
            await _sharefPref.setString(
                USER_DISPATCHES_FOOD_KEY, res['stat']['tf']);
            _loginDone = true;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DashboardTwo()));
          }
        } else {
          msg = response.body;
          print(response.statusCode);
        }
      } catch (error) {
        msg = error.toString();
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Message'),
            content: Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(msg.toString()),
                  ],
                )),
          );
        });
    _setIsLoading = false;
  }

  void recover_password({context, String email, String password}) async {
    _setIsLoading = true;
    bool _loginDone = false;
    String msg = '';
    if (email.length == 0 && password.length == 0) {
      msg = 'All Fields are required!';
    } else if (email.length != 0 && password.length == 0) {
      msg = 'Password Fields is required!';
    } else if (email.length == 0 && password.length != 0) {
      msg = 'Email Fields is required!';
    } else if (email.length != 0 && !email.contains('@')) {
      msg = 'Invalid Email Address';
    } else {
      var loginCredentials = {
        "email": email,
        "password": password,
      };
      // print(loginCredentials.toString());
      try {
        http.Response response = await http.post(
          SERVER_BASE_URL + 'volunteer/update',
          body: loginCredentials,
        );
        print(response);
        if (response.statusCode == 200) {
          var res = json.decode(response.body);
          if (res['status'] == 1) {
            msg = res['message'].toString();
            _loginDone = true;
            // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LoginPage()));
            Navigator.pushReplacement(
                context,
                FadeRoute(
                    page: ChangeNotifierProvider(
                  create: (context) => LoginNotifier(),
                  child: LoginPage(),
                )));
          } else if (res['status'] == 0) {
            msg = res['message'].toString();
          } else {
            msg = response.body;
          }
        } else {
          msg = response.body;
          print(response.statusCode);
        }
      } catch (error) {
        msg = error.toString();
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Message'),
            content: Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(msg.toString()),
                  ],
                )),
          );
        });
    _setIsLoading = false;
  }

  LoginNotifier() {
    loading = false;
  }
}
