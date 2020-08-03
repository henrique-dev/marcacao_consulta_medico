import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';
import 'package:marcacao_consulta_medico/models/user.dart';
import 'package:marcacao_consulta_medico/screens/register_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../config.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //TextEditingController _cpfTextEditingController = TextEditingController(text: "01741053200");
  TextEditingController _cpfTextEditingController = TextEditingController(text: "");
  //TextEditingController _passwordTextEditingController = TextEditingController(text: "12345678");
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
            builder: (context) => MainScreen()
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
                            Text("CPF"),
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              decoration: InputDecoration(
                                fillColor: Colors.redAccent
                              ),
                              inputFormatters: [
                                MaskTextInputFormatter(
                                    mask: "### ### ### ##", filter: { "#": RegExp(r'[0-9]') }
                                )
                              ],
                              controller: _cpfTextEditingController,
                              toolbarOptions: ToolbarOptions(
                                paste: true
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                            ),
                            Text("Senha"),
                            TextField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: _passwordTextEditingController,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            RaisedButton(
                              onPressed: loginOnPressed,
                              child: Text("Entrar"),
                              color: Colors.redAccent,
                              textColor: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RaisedButton(
                                    child: Text("Cadastrar"),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RegisterScreen()
                                          )
                                      );
                                      if (result == "register_success") {
                                        Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(
                                          content: Text("Cadastro realizado com sucesso!"),
                                        ));
                                      }
                                    },
                                    color: Colors.black45,
                                    textColor: Colors.white,
                                  )
                                ],
                              ),
                            )
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
