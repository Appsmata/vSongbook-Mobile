import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vsongbook/widgets/AsProgressDialog.dart';
import 'package:vsongbook/helpers/AppFutures.dart';
import 'package:vsongbook/models/callbacks/User.dart';
import 'package:vsongbook/models/base/EventObject.dart';
import 'package:vsongbook/screens/AppStart.dart';
import 'package:vsongbook/utils/Preferences.dart';
import 'package:vsongbook/utils/Constants.dart';

class BbUserSignup extends StatefulWidget {
  @override
  createState() => new BbUserSignupState();
}

class BbUserSignupState extends State<BbUserSignup> {
  final globalKey = new GlobalKey<ScaffoldState>();
  AsProgressDialog progressDialog =
      AsProgressDialog.getAsProgressDialog(LangStrings.User_Signup);

  TextEditingController firstnameController =
      new TextEditingController(text: "");
  TextEditingController lastnameController =
      new TextEditingController(text: "");
  TextEditingController genderController = new TextEditingController(text: "");
  TextEditingController cityController = new TextEditingController(text: "");
  TextEditingController churchController = new TextEditingController(text: "");

  String genderVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('Just a minute to know you'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: _signupButtonAction)
        ],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
          child: new Stack(
            children: <Widget>[
              _formContainer(),
              progressDialog,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signupButtonAction,
        tooltip: 'Proceed',
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _formContainer() {
    return new Container(
      padding: EdgeInsets.all(20),
      height: 500,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5)],
      ),
      child: new Form(
          child: new Theme(
        data: new ThemeData(primarySwatch: Colors.orange),
        child: new Column(
          children: <Widget>[
            signupFormContainer(),
            signupButtonContainer(),
          ],
        ),
      )),
      margin: EdgeInsets.only(top: 20, left: 25, right: 25),
    );
  }

  Widget signupFormContainer() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            child: new TextFormField(
              controller: firstnameController,
              decoration: InputDecoration(
                  labelText: LangStrings.FirstName,
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          new Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: new TextFormField(
              controller: lastnameController,
              decoration: InputDecoration(
                  labelText: LangStrings.LastName,
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          new Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: new TextFormField(
              controller: genderController,
              onTap: genderContainer,
              decoration: InputDecoration(
                  labelText: LangStrings.YourGender,
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              readOnly: true,
            ),
          ),
          new Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: new TextFormField(
              controller: cityController,
              decoration: InputDecoration(
                  labelText: LangStrings.YourCity,
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          new Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: new TextFormField(
              controller: churchController,
              decoration: InputDecoration(
                labelText: LangStrings.YourChurch,
                labelStyle: TextStyle(fontSize: 22),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
    );
  }

  void genderContainer() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text('You are a:'),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Brother'),
            onTap: () => Navigator.pop(context, 'Brother'),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Sister'),
            onTap: () => Navigator.pop(context, 'Sister'),
          ),
        ],
      ),
    ).then((returnVal) {
      if (returnVal != null) {
        genderController.text = returnVal;
        if (returnVal == 'Brother')
          genderVal = '1';
        else if (returnVal == 'Sister') genderVal = '2';
      }
    });
  }

  Widget signupButtonContainer() {
    return new Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      decoration: new BoxDecoration(
          color: Colors.deepOrange, borderRadius: BorderRadius.circular(5)),
      child: new MaterialButton(
        textColor: Colors.white,
        padding: EdgeInsets.all(15),
        onPressed: _signupButtonAction,
        child: new Text(
          LangStrings.Proceed,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _signupButtonAction() {
    if (firstnameController.text.length < 3) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(LangStrings.Invalid_Entry),
      ));
      return;
    } else if (lastnameController.text.length < 3) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(LangStrings.Invalid_Entry),
      ));
      return;
    } else if (cityController.text.length < 3) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(LangStrings.Invalid_Entry),
      ));
      return;
    } else if (churchController.text.length < 3) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(LangStrings.Invalid_Entry),
      ));
      return;
    }

    FocusScope.of(context).requestFocus(new FocusNode());
    progressDialog.showProgress();

    _signupUser(firstnameController.text, lastnameController.text, genderVal,
        cityController.text, churchController.text);
  }

  void _signupUser(String firstname, String lastname, String gender,
      String city, String church) async {
    String country = await Preferences.getSharedPreferenceStr(
        SharedPreferenceKeys.User_Country_Icode);
    String mobile = await Preferences.getSharedPreferenceStr(
        SharedPreferenceKeys.User_Mobile);

    User user = new User(
        firstname: firstname,
        lastname: lastname,
        country: country,
        mobile: mobile,
        gender: gender,
        city: city,
        church: church);
    EventObject eventObject = await signupUser(user);
    log('Eventid: ' + eventObject.id.toString());

    switch (eventObject.id) {
      case EventConstants.User_Signup_Successful:
        {
          setState(() {
            Preferences.setUserLoggedIn(true);
            Preferences.setUserProfile(eventObject.object);
            globalKey.currentState.showSnackBar(
                new SnackBar(content: new Text(LangStrings.Signin_Successful)));
            progressDialog.hideProgress();
            _goToHomeScreen();
          });
        }
        break;

      case EventConstants.User_Already_Registered:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(LangStrings.User_Already_Registered),
            ));
            _signinUser(mobile);
          });
        }
        break;

      case EventConstants.User_Signup_Unsuccessful:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(LangStrings.Signup_Unsuccessful),
            ));
            progressDialog.hideProgress();
          });
        }
        break;

      case EventConstants.No_Internet_Connection:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(LangStrings.No_Internet_Connection),
            ));
            _signinUser(mobile);
          });
        }
        break;
    }
  }

  void _signinUser(String mobile) async {
    User user = new User(mobile: mobile);
    EventObject eventObject = await signinUser(user);
    log('Eventid: ' + eventObject.id.toString());
    switch (eventObject.id) {
      case EventConstants.User_Signin_Successful:
        {
          setState(() {
            Preferences.setUserLoggedIn(true);
            Preferences.setUserProfile(eventObject.object);
            globalKey.currentState.showSnackBar(
                new SnackBar(content: new Text(LangStrings.Signin_Successful)));
            progressDialog.hideProgress();
            _goToHomeScreen();
          });
        }
        break;

      case EventConstants.User_Signin_Unsuccessful:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
                content: new Text(LangStrings.Signin_Unsuccessful)));
            progressDialog.hideProgress();
          });
        }
        break;

      case EventConstants.No_Internet_Connection:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
                content: new Text(LangStrings.No_Internet_Connection)));
            progressDialog.hideProgress();
          });
        }
        break;
    }
  }

  void _goToHomeScreen() {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new AppStart()));
  }
}
