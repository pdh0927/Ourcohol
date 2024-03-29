import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:http/http.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:ourcohol/user/sign_up_page/pos_information.dart';
import 'package:ourcohol/user/sign_up_page/unessential_information.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EssentialInformation extends StatefulWidget {
  const EssentialInformation({super.key});

  @override
  State<EssentialInformation> createState() => _EssentialInformationState();
}

class _EssentialInformationState extends State<EssentialInformation> {
  bool visible1 = true;
  bool visible2 = true;
  String inputEmail = '';
  int flagValidateEmail = -1; // -1 : 판별x, 0 : false, 1 : true
  int flagDuplicateEmail = -1; // -1 : 판별x, 0 : 중복, 1 : 사용가능
  String inputPassword1 = '';
  String inputPassword2 = '';
  int flagValidatePassword = -1; // -1 : 판별x, 0 : false, 1 : true
  bool allCheck = false;
  bool firstCheck = false;
  bool secondCheck = false;
  var user = {};

  validateEmail() {
    if (inputEmail != '') {
      if (!EmailValidator.validate(inputEmail)) {
        setState(() {
          flagValidateEmail = 0;
        });
      } else {
        setState(() {
          flagValidateEmail = 1;
        });
      }
    }
  }

  checkDuplicateEmail() async {
    Response response;
    try {
      response = await post(Uri.parse(
              // "http://ourcohol-env.eba-fh7m884a.ap-northeast-2.elasticbeanstalk.com/api/accounts/check-email/"),
              "http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/accounts/check-email/"),
          body: {'email': inputEmail});

      if (response.statusCode == 200) {
        print(response.body);
        if (json.decode(utf8.decode(response.bodyBytes))['duplicate'] == true) {
          setState(() {
            flagDuplicateEmail = 0;
          });
        } else {
          setState(() {
            flagDuplicateEmail = 1;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  passwordCheck() {
    if (inputPassword1 != '' && inputPassword2 != '') {
      if (inputPassword1 == inputPassword2) {
        setState(() {
          flagValidatePassword = 1;
        });
      } else {
        setState(() {
          flagValidatePassword = 0;
        });
      }
    } else {
      flagValidatePassword = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              FlutterRemix.arrow_left_line,
              color: Color(0xff131313),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      width: 100.w - 32,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('회원가입', style: textStyle12),
                                  Text('필수정보*', style: textStyle13),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('이메일*', style: textStyle14),
                                  Text('인증에 사용될 예정이니 정확히 입력바랍니다',
                                      style: textStyle21),
                                ],
                              ),
                            ),
                            Container(
                              width: 100.w - 32,
                              height: (100.w - 32) / 7,
                              margin: const EdgeInsets.only(bottom: 17),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Focus(
                                onFocusChange: (bool hasFocus) async {
                                  if (hasFocus == false) {
                                    await validateEmail();
                                    if (flagValidateEmail == 1) {
                                      checkDuplicateEmail();
                                    }
                                  } else {}
                                },
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            style: BorderStyle.none),
                                        borderRadius: BorderRadius.circular(10),
                                        gapPadding: 0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            style: BorderStyle.none),
                                        borderRadius: BorderRadius.circular(10),
                                        gapPadding: 0),
                                    hintText: '이메일을 입력해주세요',
                                    hintStyle: const TextStyle(
                                        color: Color(0xff686868)),
                                    filled: true,
                                    fillColor: const Color(0xffE0E0E0),
                                  ),
                                  autofocus: true,
                                  onChanged: (text) {
                                    setState(() {
                                      inputEmail = text;
                                    });
                                  },
                                ),
                              ),
                            ),
                            EmailCheckBox(
                              flagValidateEmail: flagValidateEmail,
                              flagDuplicateEmail: flagDuplicateEmail,
                            ),
                            Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                child: Text('비밀번호*', style: textStyle14)),
                            Container(
                              width: 100.w - 32,
                              height: (100.w - 32) / 7,
                              margin: const EdgeInsets.only(bottom: 17),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                obscureText: visible1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 0),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 0),
                                  hintText: '영문, 숫자 조합 8~16자',
                                  hintStyle:
                                      const TextStyle(color: Color(0xff686868)),
                                  filled: true,
                                  fillColor: const Color(0xffE0E0E0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      visible1
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xffCACACA),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        visible1 = !visible1;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    inputPassword1 = text;
                                    passwordCheck();
                                  });
                                },
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                child: Text('비밀번호 확인*', style: textStyle14)),
                            Container(
                              width: 100.w - 32,
                              height: (100.w - 32) / 7,
                              margin: const EdgeInsets.only(bottom: 17),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                obscureText: visible2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 0),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 0),
                                  hintText: '비밀번호를 한번 더 입력해주세요',
                                  hintStyle:
                                      const TextStyle(color: Color(0xff686868)),
                                  filled: true,
                                  fillColor: const Color(0xffE0E0E0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      visible2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xffCACACA),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        visible2 = !visible2;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    inputPassword2 = text;
                                    passwordCheck();
                                  });
                                },
                              ),
                            ),
                            flagValidatePassword == -1
                                ? SizedBox(height: 0, width: 0)
                                : (flagValidatePassword == 0
                                    ? Container(
                                        width: 100.w - 32,
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 40),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Icon(
                                                FlutterRemix
                                                    .checkbox_circle_fill,
                                                color: Color(0xffD74646)),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    left: 6),
                                                child: Text('비밀번호가 일치하지 않습니다',
                                                    style: textStyle17)),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: 100.w - 32,
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 40),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Icon(
                                                  FlutterRemix
                                                      .checkbox_circle_fill,
                                                  color: Color(0xff57AC6A)),
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 6),
                                                  child: Text('비밀번호가 일치합니다',
                                                      style: textStyle15))
                                            ]))),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    margin: const EdgeInsets.only(right: 17),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          allCheck = !allCheck;
                                        });
                                        if (allCheck) {
                                          firstCheck = true;
                                          secondCheck = true;
                                        } else {
                                          firstCheck = false;
                                          secondCheck = false;
                                        }
                                      },
                                      child: Icon(
                                        allCheck == true
                                            ? FlutterRemix.checkbox_line
                                            : FlutterRemix.checkbox_blank_line,
                                        size: 25,
                                        color: const Color(0xff131313),
                                      ),
                                    ),
                                  ),
                                  Text('아래 약관에 모두 동의합니다.', style: textStyle18)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    margin: const EdgeInsets.only(
                                        left: 1.5, right: 17),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          firstCheck = !firstCheck;
                                        });
                                        if (firstCheck == true &&
                                            secondCheck == true) {
                                          setState(() {
                                            allCheck = true;
                                          });
                                        }
                                        if (firstCheck == false) {
                                          setState(() {
                                            allCheck = false;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        firstCheck == true
                                            ? FlutterRemix.checkbox_line
                                            : FlutterRemix.checkbox_blank_line,
                                        size: 22,
                                        color: const Color(0xff131313),
                                      ),
                                    ),
                                  ),
                                  Text('이용약관 필수 동의', style: textStyle18),
                                  Expanded(
                                      child: Container(
                                          width: 22,
                                          height: 22,
                                          alignment: Alignment.centerRight,
                                          child: MaterialButton(
                                              minWidth: 22,
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('이용약관',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xff131313))),
                                                      content:
                                                          SingleChildScrollView(
                                                              child:
                                                                  TermsOfUse()),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              right: 20,
                                                              left: 20,
                                                              bottom: 5),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                            '확인',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(
                                                                    0xff131313)),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                  FlutterRemix
                                                      .arrow_right_s_line,
                                                  size: 22))))
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    margin: const EdgeInsets.only(
                                        left: 1.5, right: 17),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          secondCheck = !secondCheck;
                                        });
                                        if (firstCheck == true &&
                                            secondCheck == true) {
                                          setState(() {
                                            allCheck = true;
                                          });
                                        }
                                        if (secondCheck == false) {
                                          setState(() {
                                            allCheck = false;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        secondCheck == true
                                            ? FlutterRemix.checkbox_line
                                            : FlutterRemix.checkbox_blank_line,
                                        size: 22,
                                        color: const Color(0xff131313),
                                      ),
                                    ),
                                  ),
                                  Text('개인정보 처리방침 필수 동의', style: textStyle18),
                                  Expanded(
                                      child: Container(
                                          width: 22,
                                          height: 22,
                                          alignment: Alignment.centerRight,
                                          child: MaterialButton(
                                              minWidth: 22,
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          '개인정보 처리방침',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xff131313))),
                                                      content:
                                                          SingleChildScrollView(
                                                              child:
                                                                  PrivacyPolicy()),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              right: 20,
                                                              left: 20,
                                                              bottom: 5),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                            '확인',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(
                                                                    0xff131313)),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                  FlutterRemix
                                                      .arrow_right_s_line,
                                                  size: 22))))
                                ],
                              ),
                            ),
                            SizedBox(height: 40 / 852 * 100.w)
                          ]))),
            ),
            (flagValidateEmail == 1 &&
                    flagValidatePassword == 1 &&
                    allCheck == true)
                ? Container(
                    width: 100.w - 32,
                    height: 44,
                    margin: const EdgeInsets.only(top: 16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                        padding: const EdgeInsets.all(0),
                        color: const Color(0xff131313),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Text('다음',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () {
                          user['email'] = inputEmail;
                          user['password1'] = inputPassword1;
                          user['password2'] = inputPassword2;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UnessentialInformation(user: user)));
                        }),
                  )
                : Container(
                    width: 100.w - 32,
                    height: 44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey),
                    alignment: Alignment.center,
                    child: const Text('다음',
                        style: TextStyle(fontSize: 16, color: Colors.white)))
          ],
        )));
  }
}

