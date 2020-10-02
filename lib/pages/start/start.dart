import 'dart:convert';
import 'package:houseinventory/pages/home/tabs.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/util/validator.dart';
import 'package:houseinventory/widgets/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/start/forgot_password.dart';
import 'package:houseinventory/util/aes_handler.dart';
import 'package:houseinventory/widgets/appbar.dart';

class StartPage extends StatefulWidget {
  static const String route = '/Start';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  bool isLoginPage;
  bool isLoading;

  final _signInFormKey = GlobalKey<FormState>();
  TextEditingController signInEmail = TextEditingController();
  TextEditingController signInPassword = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();
  TextEditingController signUpName = TextEditingController();
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isLoginPage = true;
  }

  @override
  void dispose() {
    super.dispose();
    signUpEmail.dispose();
    signUpPassword.dispose();
    signUpName.dispose();
    signInEmail.dispose();
    isLoading = false;
  }

  Future<http.Response> requestSignUp() {
    return http.post(
      Constants.apiURL + '/api/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email":  signUpEmail.text,
        "password": signUpPassword.text,
        "avatar": "",
        "name": signUpName.text
      }),
    ).timeout(
        const Duration(seconds: 5), onTimeout: () {
        return null;
    });
  }
  requestSignUpHandler(response) {
    if(response != null && response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if(json['result'] == true) {
        loginProcedure(json['token']);
      }
      else {
        _alreadyTakenEmailError();
      }
    }
    else {
      // another error occured
      _someErrorHappenedAlert();
    }
  }

  Future<http.Response> requestSignIn() {
    return http.post(
      Constants.apiURL + '/api/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email":  signInEmail.text,
        "password": signInPassword.text
      }),
    ).timeout(
        const Duration(seconds: 5), onTimeout: () {
      return null;
    });
  }
  requestSignInHandler(response) {
    if(response != null && response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if(json['result'] == true && json['token'] != null) {
        loginProcedure(json['token']);
      }
      else {
        _authenticationError();
      }
    }
    else {
      // another error occured
      _someErrorHappenedAlert();
    }
  }

  void loginProcedure(token) {
    sharedPrefs.setString("token", token);
    Navigator.pushReplacementNamed(context, TabsPage.route);
  }
  Future<void> _someErrorHappenedAlert() async {
    setState(() {
      isLoading = !isLoading;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something Went Wrong!', style: TextStyle(
            fontSize: 16,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('An error occured during request.'),
                Text('Please check your connection.'),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 30),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _alreadyTakenEmailError() async {
    setState(() {
      isLoading = !isLoading;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Address is in Use!', style: TextStyle(
            fontSize: 16,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter another email address.'),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 30),
          actions: <Widget>[
            FlatButton(
              child: Text('Change Address', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _authenticationError() async {
    setState(() {
      isLoading = !isLoading;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Failed', style: TextStyle(
            fontSize: 16,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please check your email and password.'),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 30),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {

    var divider = Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.white24,
                height: 36,
                thickness: 0.7,
              )),
        ),
        Text("or", style: TextStyle(color: Colors.white24, fontSize: 14),),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.white24,
                height: 36,
                thickness: 0.7,
              )),
        ),
      ]),
    );

    var signInPage = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                      children: <Widget> [
                        SizedBox(height: 100,),
                        Text('House.Inventory'.toUpperCase(), style: TextStyle(
                            fontSize: 30,
                            color: Colors.amber
                        ),),
                        SizedBox(height: 60,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          controller: signInEmail,
                          obscureText: false,
                          autofocus: false,
                          maxLines: 1,
                          autocorrect: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if(Validator.isValidEmail(input.toString())) {
                              return null;
                            } else {
                              return "Please enter a valid email.";
                            }
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          cursorColor: Colors.amber,
                          style: TextStyle(fontSize: 16, color: Colors.white,),
                          decoration: InputDecoration(
                              enabled: true,
                              prefixIcon: Icon(Icons.email, color: Colors.amber,size: 18,),
                              focusColor: Colors.amber,
                              contentPadding: EdgeInsets.all(10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(color: Colors.white54)
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          controller: signInPassword,
                          obscureText: true,
                          autofocus: false,
                          maxLines: 1,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (input) {
                            if(input.toString().length >= 6) {
                              return null;
                            } else {
                              return "Please enter your password.";
                            }
                          },
                          cursorColor: Colors.amber,
                          style: TextStyle(fontSize: 16, color: Colors.white,),
                          decoration: InputDecoration(
                              enabled: true,
                              prefixIcon: Icon(Icons.lock, color: Colors.amber,size: 18,),
                              focusColor: Colors.amber,
                              contentPadding: EdgeInsets.all(10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white54)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => {
                                  Navigator.pushNamed(context, ForgotPasswordPage.route),
                                },
                                splashColor: Colors.amber,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 12),
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Forgot Password', style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  )),
                                ),
                              )
                            ],
                          )
                        ),
                        Container(
                          height: 36,
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                isLoading ? SizedBox() : Icon(Icons.email, color: Colors.white70.withOpacity(0.4), size: 22),
                                isLoading ? SizedBox(height:22, width:22,child: CircularProgressIndicator(strokeWidth: 4,)) : Text('Sign in with Email', style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),),
                                isLoading ? SizedBox() : SizedBox(width: 26,),
                              ],
                            ),
                            color: Color(0xff5E5E2A),
                            onPressed: () {
                              if (_signInFormKey.currentState.validate()) {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                requestSignIn().then((response) => (requestSignInHandler(response)));
                              }
                            },
                          ),
                        ),
                        divider,
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          height: 36,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset('assets/images/hw_24x24_logo.png', width: 24, height: 24,),
                                Text('Sign in with HUAWEI ID', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),),
                                SizedBox(width: 20,),
                              ],
                            ),
                            color: Color(0xffef484b),
                            onPressed: () {

                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account yet?', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),),
                              InkWell(
                                onTap: () => {
                                  setState(() {
                                    isLoginPage = !isLoginPage;
                                  })
                                },
                                splashColor: Colors.amber,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Register', style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1.2,
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
    var signUpPage = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                      children: <Widget> [
                        SizedBox(height: 100,),
                        Text('House.Inventory'.toUpperCase(), style: TextStyle(
                            fontSize: 30,
                            color: Colors.amber,
                        ),),
                        SizedBox(height: 60,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          controller: signUpName,
                          obscureText: false,
                          autofocus: false,
                          maxLines: 1,
                          autocorrect: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (input) {
                            if(input.toString().length >= 3) {
                              return null;
                            } else {
                              return "Please enter your name.";
                            }
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          cursorColor: Colors.amber,
                          style: TextStyle(fontSize: 16, color: Colors.white,),
                          decoration: InputDecoration(
                              enabled: true,
                              prefixIcon: Icon(Icons.account_box, color: Colors.amber,size: 18,),
                              focusColor: Colors.amber,
                              contentPadding: EdgeInsets.all(10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              hintText: "Enter your Name",
                              hintStyle: TextStyle(color: Colors.white54)
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          controller: signUpEmail,
                          obscureText: false,
                          autofocus: false,
                          maxLines: 1,
                          autocorrect: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if(Validator.isValidEmail(input.toString())) {
                              return null;
                            } else {
                              return "Please enter a valid email.";
                            }
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          cursorColor: Colors.amber,
                          style: TextStyle(fontSize: 16, color: Colors.white,),
                          decoration: InputDecoration(
                              enabled: true,
                              prefixIcon: Icon(Icons.email, color: Colors.amber,size: 18,),
                              focusColor: Colors.amber,
                              contentPadding: EdgeInsets.all(10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              hintText: "Enter your Email",
                              hintStyle: TextStyle(color: Colors.white54)
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          controller: signUpPassword,
                          obscureText: true,
                          autofocus: false,
                          maxLines: 1,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (input) {
                            if(input.toString().length >= 6) {
                              return null;
                            } else {
                              return "Your password must contain at least 6 characters.";
                            }
                          },
                          cursorColor: Colors.amber,
                          style: TextStyle(fontSize: 16, color: Colors.white,),
                          decoration: InputDecoration(
                              enabled: true,
                              prefixIcon: Icon(Icons.lock, color: Colors.amber,size: 18,),
                              focusColor: Colors.amber,
                              contentPadding: EdgeInsets.all(10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber, width: 2),
                              ),
                              hintText: "Enter your a Password",
                              hintStyle: TextStyle(color: Colors.white54)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),),
                              InkWell(
                                onTap: () => {
                                  setState(() {
                                    isLoginPage = !isLoginPage;
                                  })
                                },
                                splashColor: Colors.amber,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Sign In', style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1.5,
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          height: 36,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                isLoading ? SizedBox(height:22, width:22,child: CircularProgressIndicator(strokeWidth: 4,)) : Text('Sign Up'.toUpperCase(), style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),),
                              ],
                            ),
                            color: Color(0xff5E5E2A),
                            onPressed: () {
                              if (_signUpFormKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = !isLoading;
                                  });
                                  requestSignUp().then((response) => (requestSignUpHandler(response)));
                              }
                            },
                          ),
                        ),
                        divider,
                        Container(
                          height: 36,
                          margin: EdgeInsets.symmetric(horizontal:0,vertical: 4),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              //side: BorderSide(color: Colors.red)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset('assets/images/hw_24x24_logo.png', width: 24, height: 24,),
                                Text('Sign in with HUAWEI ID', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),),
                                SizedBox(width: 20,),
                              ],
                            ),
                            color: Color(0xffef484b),
                            onPressed: () {

                            },
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2E2E2E), Color(0xff44441E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: isLoginPage ? signInPage : signUpPage
       )
    );
  }


}
