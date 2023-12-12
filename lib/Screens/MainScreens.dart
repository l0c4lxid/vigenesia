import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Login.dart';
import 'EditPage.dart';
import 'package:org/Models/Motivasi_Model.dart';
import 'package:org/Constant/const.dart';

class MainScreens extends StatefulWidget {
  final String? nama;
  final String? iduser;

  const MainScreens({Key? key, this.nama, this.iduser}) : super(key: key);

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
  var dio = Dio();

  TextEditingController isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.iduser ?? '',
    };

    try {
      Response response = await dio.post(
        "$baseurl/api/dev/POSTmotivasi/",
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => true,
        ),
      );
      print("Response -> ${response.data} + ${response.statusCode}");
      return response;
    } catch (e) {
      print("Error -> $e");
    }
  }

  Future<List<MotivasiModel>> getData(String userid) async {
    var response = await dio.get('$baseurl/api/Get_motivasi?iduser=$userid');

    print(" ${response.data}");
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      //getData();
    });
  }

  Future<void> _editMotivasi(String id, String isiMotivasi) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(
          id: id,
          isi_motivasi: isiMotivasi,
        ),
      ),
    );

    if (result != null && result) {
      _getData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil Update & Refresh dulu"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteMotivasi(String id) async {
    try {
      Response response = await dio.delete(
        "$baseurl/api/dev/DELETEmotivasi",
        data: {"id": id},
        options: Options(
          validateStatus: (status) => true,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil Menghapus Motivasi"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
        _getData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal Menghapus Motivasi"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      print("Error -> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hai? ${widget.nama}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Login(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  controller: isiController,
                  name: "isi_motivasi",
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.red, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    labelStyle: TextStyle(color: Colors.red),
                    labelText: "Isi Motivasi",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await sendMotivasi(isiController.text.toString())
                          .then((value) => {
                                if (value != null)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Berhasil Submit"),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.greenAccent,
                                      ),
                                    ),
                                    _getData(),
                                  },
                                print("Sukses"),
                              });
                    },
                    child: Text("Tambah"),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Motivasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 40,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _getData();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: Text(
                                      "Refresh",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          FutureBuilder<List<MotivasiModel>>(
                            future: getData(widget.iduser ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                return Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, id) {
                                      return Card(
                                        elevation: 5.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            snapshot.data![id].isiMotivasi ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  _editMotivasi(
                                                    snapshot.data![id].id ?? '',
                                                    snapshot.data![id]
                                                            .isiMotivasi ??
                                                        '',
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                color: Colors.red,
                                                onPressed: () {
                                                  _deleteMotivasi(
                                                      snapshot.data![id].id ??
                                                          '');
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
