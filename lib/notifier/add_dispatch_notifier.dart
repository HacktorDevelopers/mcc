import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mcc/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDispatchNotifier extends ChangeNotifier {
  bool isLoading = true;
  List _states = [];
  List _locals = [];
  TextEditingController _street = TextEditingController();
  String _latitude;
  String _chLatitude;
  String _longitude;
  String _chLongitude;
  String _lcd;
  String _selectedState;
  TextEditingController _houseHoldName = TextEditingController();
  String _dispatch_by = '';
  TextEditingController _packages = TextEditingController();
  TextEditingController _foodPackages = TextEditingController();
  TextEditingController _houseName = TextEditingController();
  bool _isGettingLocation = true;
  String locationStatus = '';
  String _package;
  bool _showFood = false;
  bool _showMed = false;

  set _setLoading(bool status) {
    isLoading = status;
    notifyListeners();
  }

  set _setStates(List states) {
    _states = states;
    notifyListeners();
  }

  set _setLocals(List locals) {
    _locals = locals;
    notifyListeners();
  }

  set setLocationStatus(String status) {
    locationStatus = status;
    notifyListeners();
  }

  set setIsGettingLocation(bool status) {
    _isGettingLocation = status;
    notifyListeners();
  }

  set setLcd(String lcd) {
    _lcd = lcd;
    notifyListeners();
  }

  set setSelectedState(String state) {
    _selectedState = state;
    _locals = [];
    _lcd = null;
    notifyListeners();
  }

  set setPackages(String package) {
    _packages.text = package;
    notifyListeners();
  }

  set setFoodPackages(String package) {
    _foodPackages.text = package;
    notifyListeners();
  }

  set setPackage(String package) {
    _package = package;
    notifyListeners();
  }

  set setHouseHold(String houseHold) {
    _houseHoldName.text = houseHold;
    notifyListeners();
  }

  set setHouseName(String houseName) {
    _houseName.text = houseName;
    notifyListeners();
  }

  set setStreet(String street) {
    _street.text = street;
    notifyListeners();
  }

  set _setLat(String latitude) {
    _latitude = latitude;
  }

  set _setLng(String longitude) {
    _longitude = longitude;
  }

  set _setChLat(String latitude) {
    _chLatitude = latitude;
  }

  set _setChLng(String longitude) {
    _chLongitude = longitude;
  }

  set _setShowFood(bool status) {
    _showFood = status;
    notifyListeners();
  }

  set _setShowMed(bool status) {
    _showMed = status;
    notifyListeners();
  }

  String get getLcd => _lcd;
  String get getPackage => _package;
  String get getSelectedState => _selectedState;
  String get getLocationStatus => locationStatus;
  TextEditingController get getHouseHoldName => _houseHoldName;
  TextEditingController get getHouseName => _houseName;
  String get getLat => _latitude;
  String get getLng => _longitude;
  TextEditingController get getStreet => _street;
  TextEditingController get getPackages => _packages;
  TextEditingController get getFoodPackages => _foodPackages;
  bool get getIsGettingLocation => _isGettingLocation;
  bool get getShowMed => _showMed;
  bool get getShowFood => _showFood;
  StreamSubscription locationListener;
  List get getStatesG => _states;
  List get getLocalsG => _locals;

  void initialize() async {
    isLoading = true;
    clearFields();
    SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    _dispatch_by = _sharedPref.getString(USER_ID_KEY);
    getLocation();
    getStates();
    isLoading = false;
    notifyListeners();
  }

  void toogleShow(String package) {
    if (package == 'food') {
      _setShowFood = true;
      _setShowMed = false;
      _packages.text = '0';
    } else if (package == 'medicals') {
      _setShowFood = false;
      _setShowMed = true;
      _foodPackages.text = '0';
    } else if (package == 'food & medicals') {
      _setShowFood = true;
      _setShowMed = true;
    } else {
      _setShowFood = true;
      _setShowMed = true;
    }
  }

  void getStates() async {
    _setLoading = true;
    http.Response res = await http.get(SERVER_BASE_URL + 'Location/getstates');
//    print(res.statusCode);
    if (res.statusCode == 200) {
      // print(res.body);
      List statesList = json.decode(res.body);
//      statesList.forEach((f) => print(f));
      _setStates = statesList.map((f) => List.from(statesList)).toList();
//      print(statesList);
      _setLoading = false;
    }
  }

  void addNewDispatch(context) async {
    SharedPreferences _sharedPref = await SharedPreferences.getInstance();
    _setLoading = true;
    captureLatnLng();
    if (_latitude == null && _longitude == null) {
      setLocationStatus = 'Please turn on your location';
      getLocation();
    } else {
      setLocationStatus = '';
      var msg = '';
      var dispatchData = {
        "street_name": _street.text == null ? '' : _street.text,
        "house_name": _houseName.text,
        "longitude": _longitude,
        "latitude": _latitude,
        "lcda": _lcd,
        "household": _houseHoldName.text,
        "dispatched_by": _dispatch_by,
        "packages": _foodPackages.text,
        "medicals": _packages.text,
        "state": _selectedState,
        "package": _package,
      };
      print(dispatchData);
      if (_lcd == '' ||
          _lcd == null ||
          _package == '' ||
          _selectedState == '' ||
          _packages.text == '' ||
          _houseHoldName == '' ||
          _houseName == '' ||
          _street == '') {
        msg = 'All Fields are required!'
            '';
      } else {
        if (_package == 'food & medicals' &&
            ((_packages.text == '0' || _packages.text.length == 0) ||
                (_foodPackages.text == '0' ||
                    _foodPackages.text.length == 0))) {
          msg =
              'Number of food and medicals can not be 0 when food and medicals are selected';
        } else if (_package == 'medicals' &&
            (_packages.text == '0' || _packages.text.length == 0)) {
          msg = 'Number of medicals can not be 0 when medicals is selected';
        } else if (_package == 'food' &&
            (_foodPackages.text == '0' || _foodPackages.text.length == 0)) {
          msg = 'Number of food can not be 0 when food is selected';
        } else {
          try {
            http.Response response = await http
                .post(SERVER_BASE_URL + 'volunteer', body: dispatchData);
            // print('Dispatch Data: '+dispatchData.toString());
            if (response.statusCode == 200) {
              var res = json.decode(response.body);
              print(res['stat']['tm']);
              msg = res['message'];
              await _sharedPref.setString(
                  USER_DISPATCHES_KEY, res['stat']['td'].toString());
              await _sharedPref.setString(
                  USER_DISPATCHES_HOUSEHOLD_KEY, res['stat']['th'].toString());
              await _sharedPref.setString(
                  USER_DISPATCHES_FOOD_KEY, res['stat']['tf'].toString());
              await _sharedPref.setString(
                  USER_DISPATCHES_MED_KEY, res['stat']['tm'].toString());
              await _sharedPref.setString(
                  USER_DISPATCHES_TODAY_KEY, res['stat']['todayD'].toString());
              clearFields();
            } else if (response.statusCode == 404) {
              var res = json.decode(response.body);
              msg = res['message'];
            } else {
              msg = response.body;
            }
          } catch (error) {
            // print(error);
            msg = 'Http Error: ' + error.toString();
          }
        }
      }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Message'),
              content: SingleChildScrollView(
                child: Container(child: Text(msg.toString())),
              ),
            );
          });
    }
    _setLoading = false;
    notifyListeners();
  }

  void getLocation() async {
    setIsGettingLocation = true;
    print('Getting Location...');
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      print(position);
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setStreet = first.addressLine;
      _setChLat = position.latitude.toString();
      _setChLng = position.longitude.toString();
      setIsGettingLocation = false;
//      locationListener.onError((error) => setLocationStatus =
//          'Location Error! Please make sure to turn on your location');
    } catch (error) {
      print(error);
      setIsGettingLocation = false;
    } finally {
      setIsGettingLocation = false;
      notifyListeners();
    }
  }

  void getLocals(int stateId) async {
    _setLoading = true;
    http.Response res = await http
        .get(SERVER_BASE_URL + 'Location/getstateLocals/' + stateId.toString());
//    print(res.statusCode);
    if (res.statusCode == 200) {
      // print(res.body);
      List statesList = json.decode(res.body);
//      statesList.forEach((f) => print(f));
      _setLocals = statesList.map((f) => List.from(statesList)).toList();
//      print(statesList);
      _setLoading = false;
    }
  }

  void clearFields() {
    setHouseHold = '';
    setHouseName = '';
    setPackages = '0';
    setFoodPackages = '0';
    setLcd = null;
    _setLat = null;
    _setLng = null;
    notifyListeners();
  }

  AddDispatchNotifier() {
    initialize();
  }

  void captureLatnLng() {
    _setLat = _chLatitude;
    _setLng = _chLongitude;
  }
}
