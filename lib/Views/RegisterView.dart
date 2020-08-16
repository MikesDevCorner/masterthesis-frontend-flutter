import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Libs/ApiService.dart';

class RegisterView extends StatefulWidget {

  RegisterView({Key key}) : super(key: key);

  @override
  RegisterViewState createState() {
    return RegisterViewState();
  }

}

class RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  RegisterViewState() : super();
  final myEMailController = TextEditingController();
  final myNameController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myPasswordConfirmController = TextEditingController();
  bool _autoValidate = false;

  void _validateInputs (BuildContext ctxt) async {
    if (_formKey.currentState.validate()) {
      bool register = await ApiService.register(myEMailController.text,
        myPasswordController.text, myPasswordConfirmController.text, myNameController.text);
      if(!register) {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('System says you are unauthenticated')));
      } else {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Login and Register Successful')));
        Navigator.pushNamedAndRemoveUntil(context,
            '/', (route) => false);
      }
    } else {
      //If all data are not valid then start auto validation.
      Scaffold.of(ctxt).showSnackBar(SnackBar(content:
      Text('Please check your input fields')));
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
      return null;
  }

  String validateName(String value) {
    if(value.length > 60) return 'Reduce name to less than 60 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child:Builder(
            builder: (ctxt) => Center(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child:Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Text('Register an Account for Shopping List', style: Theme.of(context).primaryTextTheme.headline5),
                      new SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Name', labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        controller: myNameController,
                        validator: validateName
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'E-Mail', labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.emailAddress,
                        controller: myEMailController,
                        validator: validateEmail,
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Password', labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: myPasswordController,
                        validator: validatePassword
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Password again', labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: myPasswordConfirmController,
                        validator: validatePassword
                      ),
                      new SizedBox(
                        height: 30.0,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: double.infinity),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).backgroundColor,
                          onPressed: () {
                            _validateInputs(ctxt);
                          },
                          child: Text('REGISTER'),
                        )
                      )
                    ]
                  )
                )
              )
            )
          )
        ),
        floatingActionButton: Builder(
            builder: (ctxt) => FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Switch to Login',
              child: Icon(Icons.arrow_back),
            )
        )
    );
  }
}