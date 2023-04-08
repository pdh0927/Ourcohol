import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ourcohol/home/home.dart';
import 'package:ourcohol/style.dart';
import 'package:ourcohol/user/sign_up_page/essential_information.dart';
import 'package:sizer/sizer.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import "package:provider/provider.dart";
import 'package:url_launcher/url_launcher.dart';

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
    Response response;
    try {
      if (Platform.isIOS) {
        response = await post(
            Uri.parse("http://127.0.0.1:8000/api/accounts/dj-rest-auth/login/"),
            body: {'email': email, 'password': password});
      } else {
        response = await post(
            Uri.parse("http://10.0.2.2:8000/api/accounts/dj-rest-auth/login/"),
            body: {'email': email, 'password': password});
      }

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

  findPassword() async {
    if (Platform.isIOS) {
      // 브라우저를 열 링크
      final url =
          Uri.parse('http://127.0.0.1:8000/api/accounts/auth/password_reset/');

      // 인앱 브라우저 실행
      await launchUrl(url);
    } else {
      // 브라우저를 열 링크
      final url =
          Uri.parse('http://10.0.2.2:8000/api/accounts/auth/password_reset/');

      // 인앱 브라우저 실행
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 100.w - 32,
          margin: const EdgeInsets.only(right: 16, left: 16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50.w,
                height: 6.h,
                child: Text('OURcohol',
                    style: TextStyle(fontSize: 40 / 852 * 100.h)),
              ),
              Column(
                children: [
                  Container(
                    width: 100.w - 32,
                    height: (100.w - 32) / 7,
                    margin: const EdgeInsets.only(bottom: 17),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 0),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(5),
                            gapPadding: 0),
                        hintText: '이메일을 입력해주세요',
                        hintStyle: const TextStyle(color: Color(0xff686868)),
                        filled: true,
                        fillColor: const Color(0xffE0E0E0),
                      ),
                      onChanged: (text) {
                        setState(() {
                          inputEmail = text;
                        });
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
                            borderSide:
                                const BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 0),
                        hintText: '비밀번호를 입력해주세요',
                        hintStyle: const TextStyle(color: Color(0xff686868)),
                        filled: true,
                        fillColor: const Color(0xffE0E0E0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xffCACACA),
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
                          padding: const EdgeInsets.all(5),
                          onPressed: () async {
                            var userData =
                                await login(inputEmail, inputPassword);

                            if (userData != null) {
                              context.read<UserProvider>().setUserInformation(
                                  userData['user']['id'],
                                  userData['user']['email'],
                                  userData['user']['nickname'],
                                  userData['user']['image_memory'],
                                  userData['user']['type_alcohol'],
                                  userData['user']['amount_alcohol'],
                                  userData['access_token'],
                                  userData['refresh_token']);
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            height: 30,
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              await findPassword();
                            },
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text("비밀번호 찾기", style: textStyle11))),
                        MaterialButton(
                            height: 30,
                            minWidth: 60,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const EssentialInformation()));
                            },
                            child: Container(
                                alignment: Alignment.centerRight,
                                width: 60,
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
