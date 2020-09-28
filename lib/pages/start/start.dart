import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/pages/start/forgot_password.dart';
import 'package:houseinventory/widgets/appbar.dart';

class StartPage extends StatefulWidget {
  static const String route = '/Start';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  TextEditingController signInEmail = TextEditingController();
  TextEditingController signInPassword = TextEditingController();

  TextEditingController signUpName = TextEditingController();
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();

  Widget customTextField(String hint, IconData icon, TextEditingController controller, bool obscure) {
    return TextField(
      textCapitalization: TextCapitalization.words,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      controller: controller,
      obscureText: obscure,
      autofocus: false,
      maxLines: 1,
      autocorrect: true,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      cursorColor: Colors.amber,
      style: TextStyle(fontSize: 17, color: Colors.white,),
      decoration: InputDecoration(
          enabled: true,
          prefixIcon: Icon(icon, color: Colors.amber,size: 22,),
          focusColor: Colors.amber,
          contentPadding: EdgeInsets.all(10),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54)
      ),
    );
  }

  bool isLoginPage = false;

  Widget build(BuildContext context) {

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
              child: Column(
                  children: <Widget> [
                    SizedBox(height: 100,),
                    Text('House.Inventory'.toUpperCase(), style: TextStyle(
                        fontSize: 30,
                        color: Colors.amber
                    ),),
                    SizedBox(height: 60,),
                    customTextField("Email", Icons.email, signInEmail, false),
                    SizedBox(height: 30,),
                    customTextField("Password", Icons.lock, signInPassword, true),
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
                                fontSize: 15,
                              )),
                            ),
                          )
                        ],
                      )
                    ),

                    Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          //side: BorderSide(color: Colors.red)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.email, color: Colors.white70.withOpacity(0.4), size: 22),
                            Text('Sign in with Email', style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                            ),),
                            SizedBox(width: 26,),
                          ],
                        ),
                        color: Color(0xff5E5E2A),
                        onPressed: () {
                        },
                      ),
                    ),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Divider(
                                color: Colors.white70,
                                height: 36,
                                thickness: 0.7,
                              )),
                        ),
                        Text("or", style: TextStyle(color: Colors.white70, fontSize: 16),),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                              child: Divider(
                                color: Colors.white70,
                                height: 36,
                                thickness: 0.7,
                              )),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          //side: BorderSide(color: Colors.red)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.email, color: Colors.white70.withOpacity(0.4), size: 22),
                            Text('Sign in with HUAWEI ID', style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
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
                            fontSize: 17,
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
                                fontSize: 17,
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
              child: Form(
                child: Column(
                    children: <Widget> [
                      SizedBox(height: 100,),
                      Text('House.Inventory'.toUpperCase(), style: TextStyle(
                          fontSize: 30,
                          color: Colors.amber,
                      ),),
                      SizedBox(height: 60,),
                      customTextField("Enter your Name", Icons.account_box, signUpName, false),
                      SizedBox(height: 30,),
                      customTextField("Enter your Email", Icons.email, signUpEmail, false),
                      SizedBox(height: 30,),
                      customTextField("Enter a Password", Icons.lock, signUpPassword, true),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?', style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
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
                                  fontSize: 17,
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
                        height: 40,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Sign Up'.toUpperCase(), style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),),
                            ],
                          ),
                          color: Color(0xff5E5E2A),
                          onPressed: () {
                          },
                        ),
                      ),
                      Container(
                        child: Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Divider(
                                  color: Colors.white70,
                                  height: 36,
                                  thickness: 0.7,
                                )),
                          ),
                          Text("or", style: TextStyle(color: Colors.white70, fontSize: 16),),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white70,
                                  height: 36,
                                  thickness: 0.7,
                                )),
                          ),
                        ]),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal:0,vertical: 4),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.email, color: Colors.white70.withOpacity(0.4), size: 22),
                              Text('Sign in with HUAWEI ID', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
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
