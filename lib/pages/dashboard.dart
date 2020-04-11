import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mcc/notifier/add_dispatch_notifier.dart';
import 'package:mcc/notifier/user_notifier.dart';
import 'package:mcc/utils/page_routes.dart';
import 'package:provider/provider.dart';
import '../pages/add_dispatch.dart';
import '../widgets.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final Color accentColor = Color(0XFFFA2B0F);

  List<ItemModel> items = [
    // ItemModel("Total Dispatches", 12, 1830),
    ItemModel("Dispatches By Me", 4, 883),
  ];

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  

  Text _buildText(String title){
    return Text(title,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    );
  }

  IconButton _buildButton(IconData icon, {Color color, onClick}){
    return IconButton(
      onPressed: onClick,
      icon: Icon(icon, color: color,),
    );
  }

  Widget _buildBottomCardChildren({BuildContext context}){
    UserNotifier _userNotifier = Provider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: _buildButton(
                Icons.exit_to_app, 
                color: Colors.red,
                onClick: () {
                  _userNotifier.logout(context);
                },
              ),
            ),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: Hero(
                tag: 'add',
                child: _buildButton(
                  Icons.add, 
                  color: Colors.green,
                  onClick: () {
                    Navigator.of(context).push(
                      FadeRoute(
                        page: ChangeNotifierProvider(
                          create: (context) => AddDispatchNotifier(),
                          child: DispatchScreen()
                        )
                      )
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBottomCard(BuildContext context, double width, double height){
    return Container(
      width: width,
      height: height/3,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16)
        )
      ),
      child: _buildBottomCardChildren(context: context),
    );
  }

  Widget _buildItemCardChild({label, digit}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Text(digit.toString(), style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildItemCard({label, digit}){
    return Container(
      height: 100,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1
          )
        ]
      ),
      child: _buildItemCardChild(label: 'Total Dispatched by Me', digit: digit),
    );
  }

  Widget _buildCardsList(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildItemCard(label: 'Total Dispatched by Me', digit: ''),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      persistentFooterButtons: buildSupportTeam(context),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/bg.jpg',
            ),
          ),
        ),
        margin: EdgeInsets.only(top: 16),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: buildAppBar(title: Image.asset('assets/images/logo.png')),
            ),
            Align(
              alignment: Alignment.bottomCenter,
                child: _buildBottomCard(context, width, height)
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<UserNotifier>(
                    builder: (context, _noti, child) {
                      // return _buildItemCard(label: 'Total Dispatched by Me:', digit: _noti.getUserDispatches);
                      return _buildItemCard(label: 'Total Dispatched by Me:', digit: _noti.getUserDispatches);
                    }
                  ),
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}

class ItemModel{
  final String title;
  final int numOne;
  final int numTwo;

  ItemModel(this.title, this.numOne, this.numTwo);
}