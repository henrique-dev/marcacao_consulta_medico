import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_medico/config/constants.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';
import 'package:marcacao_consulta_medico/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {

  int _currentBottomNavigationBarIndex = 0;

  MainScreen({int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  @override
  _MainScreenState createState() => _MainScreenState(currentBottomNavigationBarIndex: this._currentBottomNavigationBarIndex);
}

class _MainScreenState extends State<MainScreen> {

  int _currentBottomNavigationBarIndex = 0;

  _MainScreenState({int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  void reloadedCallback(Response response) {
    setState(() {

    });
  }

  void reloadCallback(Response response) {
    //Connection.login(reloadedCallback, User("01741053200", "123456"));
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> screens = [
      Container(

          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: Text("Meus dados", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Visualize seus dados cadastrados"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()
                        )
                    );
                  },
                ),
              ),
              Card(
                  child: ListTile(
                    title: Text("Meus agendamentos", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Visualize todo o seu histórico de agendamentos"),
                    onTap: () {
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => SchedulingHistoricScreen()));
                    },
                  )
              ),
              Card(
                  child: ListTile(
                    title: Text("Meus documentos", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Visualize ou envie seus documentos ou exames já realizados"),
                    onTap: () {},
                  )
              ),
              Card(
                child: ListTile(
                  title: Text("Meus encaminhamentos", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Visualize os encaminhamentos que você possui"),
                  onTap: () {
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => SpecialitiesScreen()));
                  },
                ),
              )
            ],
          )
      ),
      FutureBuilder<dynamic>(
        future: Connection.get("patient/schedulings.json?consulted=false", callback: null),
        builder: (context, snapshot) {

          List<dynamic> jsonDecoded;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              CircularProgressIndicator();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (!snapshot.hasError) {

                Response response = snapshot.data;
                dynamic body = json.decode(response.body);

                if (body is List<dynamic>) {
                  jsonDecoded = json.decode(response.body);
                } else {
                  //Connection.checkResponse(response, reloadCallback);
                }

                if (jsonDecoded.length > 0) {
                  return ListView.builder(
                      itemCount: jsonDecoded.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => SchedulingDetailsScreen(jsonDecoded[index]["id"])));
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(Constants.WEEK_DAYS[DateTime.parse(jsonDecoded[index]["for_date"]).weekday]),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(DateTime.parse(jsonDecoded[index]["for_date"]).day.toString(),
                                              style: TextStyle(
                                                  fontSize: 35,
                                                  color: Colors.redAccent
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(Constants.MONTHS[DateTime.parse(jsonDecoded[index]["for_date"]).month-1]),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  width: 2,
                                                  color: Colors.blueGrey
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(jsonDecoded[index]["medic_profile"]["name"]),
                                        Text(jsonDecoded[index]["speciality"]["name"]),
                                        Text(jsonDecoded[index]["clinic"]["name"]),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Nenhum agendamento feito ainda", textAlign: TextAlign.center,)
                    ],
                  );
                }
              }
              break;
          }
          return Center(
            child: Text(""),
          );
        },
      ),
      FutureBuilder<dynamic>(
        future: Connection.get("patient/specialities.json", callback: null),
        builder: (context, snapshot) {

          List<dynamic> jsonDecoded;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              CircularProgressIndicator();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (!snapshot.hasError) {

                Response response = snapshot.data;
                dynamic body = json.decode(response.body);

                if (body is List<dynamic>) {
                  jsonDecoded = json.decode(response.body);
                } else {
                  //Connection.checkResponse(response, reloadCallback);
                }

                return ListView.builder(
                    itemCount: jsonDecoded.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(jsonDecoded[index]["name"], style: TextStyle(fontWeight: FontWeight.bold),),
                          //subtitle: Text(specialityList[index].description),
                          onTap: (){
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => SearchScreen(jsonDecoded[index]["id"])));
                          },
                        ),
                      );
                    }
                );
              }
              break;
          }
          return Center(
            child: Text(""),
          );
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Principal"),
        backgroundColor: Colors.black45
      ),
      body: screens[_currentBottomNavigationBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentBottomNavigationBarIndex = index;
          });
        },
        currentIndex: _currentBottomNavigationBarIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          color: Colors.redAccent,
        ),
        selectedItemColor: Colors.redAccent,
        items: [
          BottomNavigationBarItem(
            title: Text("Perfil"),
            icon: Icon(Icons.account_circle)
          ),
          BottomNavigationBarItem(
            title: Text("Agendamentos"),
            icon: Icon(Icons.add_alarm),
          ),
          BottomNavigationBarItem(
            title: Text("Buscar"),
            icon: Icon(Icons.search),
          )
        ],
      ),
    );
  }

}
