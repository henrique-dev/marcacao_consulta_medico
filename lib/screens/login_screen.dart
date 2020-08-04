import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';
import 'package:marcacao_consulta_medico/models/user.dart';
import 'package:marcacao_consulta_medico/screens/medic_work_screen.dart';
import 'package:marcacao_consulta_medico/screens/register_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../config.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //TextEditingController _cpfTextEditingController = TextEditingController(text: "04264852243");
  TextEditingController _cpfTextEditingController = TextEditingController(text: "");
  //TextEditingController _passwordTextEditingController = TextEditingController(text: "123456");
  TextEditingController _passwordTextEditingController = TextEditingController(text: "");

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void loginOnPressed() {
    Dialogs.showLoadingDialog(context, _keyLoader, "Efetuando login");
    Connection.login(loginCallBack, User(_cpfTextEditingController.text.replaceAll(" ", ""), _passwordTextEditingController.text));
  }

  void loginCallBack(Response response) {
    Map<String, dynamic> jsonDecoded = json.decode(response.body);
    print(response.body);
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MedicWorkScreen()
        )
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(jsonDecoded["errors"][0])));
    }
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            height: height,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      height: height
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(100),
                          child: Image.asset("images/logo2.png"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                            ),
                            TextField(
                              keyboardType: TextInputType.phone,
                              cursorColor: Colors.black,
                              controller: _cpfTextEditingController,
                              inputFormatters: [
                                MaskTextInputFormatter(
                                    mask: "### ### ### ##", filter: { "#": RegExp(r'[0-9]') }
                                )
                              ],
                              decoration: InputDecoration(
                                labelText: "CPF",
                                labelStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                hoverColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            TextField(
                              keyboardType: TextInputType.phone,
                              cursorColor: Colors.black,
                              controller: _passwordTextEditingController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Senha",
                                labelStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                hoverColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            RaisedButton(
                              onPressed: loginOnPressed,
                              child: Text("Entrar"),
                              color: Colors.redAccent,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          );
        }
      )
    );
  }
}
