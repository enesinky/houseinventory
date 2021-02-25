import 'dart:convert';
import 'package:houseinventory/pages/home/tabs.dart';
import 'package:houseinventory/util/Translations.dart';
import 'package:houseinventory/util/contants.dart';
import 'package:houseinventory/util/encrypter.dart';
import 'package:houseinventory/util/huawei_account.dart';
import 'package:houseinventory/util/shared_prefs.dart';
import 'package:houseinventory/util/validator.dart';
import 'package:houseinventory/widgets/start_page_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/start/forgot_password.dart';

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
    signInPassword.dispose();
    isLoading = false;
  }

  requestSignUp() async {
    try {
      var enc = new Encrypter();
      var emailHashedEncoded = base64.encode(utf8.encode(enc.SHA256(enc.SHA256(signUpEmail.text))));
      var passwordHashedEncoded = base64.encode(utf8.encode(enc.SHA256(enc.SHA256(signUpPassword.text))));
      print (emailHashedEncoded + "\n" + passwordHashedEncoded);
      http.Response response = await http.post(
        Constants.apiURL + '/api/register',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email":  signUpEmail.text,
          "password": passwordHashedEncoded,
          "avatar": "/",
          "name": signUpName.text
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if (response != null && response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        json['result'] == true ? loginProcedure(emailHashedEncoded, passwordHashedEncoded) : _promptError(Translations.of(context).text("err_msg_sth_wrong"), Translations.of(context).text("err_email_in_use"), Translations.of(context).text("ok"));
      }
      else {
        _promptError(Translations.of(context).text("err_msg_sth_wrong"), Translations.of(context).text("snack_msg_network_err"), Translations.of(context).text("try_again"));
      }
    } catch (exception) {
      _promptError(Translations.of(context).text("err_msg_sth_wrong"), Translations.of(context).text("snack_msg_network_err"), Translations.of(context).text("try_again"));
    }
  }

  requestSignIn() async {
    try {
      var enc = Encrypter();
      var emailHashedEncoded = base64.encode(utf8.encode(enc.SHA256(enc.SHA256(signInEmail.text))));
      var passwordHashedEncoded = base64.encode(utf8.encode(enc.SHA256(enc.SHA256(signInPassword.text))));
      http.Response response = await http.post(
        Constants.apiURL + '/api/auth',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": emailHashedEncoded,
          "password": passwordHashedEncoded
        }),
      ).timeout(Duration(seconds: Constants.API_TIME_OUT_LIMIT));
      if(response != null && response.statusCode == 200) {
        var json = jsonDecode(response.body);
        (json['result'] == true) ? loginProcedure(emailHashedEncoded, passwordHashedEncoded) : _promptError(Translations.of(context).text("err_auth_title"), Translations.of(context).text("err_auth"), Translations.of(context).text("ok"));
      }
      else {
        _promptError(Translations.of(context).text("err_msg_sth_wrong"), Translations.of(context).text("snack_msg_network_err"), Translations.of(context).text("try_again"));
      }
    } catch (exception) {
      _promptError(Translations.of(context).text("err_msg_sth_wrong"), Translations.of(context).text("snack_msg_network_err"), Translations.of(context).text("try_again"));
    }
  }

  void loginProcedure(email, pass) {
    sharedPrefs.setString("hash1", email);
    sharedPrefs.setString("hash2", pass);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, TabsPage.route);
  }

  Future<void> _promptError(String title, String body, String buttonText) async {
    setState(() {
      isLoading = !isLoading;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(
            fontSize: 16,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10),
          actions: <Widget>[
            FlatButton(
              child: Text(buttonText, style: TextStyle(color: Colors.blue),),
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

    var t = Translations.of(context);
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
                        Header(),
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
                              return t.text("start_warning_email");
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
                              hintText: t.text("start_email"),
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
                              return t.text("start_warning_sign_pass");
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
                              hintText: t.text("start_pass"),
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
                                  child: Text(t.text("start_forgot_pw"), style: TextStyle(
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
                                isLoading ? SizedBox(height:22, width:22,child: CircularProgressIndicator(strokeWidth: 4,)) : Text(t.text("start_btn_sign_in_email"), style: TextStyle(
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
                                FocusScope.of(context).unfocus();
                                requestSignIn();
                              }
                            },
                          ),
                        ),
                        CustomDivider(),
                        HuaweiButton(onPressed: () {
                          HuaweiAccount(context).signIn();
                        },),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(t.text("start_register_text"), style: TextStyle(
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
                                  child: Text(t.text("start_register"), style: TextStyle(
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
                        Header(),
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
                              return t.text("start_warning_name");
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
                              hintText: t.text("start_enter_name"),
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
                              return t.text("start_warning_email");
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
                              hintText: t.text("start_enter_email"),
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
                              return t.text("start_warning_pass");
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
                              hintText: t.text("start_enter_pass"),
                              hintStyle: TextStyle(color: Colors.white54)
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(t.text("start_sign_in_text"), style: TextStyle(
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
                                  child: Text(t.text("start_sign_in"), style: TextStyle(
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
                                isLoading ? SizedBox(height:22, width:22,child: CircularProgressIndicator(strokeWidth: 4,)) : Text(t.text("start_btn_sign_up"), style: TextStyle(
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
                                  FocusScope.of(context).unfocus();
                                  requestSignUp();
                              }
                            },
                          ),
                        ),
                        CustomDivider(),
                        HuaweiButton(onPressed: () {
                          HuaweiAccount(context).signIn();
                        },),
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
