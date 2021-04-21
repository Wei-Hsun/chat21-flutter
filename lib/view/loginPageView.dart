import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat21_flutter/widgets/loginForm.dart';
import 'package:provider/provider.dart';
import 'package:chat21_flutter/controller/firebaseController.dart';

class LoginpageView extends StatefulWidget {
  @override
  _LoginpageViewState createState() => _LoginpageViewState();
}

//// Sign-in method: https://ithelp.ithome.com.tw/articles/10224143
//// https://levelup.gitconnected.com/firebase-authentication-and-keeping-users-logged-in-with-provider-in-flutter-f1c66cdb1bc7

class _LoginpageViewState extends State<LoginpageView> {
  @override
  Widget build(BuildContext context) {
    var account = Provider.of<FirebaseController>(context);

    return ProgressHUD(
        backgroundColor: Colors.black87,
        textStyle: Theme.of(context).accentTextTheme.subtitle2,
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              // backgroundColor: Color(0xff669999),
              title: Text("Login"),
            ),
            body: SingleChildScrollView(
              child: LoginForm(
                onLogin: (state) {
                  if (state.formKey.currentState.validate()) {
                    final progress = ProgressHUD.of(context);
                    progress.showWithText("Loading...");
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Future.delayed(Duration(milliseconds: 500), () async {
                      try {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        final UserCredential authResult =
                            await _auth.signInWithEmailAndPassword(
                          email: state.emailController.text,
                          password: state.passwordController.text,
                        );
                        final User user = authResult.user;
                        final String idToken = await user.getIdToken();
                        account.settoken(idToken);
                        account.getuser(user);
                        Navigator.pushReplacementNamed(context, "/home");
                      } catch (e) {
                        print(e);
                      }
                      progress.dismiss();
                    });
                  } else {
                    print("validate failed...");
                  }
                },
              ),
            ),
          ),
        ));
  }
}
