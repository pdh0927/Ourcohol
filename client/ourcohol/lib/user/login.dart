import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ourcohol/home/home.dart';
import 'package:ourcohol/style.dart';
import 'package:sizer/sizer.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import "package:provider/provider.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool visible = true;
  var inputEmail = '';
  var flagValidateEmail = false;
  var inputPassword = '';

  validateEmail() {
    setState(() {
      flagValidateEmail = EmailValidator.validate(inputEmail);
    });
  }

  login(String email, String password) async {
    try {
      Response response =
          await post(Uri.parse("http://127.0.0.1:8000/api/accounts/login/"),
              //Uri.parse("http://10.0.2.2:8000/api/dj-rest-auth/login/"),

              body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var userData =
            Map.castFrom(json.decode(utf8.decode(response.bodyBytes)));

        print('Login Successfully');
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 45.5.w,
                height: 6.h,
                child: Text('OURcohol', style: TextStyle(fontSize: 41)),
              ),
              Column(
                children: [
                  Container(
                    width: 100.w - 32,
                    height: (100.w - 32) / 7,
                    margin: EdgeInsets.only(bottom: 17),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(5),
                            gapPadding: 0),
                        hintText: '이메일을 입력해주세요',
                        hintStyle: TextStyle(color: Color(0xff686868)),
                        filled: true,
                        fillColor: Color(0xffE0E0E0),
                      ),
                      autofocus: true,
                      onChanged: (text) {
                        setState(() {
                          inputEmail = text;
                        });

                        print(inputEmail);
                      },
                    ),
                  ),
                  Container(
                    width: 100.w - 32,
                    height: (100.w - 32) / 7,
                    margin: EdgeInsets.only(
                        bottom: (inputEmail != '' && inputPassword != '')
                            ? 12
                            : 17),
                    child: TextField(
                      obscureText: visible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 0),
                        hintText: '비밀번호를 입력해주세요',
                        hintStyle: TextStyle(color: Color(0xff686868)),
                        filled: true,
                        fillColor: Color(0xffE0E0E0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xffCACACA),
                          ),
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          inputPassword = text;
                        });
                      },
                    ),
                  ),
                  (inputEmail != '' && inputPassword != '')
                      ? MaterialButton(
                          height: (100.w - 32) / 7 + 10,
                          padding: EdgeInsets.all(5),
                          onPressed: () async {
                            var userData =
                                await login(inputEmail, inputPassword);

                            if (userData != null) {
                              context.read<UserProvider>().setUserInformation(
                                  userData['user']['id'],
                                  userData['user']['email'],
                                  userData['user']['nickname'],
                                  userData['token']['access'],
                                  userData['token']['refresh']);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Home()));
                            } else {
                              print('니 뭐 잘못 입력했다.');
                            }
                          },
                          child: Container(
                              width: 100.w - 32,
                              height: (100.w - 32) / 7,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color(0xff131313),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("로그인 하기", style: textStyle10)))
                      : Container(
                          width: 100.w - 32,
                          height: (100.w - 32) / 7,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xffADADAD),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("로그인 하기", style: textStyle10)),
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(
                        top: (inputEmail != '' && inputPassword != '') ? 0 : 5,
                        left: 13,
                        right: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            height: 30,
                            padding: EdgeInsets.all(3),
                            onPressed: () {},
                            child: Text("아이디/비밀번호 찾기", style: textStyle11)),
                        MaterialButton(
                            minWidth: 53,
                            height: 30,
                            padding: EdgeInsets.all(3),
                            onPressed: () {},
                            child: SizedBox(
                                width: 50,
                                child: Text("회원가입", style: textStyle11))),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
