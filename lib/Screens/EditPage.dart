import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';

import '../Constant/const.dart';

import '/../Models/Motivasi_Model.dart';

class EditPage extends StatefulWidget {
  final String? id;
  final String? isi_motivasi;
  const EditPage({Key? key, this.id, this.isi_motivasi}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl =
      url; // ganti dengan ip address kamu / tempat kamu menyimpan backend

  var dio = Dio();
  Future<dynamic> putPost(String isi_motivasi, String ids) async {
    Map<String, dynamic> data = {"isi_motivasi": isi_motivasi, "id": ids};
    var response = await dio.put('$baseurl/api/dev/PUTmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    print("---> ${response.data} + ${response.statusCode}");

    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        backgroundColor: Colors.red, // Set the app bar color to red
      ),
      body: SafeArea(
        child: Container(
          color: Colors.red, // Set the container color to red
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                margin: const EdgeInsets.only(top: 150, bottom: 150),
                decoration: BoxDecoration(
                  color: Colors.white, // Set the inner container color to white
                  borderRadius:
                      BorderRadius.circular(12.0), // Set border radius
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.isi_motivasi}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30.0, // Set the font size
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: FormBuilderTextField(
                        name: "isi_motivasi",
                        controller: isiMotivasiC,
                        style: TextStyle(fontSize: 14.0), // Adjust font size
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          labelStyle: TextStyle(color: Colors.red),
                          labelText: "Update Isi Motivasi",
                          hintStyle: TextStyle(
                              color: Colors.red), // Set hint text color to red
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        putPost(isiMotivasiC.text, widget.id.toString())
                            .then((value) => {
                                  if (value != null)
                                    {
                                      Navigator.pop(context),
                                      Flushbar(
                                        message:
                                            "Berhasil Update & Refresh dlu",
                                        duration: Duration(seconds: 5),
                                        backgroundColor: Colors.green,
                                        flushbarPosition:
                                            FlushbarPosition.BOTTOM,
                                      ).show(context)
                                    }
                                });
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Set button color to red
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
