import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';

import '../config.dart';
import 'main_screen.dart';

class SchedulingDetailsScreen extends StatefulWidget {

  final int _scheduling;

  SchedulingDetailsScreen(this._scheduling);

  @override
  _SchedulingDetailsScreenState createState() => _SchedulingDetailsScreenState(this._scheduling);
}

class _SchedulingDetailsScreenState extends State<SchedulingDetailsScreen> {

  final int _scheduling;
  Map<String, dynamic> jsonDecoded;
  Map<String, dynamic> specialitiesSelected;
  List<dynamic> specialities;
  bool loaded = false;

  _SchedulingDetailsScreenState(this._scheduling);

  void finalizeSchedulingCallback(Response response) {
    Map<String, dynamic> jsonDecoded2 = json.decode(response.body);
    print(response.body);

    if (jsonDecoded2["success"]) {
      Navigator.pop(context);
    } else {

    }
  }

  @override
  void initState() {
    super.initState();
    Connection.get("medic/schedulings/${this._scheduling}.json", callback: schedulingLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Consulta"),
          backgroundColor: Colors.black45
      ),
      body: !loaded ?
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                CircularProgressIndicator()
              ],
            )
          ],
        ),
      ) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: specialities.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(specialities[index]["name"]),
                      activeColor: Colors.redAccent,
                      value: specialitiesSelected[specialities[index]["id"].toString()],
                      onChanged: (value) {
                        setState(() {
                          specialitiesSelected[specialities[index]["id"].toString()] = value;
                        });
                      },
                    );
                  }
              ),
              RaisedButton(
                onPressed: (){
                  var hashBody = {};
                  hashBody["id"] = this._scheduling;
                  hashBody["scheduling"] = {};
                  hashBody["scheduling"]["id"] = this._scheduling;
                  hashBody["scheduling"]["specialities_forwarding"] = specialitiesSelected;
                  var headers = {
                    "Content-Type" : "application/json; charset=UTF-8"
                  };
                  Connection.post("medic/schedulings/finalize.json",
                      callback: finalizeSchedulingCallback,
                      body: json.encode(hashBody));
                },
                child: Text("Finalizar consulta"),
                color: Colors.redAccent,
                textColor: Colors.white,
              )
            ],
          ),
        )
      ),
    );
  }

  void schedulingLoaded(Response response) {
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      if (body is Map<String, dynamic>) {
        print(jsonDecoded);
        jsonDecoded = json.decode(response.body);
        specialities = jsonDecoded["specialities"];

        specialitiesSelected = Map<String, dynamic>();
        specialities.forEach((element) {
          specialitiesSelected[element["id"].toString()] = false;
        });
        loaded = true;
      } else {
        return;
      }
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

}
