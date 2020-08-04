import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_medico/connection/connection.dart';
import 'package:marcacao_consulta_medico/screens/main_screen.dart';

class MedicWorkScreen extends StatefulWidget {
  @override
  _MedicWorkScreenState createState() => _MedicWorkScreenState();
}

class _MedicWorkScreenState extends State<MedicWorkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus locais de trabalho"),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: Connection.get("medic/medic_work_schedulings.json", callback: null),
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
                            return Card(
                              child: ListTile(
                                title: Text(jsonDecoded[index]["speciality"]["name"], style: TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Local: ${jsonDecoded[index]["clinic"]["name"]}")
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen(jsonDecoded[index]["id"])
                                      )
                                  );
                                },
                              ),
                            );
                          }
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Sem locais de trabalho", textAlign: TextAlign.center,)
                        ],
                      );
                    }
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Sem locais de trabalho", textAlign: TextAlign.center,)
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
