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
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장

  bool visible = true;
  var inputEmail = '';
  var flagValidateEmail = false;
  var inputPassword = '';

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await context.read<UserProvider>().storage.read(key: 'login');

    // user의 정보가 있다면 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      userInfo = jsonDecode(userInfo);
      // 앱내에서 유저 변경 정보가 있을수도 있으니 Login말고 detail 가져오기로 정보 불러와서 povider에 저장
      await getUserInfo(userInfo['user']['id'], userInfo['access']);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Home()));
    } else {
      print('로그인이 필요합니다');
    }
  }

  validateEmail() {
    setState(() {
      flagValidateEmail = EmailValidator.validate(inputEmail);
    });
  }

  getUserInfo(int userId, String accessToken) async {
    Response response;
    try {
      response = await patch(Uri.parse(
              // ""http://127.0.0.1:8000/api/accounts/${userId}/"),
              "http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/accounts/${userId}/"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken}',
          });
      if (response.statusCode == 200) {
        context.read<UserProvider>().setUserInformation(
            userInfo['user']['id'],
            userInfo['user']['email'],
            userInfo['user']['nickname'],
            userInfo['user']['image_memory'] ?? '',
            userInfo['user']['type_alcohol'],
            userInfo['user']['amount_alcohol'],
            userInfo['access'],
            userInfo['refresh']);
        print('get information Successfully');
        return null;
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  login(String email, String password) async {
    Response response;
    try {
      response = await post(Uri.parse(
              // "http://127.0.0.1:8000/api/accounts/dj-rest-auth/login/"),
              "http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/accounts/dj-rest-auth/login/"),
          body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        var userData =
            Map.castFrom(json.decode(utf8.decode(response.bodyBytes)));
        await context.read<UserProvider>().storage.write(
              key: 'login',
              value: jsonEncode(userData),
            );
        print('Login Successfully');
        return userData;
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('잘못된 로그인 정보',
                  style: TextStyle(fontSize: 20, color: Color(0xff131313))),
              content: const Text('이메일 혹은 비밀번호가 잘못되었습니다.',
                  style: TextStyle(fontSize: 17, color: Color(0xff131313))),
              contentPadding:
                  EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 5),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 20, color: Color(0xff131313)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  findPassword() async {
    // 브라우저를 열 링크
    final url = Uri.parse(
        'http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/accounts/auth/password_reset/');

    // 인앱 브라우저 실행
    await launchUrl(url);
  }

  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
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
                                  userData['user']['image_memory'] ?? '',
                                  userData['user']['type_alcohol'],
                                  userData['user']['amount_alcohol'],
                                  userData['access'],
                                  userData['refresh']);

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
