import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/start/start.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/validator.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  static const String route = '/ForgotPassword';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _forgotPasswordFormKey = GlobalKey<FormState>();
  TextEditingController forgotPassword = TextEditingController();
  var isLoading = false;
  var _isSent = false;

  Future<http.Response> requestForgotPassword() {
    return http.post(
      Constants.apiURL + '/api/forgot-password',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email":  forgotPassword.text,
      }),
    ).timeout(
        const Duration(seconds: 5), onTimeout: () {
      return null;
    });
  }
  requestForgotPasswordHandler(response) {
    if(response != null && response.statusCode == 200) {
        print('yes sent email if exists.');
        setState(() {
          isLoading = !isLoading;
          _isSent = true;
        });
        forgotPassword.clear();
    }
    else {
      // another error occured
      setState(() {
        _isSent = false;
      });
      _someErrorHappenedAlert();
    }
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

  Widget build(BuildContext context) {

    var message = Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done, size: 35, color: Colors.amber.withOpacity(0.5)),
          Text('An email with instructions was sent', style: TextStyle(color: Colors.amber.withOpacity(0.5), fontSize: 15),),
        ],),
    );
    var forgotPasswordPage = Container(
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
                  key: _forgotPasswordFormKey,
                  child: Column(
                      children: <Widget> [
                        StartPage.headerWidget,
                        _isSent ? message : SizedBox(),
                        SizedBox(height: 20,),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          controller: forgotPassword,
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
                          //onSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
                                isLoading ? SizedBox(height:22, width:22,child: CircularProgressIndicator(strokeWidth: 4,)) : Text('Reset Password', style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),),

                              ],
                            ),
                            color: Color(0xff5E5E2A),
                            onPressed: () {
                              if (_forgotPasswordFormKey.currentState.validate()) {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                requestForgotPassword().then((response) => (requestForgotPasswordHandler(response)));
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30,),
                        StartPage.divider,
                        Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => {
                                    Navigator.pop(context),
                                  },
                                  splashColor: Colors.amber,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 12),
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    child: Text('Cancel', style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    )),
                                  ),
                                )
                              ],
                            )
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
            child: forgotPasswordPage
        )
    );
  }
}
