import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:vsongbook/widgets/AsProgressDialog.dart';
import 'package:vsongbook/helpers/AppFutures.dart';
import 'package:vsongbook/models/callbacks/User.dart';
import 'package:vsongbook/models/base/EventObject.dart';
import 'package:vsongbook/screens/AppStart.dart';
import 'package:vsongbook/screens/BbUserSignup.dart';
import 'package:vsongbook/utils/Preferences.dart';
import 'package:vsongbook/utils/Constants.dart';

class BbUserSignin extends StatefulWidget {
  @override
  createState() => new BbUserSigninState();
}

class BbUserSigninState extends State<BbUserSignin> {
  final globalKey = new GlobalKey<ScaffoldState>();
  AsProgressDialog progressDialog =
      AsProgressDialog.getAsProgressDialog(LangStrings.User_Signin);
  TextEditingController phoneController = new TextEditingController(text: "");
  TextStyle textStyle;
  Country userCountry = new Country(
    asset: "assets/flags/ke_flag.png",
    dialingCode: "254",
    isoCode: "KE",
    name: "Kenya",
    currency: "Kenyan shilling",
    currencyISO: "KES",
  );

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('Welcome to vSongBook'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: _signinButtonAction)
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
        onPressed: _signinButtonAction,
        tooltip: 'Proceed',
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _formContainer() {
    return new Container(
      padding: EdgeInsets.all(20),
      height: 350,
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
            _signinFormContainer(),
            _signinButtonContainer(),
          ],
        ),
      )),
      margin: EdgeInsets.only(top: 20, left: 25, right: 25),
    );
  }

  Widget _signinFormContainer() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(10),
            child: new Center(
              child: CountryPicker(
                showDialingCode: true,
                selectedCountry: userCountry,
                onChanged: (Country country) {
                  setState(() {
                    userCountry = country;
                  });
                },
              ),
            ),
          ),
          new Center(
            child: new TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    labelText: LangStrings.Mobile,
                    labelStyle: TextStyle(fontSize: 22),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.phone),
          ),
        ],
      ),
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
    );
  }

  Widget _signinButtonContainer() {
    return new Padding(
        padding: new EdgeInsets.all(25),
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              color: Colors.deepOrange, borderRadius: BorderRadius.circular(5)),
          child: new MaterialButton(
            textColor: Colors.white,
            padding: EdgeInsets.all(15),
            onPressed: _signinButtonAction,
            child: new Text(
              LangStrings.Proceed,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          margin: EdgeInsets.only(bottom: 30),
        ));
  }

  void _signinButtonAction() {
    if (phoneController.text.length < 9) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(LangStrings.Enter_Phone),
      ));
      return;
    }
    int mobile = int.parse(phoneController.text);
    String mobileno = userCountry.dialingCode + mobile.toString();

    Preferences.setCountryPhone(userCountry.name, userCountry.isoCode,
        userCountry.dialingCode, mobileno);
    FocusScope.of(context).requestFocus(new FocusNode());
    progressDialog.showProgress();

    _signinUser(mobileno);
  }

  void _signinUser(String mobile) async {
    User user = new User(mobile: mobile);
    EventObject eventObject = await signinUser(user);
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

      case EventConstants.User_Not_Found:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(LangStrings.User_Not_Found),
            ));
            progressDialog.hideProgress();
            _goToSignupScreen();
          });
        }
        break;

      case EventConstants.User_Signin_Unsuccessful:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(LangStrings.Signin_Unsuccessful),
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

  void _goToSignupScreen() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new BbUserSignup()));
  }
}
