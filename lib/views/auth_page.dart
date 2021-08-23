import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/user_model.dart';
import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:arcainternational/services/api/user_service.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:arcainternational/widget/app_button.dart';
import 'package:arcainternational/widget/app_text_filed.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController tcEmail = new TextEditingController();
  TextEditingController tcPass = new TextEditingController();
  FocusNode fnEmail = new FocusNode();
  FocusNode fnPass = new FocusNode();
  bool errEmail = false;
  bool errPass = false;
  bool hidePass = true;
  bool onAuth = false;
  bool onLoad = true;

  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bool isAuth = await Application.userService.isAuth();
      if(isAuth) {
        Application.router.navigateTo(context, '/', replace: true);
      } else {
        super.setState(() {
          onLoad = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return MainView(
      context: context,
      body: Center(
          child: onLoad ? SizedBox(
            width: 65,
            height: 65,
            child: CircularProgressIndicator(strokeWidth: 2)
          ) : Card(
            child: Container(
              width: 700,
              height: 450,
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),

                  AppTextField(
                    controller: tcEmail,
                    focusNode: fnEmail,
                    isError: errEmail,
                    keyboardType: TextInputType.emailAddress,
                    label: "Email",
                    margin: EdgeInsets.symmetric(vertical: 4),
                    onEditingComplete: () {
                      fnEmail.unfocus();
                      fnPass.requestFocus();
                    },
                    onChanged: (val) {
                      super.setState(() {
                        errEmail = false;
                      });
                    },
                  ),
                  AppTextField(
                    controller: tcPass,
                    focusNode: fnPass,
                    isError: errPass,
                    label: "Password",
                    isPassword: hidePass,
                    keyboardType: TextInputType.visiblePassword,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    onEditingComplete: () {
                      fnPass.unfocus();
                      _signIn();
                    },
                    onChanged: (val) {
                      super.setState(() {
                        errPass = false;
                      });
                    },
                    suffixIcon: SizedBox(
                      child: IconButton(
                        onPressed: () {
                          super.setState(() {
                            hidePass = !hidePass;
                          });
                        },
                        icon: hidePass ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                  onAuth ? Container(
                    margin: EdgeInsets.only(top: 12),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2,),
                    ),
                  ) : AppButton(
                    margin: EdgeInsets.only(top: 12),
                    label: "Sign In",
                    onPressed: _signIn,
                  ),
                ],
              ),
            )
          )
        ),
    );
  }

  void _signIn() async {
    try {
      fnEmail.unfocus();
      fnPass.unfocus();
    } catch (e) {}

    String email = tcEmail.text.trim();
    String password = tcPass.text.trim();

    if(!Valid.email(email))
      errEmail = true;

    if(password.length < 6)
      errPass = true;

    if(errEmail || errPass) {
      super.setState(() {
        errEmail = errEmail;
        errPass = errPass;
      });

      return;
    }

    super.setState(() {
      onAuth = true;
    });

    final User? user = await UserService().authentication(email: email, password: password);

    if(user == null) {
      super.setState(() {
        errEmail = true;
        errPass = true;
        onAuth = false;
      });
    } else {
      super.setState(() {
        onAuth = false;
      });
      Application.router.navigateTo(context, '/', clearStack: true);
    }
  }
}