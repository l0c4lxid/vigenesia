import 'package:org/Constant/const.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Ganti Base URL
  String baseurl =
      url; // ganti dengan ip address kamu / tempat kamu menyimpan backend

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    var dio = Dio();

    dynamic data = {
      "nama": nama,
      "profesi": profesi,
      "email": email,
      "password": password
    };

    try {
      final response = await dio.post("$baseurl/api/registrasi/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red, // Set the outer container color to red
        child: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: BoxDecoration(
                  color: Colors.white, // Set the inner container color to white
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register Your Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.red, // Set text color to red
                      ),
                    ),
                    SizedBox(height: 50),
                    FormBuilderTextField(
                      name: "name",
                      controller: nameController,
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
                        labelText: "Nama",
                      ),
                    ),
                    SizedBox(height: 20),
                    FormBuilderTextField(
                      name: "profesi",
                      controller: profesiController,
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
                        labelText: "Profesi",
                      ),
                    ),
                    SizedBox(height: 20),
                    FormBuilderTextField(
                      name: "email",
                      controller: emailController,
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
                        labelText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      obscureText: true,
                      name: "password",
                      controller: passwordController,
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
                        labelText: "Password",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await postRegister(
                                  nameController.text,
                                  profesiController.text,
                                  emailController.text,
                                  passwordController.text)
                              .then((value) => {
                                    if (value != null)
                                      {
                                        setState(() {
                                          Navigator.pop(context);
                                          Flushbar(
                                            message: "Berhasil Registrasi",
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.greenAccent,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                          ).show(context);
                                        })
                                      }
                                    else if (value == null)
                                      {
                                        Flushbar(
                                          message:
                                              "Check Your Field Before Register",
                                          duration: Duration(seconds: 5),
                                          backgroundColor: Colors.redAccent,
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                        ).show(context)
                                      }
                                  });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                        ),
                        child: Text(
                          "Daftar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman login
                      },
                      child: Text(
                        "Sudah punya akun? Login di sini",
                        style: TextStyle(color: Colors.black),
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
