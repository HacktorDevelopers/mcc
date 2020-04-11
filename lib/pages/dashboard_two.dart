import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcc/notifier/add_dispatch_notifier.dart';
import 'package:mcc/notifier/user_notifier.dart';
import 'package:mcc/utils/assets.dart';
import 'package:mcc/utils/page_routes.dart';
import 'package:provider/provider.dart';

import 'add_dispatch.dart';

class DashboardTwo extends StatelessWidget {
  static final String path = "lib/src/pages/dashboard/dash3.dart";
  final String avatar = avatars[0];
  final TextStyle whiteText = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    UserNotifier _userNotifier = Provider.of<UserNotifier>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          color: Colors.blue,
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Hero(
            tag: 'add',
            child: _buildButton(
              Icons.add,
              iconSize: 20.0,
              color: Colors.white,
              onClick: () {
                Navigator.of(context).push(FadeRoute(
                    page: ChangeNotifierProvider(
                        create: (context) => AddDispatchNotifier(),
                        child: DispatchScreen())));
              },
            ),
          ),
        ),
      ],
    );
  }

  IconButton _buildButton(IconData icon,
      {Color color, onClick, iconSize = 20.0}) {
    return IconButton(
      onPressed: onClick,
      icon: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    UserNotifier _userNotifier = Provider.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Statistics",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          Card(
            elevation: 4.0,
            color: Colors.white,
            margin: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    leading: Container(
                      alignment: Alignment.bottomCenter,
                      width: 45.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 20,
                            width: 8.0,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            height: 25,
                            width: 8.0,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            height: 40,
                            width: 8.0,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4.0),
                          Container(
                            height: 30,
                            width: 8.0,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                    title: Text("Today"),
                    subtitle:
                        Text(_userNotifier.getUserStatToday + " Dispatched"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: _buildTile(
                    color: Colors.orange,
                    icon: Icons.card_giftcard,
                    title: "Number of Dispatch",
                    data: _userNotifier.getUserDispatches,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildTile(
                    color: Colors.green,
                    icon: Icons.home,
                    title: "Households",
                    data: _userNotifier.getUserStatHouse,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildTile(
                    color: Colors.red,
                    icon: Icons.favorite,
                    title: "Medicals",
                    data: _userNotifier.getUserStatMed,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildTile(
                    color: Colors.yellow,
                    icon: Icons.fastfood,
                    title: "Food",
                    data: _userNotifier.getUserStatFood,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    UserNotifier _userNotifier = Provider.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              "Dashboard",
              style: whiteText.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            trailing: CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage('assets/images/logo2.png')),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: ListTile(
              title: Text(
                _userNotifier.getUserFirstName +
                    ' ' +
                    _userNotifier.getUserLastName,
                style: whiteText.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _userNotifier.getUserEmail ?? '08066682929',
                style: whiteText,
              ),
              trailing: Material(
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(200)),
                child: _buildButton(
                  Icons.exit_to_app,
                  color: Colors.red,
                  onClick: () {
                    _userNotifier.logout(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTile(
      {Color color, IconData icon, String title, String data}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            title,
            style: whiteText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            data,
            style:
                whiteText.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
