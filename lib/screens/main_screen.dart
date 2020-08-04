import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_medico/config/constants.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';
import 'package:marcacao_consulta_medico/screens/profile_screen.dart';
import 'package:marcacao_consulta_medico/screens/scheduling_details_screen.dart';
import 'package:marcacao_consulta_medico/screens/scheduling_historic_screen.dart';

class MainScreen extends StatefulWidget {

  int _currentBottomNavigationBarIndex = 0;
  int _medicWorkSchedulingId = 0;

  MainScreen(int medicWorkSchedulingId, {int currentBottomNavigationBarIndex = 0}) {
    this._medicWorkSchedulingId = medicWorkSchedulingId;
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  @override
  _MainScreenState createState() => _MainScreenState(this._medicWorkSchedulingId, currentBottomNavigationBarIndex: this._currentBottomNavigationBarIndex);
}

class _MainScreenState extends State<MainScreen> {

  int _currentBottomNavigationBarIndex = 0;
  int _medicWorkSchedulingId = 0;

  _MainScreenState(int medicWorkSchedulingId, {int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
    this._medicWorkSchedulingId = medicWorkSchedulingId;
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
      FutureBuilder<dynamic>(
        future: Connection.get("medic/schedulings.json?consulted=false&medic_work_scheduling=${this._medicWorkSchedulingId}", callback: null),
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
                jsonDecoded = json.decode(response.body);

                if (jsonDecoded is List<dynamic>) {

                  if (jsonDecoded.length > 0) {
                    return ListView.builder(
                        itemCount: jsonDecoded.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await Navigator.push(context,MaterialPageRoute(builder: (context) => SchedulingDetailsScreen(jsonDecoded[index]["id"])));
                              setState(() {

                              });
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
                      Navigator.push(context,MaterialPageRoute(builder: (context) => SchedulingHistoricScreen(this._medicWorkSchedulingId)));
                    },
                  )
              ),
            ],
          )
      ),
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
            title: Text("Agendamentos"),
            icon: Icon(Icons.add_alarm),
          ),
          BottomNavigationBarItem(
            title: Text("Perfil"),
            icon: Icon(Icons.account_circle)
          ),
        ],
      ),
    );
  }

}
