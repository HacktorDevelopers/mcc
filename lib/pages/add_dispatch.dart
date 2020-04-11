import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:mcc/notifier/add_dispatch_notifier.dart';
import 'package:mcc/utils/constants.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';

class DispatchScreen extends StatefulWidget {
  @override
  _DispatchScreenState createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  @override
  Widget build(BuildContext context) {
    AddDispatchNotifier _addDispatchNotifier =
        Provider.of<AddDispatchNotifier>(context);
    // setState(() => );
    // _addDispatchNotifier.getLocation();
    return Scaffold(
      backgroundColor: Colors.transparent,
      persistentFooterButtons: buildSupportTeam(context),
      body: Hero(
        tag: 'add',
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.transparent,
            color: Colors.white,
            // backgroundBlendMode: BlendMode.difference,
          ),
          margin: EdgeInsets.only(top: 16),
          child: Column(
            children: <Widget>[
              buildAppBar(title: Image.asset('assets/images/logo.png')),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.orangeAccent,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add New Dispatch',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              Expanded(
                child: Stack(children: [
                  Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _noti.getHouseName,
                                    // initialValue: _noti.getHouseName.text,
                                    decoration: _buildInputDecoration(
                                        hint: 'House Name'),
                                  ),
                                );
                              }),
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _noti.getHouseHoldName,
                                    keyboardType: TextInputType.number,
                                    // initialValue: _noti.getHouseHoldName.text,
                                    decoration: _buildInputDecoration(
                                        hint: 'Number of Household'),
                                  ),
                                );
                              }),
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropDownFormField(
                                    titleText: 'Package Delivered',
                                    hintText: 'Select Delivered Package',
                                    value: _noti.getPackage,
                                    onSaved: (value) {
                                      _noti.setPackage = value;
                                    },
                                    onChanged: (value) {
                                      _noti.setPackage = value;
                                      _noti.toogleShow(value);
                                    },
                                    dataSource: PACKAGES,
                                    textField: 'display',
                                    valueField: 'value',
                                  ),
                                );
                              }),
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return _noti.getShowFood
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _noti.getFoodPackages,
                                          keyboardType: TextInputType.number,
                                          decoration: _buildInputDecoration(
                                              hint:
                                                  'Number of food package delivered'),
                                        ),
                                      )
                                    : Container();
                              }),
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return _noti.getShowMed
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _noti.getPackages,
                                          keyboardType: TextInputType.number,
                                          decoration: _buildInputDecoration(
                                              hint:
                                                  'Number of medical package delivered'),
                                        ),
                                      )
                                    : Container();
                              }),
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _noti.getStatesG.length == 0
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : DropDownFormField(
                                          titleText: 'State',
                                          hintText: 'Please Choose State',
                                          value: _noti.getSelectedState,
                                          onSaved: (value) {
                                            _noti.setSelectedState = value;
                                          },
                                          onChanged: (value) {
                                            _noti.getLocals(int.parse(value));
                                            print(value);
                                            _noti.setSelectedState = value;
                                          },
                                          dataSource:
                                              _noti.getStatesG.length > 0
                                                  ? _noti.getStatesG[0]
                                                  : [],
                                          textField: 'name',
                                          valueField: 'id',
                                        ),
                                );
                              }),
                              Consumer<AddDispatchNotifier>(
                                  builder: (context, _noti, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropDownFormField(
                                    titleText: 'LCDA',
                                    hintText: 'Please Choose LGA',
                                    value: _noti.getLcd,
                                    onSaved: (value) {
                                      _noti.setLcd = value;
                                    },
                                    onChanged: (value) {
                                      _noti.setLcd = value;
                                    },
                                    dataSource: _noti.getLocalsG.length > 0
                                        ? _noti.getLocalsG[0]
                                        : [],
                                    textField: 'local_name',
                                    valueField: 'local_id',
                                  ),
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Consumer<AddDispatchNotifier>(
                                        builder: (context, _noti, child) {
                                      return _noti.getIsGettingLocation
                                          ? Text('Getting Location...')
                                          : TextFormField(
                                              controller: _noti.getStreet,
                                              maxLines: 4,
                                              decoration: _buildInputDecoration(
                                                  hint: 'Street Name'),
                                            );
                                    }),
                                    Consumer<AddDispatchNotifier>(
                                        builder: (context, _noti, child) {
                                      return Text(_noti.getLocationStatus);
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(20, 20)),
                                  elevation: 2,
                                  color: Colors.orangeAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      splashColor: Colors.brown,
                                      onTap: () => _addDispatchNotifier
                                          .addNewDispatch(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Save Record',
                                              style: TextStyle(
                                                  color: Colors.brown.shade700,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 25)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  (_addDispatchNotifier.isLoading == true)
                      ? Container(
                          color: Colors.greenAccent.withOpacity(0.2),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ))
                      : Container()
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _buildInputDecoration({hint}) {
  return InputDecoration(
    border: OutlineInputBorder(),
    hintText: hint.toString(),
    labelText: hint,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(),
    focusColor: Colors.white,
  );
}
