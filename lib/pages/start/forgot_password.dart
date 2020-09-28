import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/widgets/appbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String route = '/ForgotPassword';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  TextEditingController forgotPassword = TextEditingController();


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


  Widget build(BuildContext context) {

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
              child: Column(
                  children: <Widget> [
                    SizedBox(height: 100,),
                    Text('House.Inventory'.toUpperCase(), style: TextStyle(
                        fontSize: 30,
                        color: Colors.amber
                    ),),
                    SizedBox(height: 60,),
                    customTextField("Enter your Email", Icons.email, forgotPassword, false),
                    SizedBox(height: 30,),
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
                            Text('Reset Password', style: TextStyle(
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
                    SizedBox(height: 30,),
                    Container(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Divider(
                                color: Colors.white70,
                                height: 36,
                                thickness: 0.5,
                              )),
                        ),
                        Text("or", style: TextStyle(color: Colors.white70, fontSize: 16),),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                              child: Divider(
                                color: Colors.white70,
                                height: 36,
                                thickness: 0.5,
                              )),
                        ),
                      ]),
                    ),
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
