import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Libs/ApiService.dart';
import '../Libs/MenuService.dart';

class NewListView extends StatefulWidget {
  @override
  NewListFormState createState() {
    return NewListFormState();
  }
}

class NewListFormState extends State<NewListView> {
  final _formKey = GlobalKey<FormState>();
  final myNameController = TextEditingController();
  bool _autoValidate = false;

  void _validateInputs (BuildContext ctxt) async {
    if (_formKey.currentState.validate()) {
      Scaffold.of(ctxt)
          .showSnackBar(SnackBar(content: Text('Creating list...')));
      Response r = await ApiService.addShoppingList(myNameController.text);
      if(r.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context,
            '/login', (route) => false);
      }
      else Navigator.pop(ctxt, true);
    } else {
      //If all data are not valid then start auto validation.
      Scaffold.of(ctxt).showSnackBar(SnackBar(content:
      Text('Please check your input fields')));
      setState(() {
        _autoValidate = true;
      });
    }
  }


  String validateName(String value) {
    RegExp regex = RegExp('^[a-zA-Z0-9üÜäÄöÖß_ ]*\$');
    if (!regex.hasMatch(value)) {
      return 'Only characters and digits are allowed';
    }
    else if(value.length > 60) return 'Reduce name to less than 60 characters';
    else if(value == "") return 'Name should not be empty';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MenuService.getDrawer(context),
      appBar: AppBar(
        title: Text('New List'),
        actions: <Widget>[Builder(
            builder: (ctxt) => Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).backgroundColor,
                  ),
                  onPressed: () => Scaffold.of(ctxt).openEndDrawer(),
                )
            ))
        ],
      ),
      body: SingleChildScrollView(
        child:Builder(
          builder: (ctxt) => Center(
            child: Padding(
            padding: const EdgeInsets.all(40.0),
            child:Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Listname'
                    ),
                    controller: myNameController,
                    // The validator receives the text that the user has entered.
                    validator: validateName,
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                        onPressed: () {
                          _validateInputs(ctxt);
                        },
                        child: Text('Save'),
                      )
                    )
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}