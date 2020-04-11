import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcc/notifier/login_notifier.dart';
import 'package:mcc/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/page_routes.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // LoginNotifier _loginNotifier = LoginNotifier();
    LoginNotifier _loginNotifier = Provider.of<LoginNotifier>(context);
    print(_loginNotifier.loading);
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.red..withOpacity(0.3),
                        Colors.green.withOpacity(0.7)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(90)),
                  ),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(90)),
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg.jpg'),
                          fit: BoxFit.cover)),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 32, left: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Proudly Supported by',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/avi.jpg',
                                ),
                                Image.asset(
                                  'assets/images/techend.jpg',
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: Hero(
                          tag: 'logo',
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(200)),
                            child: Image.asset('assets/images/logo2.png'),
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 32, right: 32),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 50, right: 10, left: 10, bottom: 0),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        padding: EdgeInsets.only(
                            top: 10, left: 16, right: 16, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            hintText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        margin: EdgeInsets.only(top: 32),
                        padding: EdgeInsets.only(
                            top: 10, left: 16, right: 16, bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextField(
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.grey,
                            ),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      Container(height: 20),
                      Container(
                        child: InkWell(
                          onTap: (_loginNotifier.loading == false)
                              ? () => _loginNotifier.login(
                                  context: context,
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              : () => print('I am here but null'),
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade300,
                                    Colors.green.shade600
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(FadeRoute(
                              page: ChangeNotifierProvider(
                                  create: (context) => LoginNotifier(),
                                  child: ForgetPasswordPage()))),
                          child: Center(
                            child: Text(
                              'Forget Password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                (_loginNotifier.loading || _loginNotifier.loggingIn)
                    ? Container(
                        color: Colors.blue.withOpacity(0.2),
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(),
              ]),
            ),
          ],
        ),
      ),
      persistentFooterButtons: buildSupportTeam(context),
    );
  }
}
