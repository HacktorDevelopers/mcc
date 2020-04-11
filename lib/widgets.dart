import 'package:flutter/material.dart';

Widget buildTitle({title}) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 35,
      color: Colors.red.shade900,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildAppBar({title}) {
  return Material(
    elevation: 2.0,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      margin: const EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          // IconButton(
          //   onPressed: (){},
          //   icon: FaIcon(
          //     FontAwesomeIcons.utensils,
          //     color: Colors.green,
          //   ),
          // ),
          Expanded(
            child: title,
          ),
          // IconButton(
          //   onPressed: (){},
          //   icon: FaIcon(
          //     FontAwesomeIcons.accessibleIcon,
          //     color: Colors.green,
          //   ),
          // )
        ],
      ),
    ),
  );
}

List<Widget> buildSupportTeam(BuildContext context) {
  return <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Proudly Powered and Supported by',
          style: TextStyle(color: Theme.of(context).primaryColor),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset('assets/images/techend.jpg'),
        Image.asset('assets/images/avi.jpg'),
      ],
    )
  ];
}
