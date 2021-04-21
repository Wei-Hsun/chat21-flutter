import "package:flutter/material.dart";

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
    this.onLogin,
  }) : super(key: key);

  final Function(_LoginFormState state) onLogin;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;
  FocusNode _passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your ID";
                  }
                  return null;
                },
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "ID *",
                  // hintText: "",
                ),
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                focusNode: _passwordFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: _obscureText
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  labelText: "Password *",
                  hintText: "Your phone number",
                ),
              ),
            ),
            SizedBox(
              height: 52.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 48.0,
              height: 48.0,
              child: RaisedButton(
                child: Text("Login"),
                onPressed: () {
                  widget.onLogin(this);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
