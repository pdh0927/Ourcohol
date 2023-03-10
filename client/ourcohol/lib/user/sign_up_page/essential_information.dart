import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:ourcohol/style.dart';
import 'package:sizer/sizer.dart';

class EssentialInformation extends StatefulWidget {
  const EssentialInformation({super.key});

  @override
  State<EssentialInformation> createState() => _EssentialInformationState();
}

class _EssentialInformationState extends State<EssentialInformation> {
  bool visible1 = true;
  bool visible2 = true;
  var inputEmail = '';
  var flagValidateEmail = false;
  var inputPassword1 = '';
  var inputPassword2 = '';

  validateEmail() {
    setState(() {
      flagValidateEmail = EmailValidator.validate(inputEmail);
    });
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('회원가입', style: textStyle12),
                                Text('필수정보*', style: textStyle13),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              child: Text('이메일*', style: textStyle14)),
                          Container(
                            width: 100.w - 32,
                            height: (100.w - 32) / 7,
                            margin: const EdgeInsets.only(bottom: 17),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
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
                                    borderRadius: BorderRadius.circular(5),
                                    gapPadding: 0),
                                hintText: '이메일을 입력해주세요',
                                hintStyle:
                                    const TextStyle(color: Color(0xff686868)),
                                filled: true,
                                fillColor: const Color(0xffE0E0E0),
                              ),
                              autofocus: true,
                              onChanged: (text) {
                                setState(() {
                                  inputEmail = text;
                                  validateEmail();
                                });
                              },
                            ),
                          ),
                          flagValidateEmail == false
                              ? Container(
                                  width: 100.w - 32,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                          FlutterRemix.checkbox_circle_fill,
                                          color: Color(0xffD74646)),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 6),
                                          child: Text('email 형식이 맞지 않습니다',
                                              style: textStyle17)),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 100.w - 32,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                          FlutterRemix.checkbox_circle_fill,
                                          color: Color(0xff57AC6A)),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 6),
                                          child: Text('이메일 형식 따봉',
                                              style: textStyle15))
                                    ],
                                  ),
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
                                fillColor: Color(0xffE0E0E0),
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
                                });
                              },
                            ),
                          ),
                          (inputPassword1 != inputPassword2)
                              ? Container(
                                  width: 100.w - 32,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                          FlutterRemix.checkbox_circle_fill,
                                          color: Color(0xffD74646)),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 6),
                                          child: Text('비밀번호가 일치하지 않습니다',
                                              style: textStyle17)),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 100.w - 32,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                            FlutterRemix.checkbox_circle_fill,
                                            color: Color(0xff57AC6A)),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 6),
                                            child: Text('비밀번호가 일치합니다',
                                                style: textStyle15))
                                      ]))
                        ])))));
  }
}