class EmailCheckBox extends StatefulWidget {
  EmailCheckBox({super.key, this.flagValidateEmail, this.flagDuplicateEmail});
  var flagValidateEmail;
  var flagDuplicateEmail;
  @override
  State<EmailCheckBox> createState() => _EmailCheckBoxState();
}

class _EmailCheckBoxState extends State<EmailCheckBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.flagValidateEmail == -1) {
      return const SizedBox(width: 0, height: 0);
    } else if (widget.flagValidateEmail == 0) {
      return Container(
        width: 100.w - 32,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(FlutterRemix.checkbox_circle_fill,
                color: Color(0xffD74646)),
            Container(
                margin: const EdgeInsets.only(left: 6),
                child: Text('email 형식이 맞지 않습니다', style: textStyle17))
          ],
        ),
      );
    } else if (widget.flagValidateEmail == 1 &&
        widget.flagDuplicateEmail == 0) {
      return Container(
        width: 100.w - 32,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(FlutterRemix.checkbox_circle_fill,
                color: Color(0xffD74646)),
            Container(
                margin: const EdgeInsets.only(left: 6),
                child: Text('중복된 email입니다', style: textStyle17)),
          ],
        ),
      );
    } else {
      return Container(
        width: 100.w - 32,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(FlutterRemix.checkbox_circle_fill,
                color: Color(0xff57AC6A)),
            Container(
                margin: const EdgeInsets.only(left: 6),
                child: Text('사용 가능한 email입니다', style: textStyle15))
          ],
        ),
      );
    }
  }
}
