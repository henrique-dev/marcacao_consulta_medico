import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_medico/config/constants.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';

class SchedulingHistoricScreen extends StatefulWidget {

  int _medicWorkSchedulingId = 0;

  SchedulingHistoricScreen(this._medicWorkSchedulingId);

  @override
  _SchedulingHistoricScreenState createState() => _SchedulingHistoricScreenState(this._medicWorkSchedulingId);
}

class _SchedulingHistoricScreenState extends State<SchedulingHistoricScreen> {

  int _medicWorkSchedulingId = 0;

  _SchedulingHistoricScreenState(this._medicWorkSchedulingId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus agendamentos"),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: Connection.get("medic/schedulings.json?medic_work_scheduling=${this._medicWorkSchedulingId}", callback: null),
          builder: (context, snapshot) {

            List<dynamic> jsonDecoded;
            List<dynamic> schedulingsConsulted = [];
            List<dynamic> schedulingsNotConsulted = [];
            List<dynamic> widgets = [];

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

                    print(jsonDecoded);

                    jsonDecoded.forEach((element) {
                      if (element["consulted"]) {
                        schedulingsConsulted.add(element);
                      } else {
                        schedulingsNotConsulted.add(element);
                      }
                    });

                    if (schedulingsNotConsulted.length > 0) {
                      widgets.add(Padding(padding: EdgeInsets.all(10), child: Text("Consultas a serem realizadas"),));
                      schedulingsNotConsulted.forEach((element) {
                        widgets.add(
                            Card(
                              child: Row(children: [Expanded(flex: 3, child: Padding(padding: EdgeInsets.all(10),
                                child: Container( child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Padding(padding: EdgeInsets.all(5),
                                    child: Text(Constants.WEEK_DAYS[DateTime.parse(element["for_date"]).weekday]),),
                                    Padding(padding: EdgeInsets.all(5), child: Text(DateTime.parse(element["for_date"]).day.toString(),
                                      style: TextStyle(fontSize: 35,color: Colors.redAccent),),),
                                    Padding(padding: EdgeInsets.all(5),
                                      child: Text(Constants.MONTHS[DateTime.parse(element["for_date"]).month-1]),),],),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 2,color: Colors.blueGrey))),),),),
                                Expanded(flex: 6,
                                  child: Padding(padding: EdgeInsets.all(10), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(element["medic_profile"]["name"]),
                                      Text(element["speciality"]["name"]),
                                      Text(element["clinic"]["name"]),],),),)
                              ],),)
                        );
                      });
                    }
                    if (schedulingsConsulted.length > 0) {
                      widgets.add(Padding(padding: EdgeInsets.all(10), child: Text("Consultas já realizadas"),));
                      schedulingsConsulted.forEach((element) {
                        widgets.add(
                            Card(
                              child: Row(children: [Expanded(flex: 3, child: Padding(padding: EdgeInsets.all(10),
                                child: Container( child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Padding(padding: EdgeInsets.all(5),
                                    child: Text(Constants.WEEK_DAYS[DateTime.parse(element["for_date"]).weekday]),),
                                    Padding(padding: EdgeInsets.all(5), child: Text(DateTime.parse(element["for_date"]).day.toString(),
                                      style: TextStyle(fontSize: 35),),),
                                    Padding(padding: EdgeInsets.all(5),
                                      child: Text(Constants.MONTHS[DateTime.parse(element["for_date"]).month-1]),),],),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 2,color: Colors.blueGrey))),),),),
                                Expanded(flex: 6,
                                  child: Padding(padding: EdgeInsets.all(10), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(element["medic_profile"]["name"]),
                                      Text(element["speciality"]["name"]),
                                      Text(element["clinic"]["name"]),],),),)
                              ],),)
                        );
                      });
                    }

                  } else {
                    //Connection.checkResponse(response, reloadCallback);
                  }

                  if (schedulingsConsulted.length + schedulingsNotConsulted.length > 0) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: widgets.length,
                        itemBuilder: (context, index) {
                          return widgets[index];
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
      ),
    );
  }
}
