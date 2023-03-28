import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_remix/flutter_remix.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ourcohol/style.dart';
import 'package:ourcohol/user/login.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../../provider_ourcohol.dart';

class UnessentialInformation extends StatefulWidget {
  UnessentialInformation({super.key, this.user});
  var user;

  @override
  State<UnessentialInformation> createState() => _UnessentialInformationState();
}

class _UnessentialInformationState extends State<UnessentialInformation> {
  @override
  void initState() {
    randomNumber = Random().nextInt(10000);
    tempNickname = '알쓰 $randomNumber호';
    super.initState();
  }

  String inputNickname = '';
  int randomNumber = 0;
  String tempNickname = '';

  File? resultImage;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;
      File? img = File(image.path);

      img = await cropImage(imageFile: img);

      setState(() {
        resultImage = img;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));

    if (croppedImage == null) {
      return null;
    } else {
      return File(croppedImage.path);
    }
  }

  // postRequest(user) async {
  //   http.StreamedResponse response;
  //   try {
  //     if (Platform.isIOS) {
  //       String url =
  //           "http://127.0.0.1:8000/api/accounts/dj-rest-auth/registration/";
  //       var request = http.MultipartRequest('POST', Uri.parse(url));
  //       request.fields.addAll({
  //         'email': user['email'],
  //         'password1': user['password1'],
  //         'password2': user['password2'],
  //         'nickname': user['nickname'],
  //       });
  //       request.files
  //           .add(await http.MultipartFile.fromPath('image', resultImage!.path));

  //       response = await request.send();
  //     } else {
  //       print('ㅇ이거');
  //       String url =
  //           "http://10.0.2.2:8000/api/accounts/dj-rest-auth/registration/";
  //       var request = http.MultipartRequest('POST', Uri.parse(url));

  //       request.files
  //           .add(await http.MultipartFile.fromPath('image', resultImage!.path));
  //       request.fields.addAll({
  //         'email': user['email'],
  //         'password1': user['password1'],
  //         'password2': user['password2'],
  //         'nickname': user['nickname']
  //       });
  //       response = await request.send();
  //     }
  //     // if (response.statusCode == 200) {

  //     //   print('회원가입 Successfully');
  //     //   return userData;
  //     // } else {
  //     //   return null;
  //     // }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  Future<void> postRequest(user) async {
    http.StreamedResponse response;
    try {
      if (Platform.isIOS) {
        var dio = Dio();
        var formData = FormData.fromMap({
          'email': user['email'],
          'password1': user['password1'],
          'password2': user['password2'],
          'nickname': user['nickname'],
          'image': await MultipartFile.fromFile(resultImage!.path)
        });
        print(resultImage!.path);

        // 업로드 요청
        final response = await dio.post(
            'http://127.0.0.1:8000/api/accounts/dj-rest-auth/registration/',
            data: formData);
      } else {
        print('ㅇ이거');
        String url =
            "http://10.0.2.2:8000/api/accounts/dj-rest-auth/registration/";
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.files
            .add(await http.MultipartFile.fromPath('image', resultImage!.path));
        request.fields.addAll({
          'email': user['email'],
          'password1': user['password1'],
          'password2': user['password2'],
          'nickname': user['nickname']
        });
        response = await request.send();
      }
      // if (response.statusCode == 200) {

      //   print('회원가입 Successfully');
      //   return userData;
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
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
                                    Text('선택정보', style: textStyle13),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('닉네임', style: textStyle14),
                                    Text('입력하지 않으실 경우 자동으로 닉네임이 설정됩니다.',
                                        style: textStyle19),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100.w - 32,
                                height: (100.w - 32) / 5.5,
                                margin: const EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.bottom,
                                  maxLength: 8,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
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
                                    hintText: tempNickname,
                                    hintStyle: const TextStyle(
                                        color: Color(0xff686868)),
                                    filled: true,
                                    fillColor: const Color(0xffE0E0E0),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      inputNickname = text;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('사진', style: textStyle14),
                                    Text('프로필에 나타낼 사진을 등록합니다',
                                        style: textStyle19),
                                  ],
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        height: 135,
                                        width: 135,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffE0E0E0),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: resultImage != null
                                            ? Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            resultImage!),
                                                        fit: BoxFit.fill)),
                                              )
                                            : Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: Color(colorList[
                                                      randomNumber % 7]),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                    FlutterRemix.user_2_fill,
                                                    color: Colors.white,
                                                    size: 70),
                                              )),
                                    MaterialButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible:
                                                true, // 바깥 영역 터치시 닫을지 여부
                                            builder: (BuildContext ctx) {
                                              return Dialog(
                                                  child: Container(
                                                height: 108,
                                                width: 100.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 53.5,
                                                      width: 100.w - 16,
                                                      child: MaterialButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            Navigator.pop(ctx);
                                                            pickImage(
                                                                ImageSource
                                                                    .camera);
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              22,
                                                                          right:
                                                                              18),
                                                                  child: Icon(
                                                                      FlutterRemix
                                                                          .camera_fill,
                                                                      size:
                                                                          20)),
                                                              (Text(
                                                                '카메라 촬영하기',
                                                                style:
                                                                    textStyle20,
                                                              )),
                                                            ],
                                                          )),
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                      height: 0,
                                                    ),
                                                    SizedBox(
                                                      height: 53.5,
                                                      width: 100.w - 16,
                                                      child: MaterialButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            Navigator.pop(ctx);
                                                            pickImage(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            22,
                                                                        right:
                                                                            18),
                                                                child: Icon(
                                                                    FlutterRemix
                                                                        .gallery_fill,
                                                                    size: 20),
                                                              ),
                                                              (Text('사진 선택하기',
                                                                  style:
                                                                      textStyle20)),
                                                            ],
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ));
                                            });
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey),
                                          alignment: Alignment.center,
                                          child: const Text('사진 첨부하기',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white))),
                                    )
                                  ])
                            ],
                          )))),
              Column(
                children: [
                  Container(
                      width: 100.w - 32,
                      alignment: Alignment.centerRight,
                      child: Text('닉네임 및 사진은 나중에 변경하실수 있습니다.',
                          style: textStyle19)),
                  Container(
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
                        onPressed: () async {
                          widget.user['nickname'] = (inputNickname == '')
                              ? tempNickname
                              : inputNickname;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Login()));
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('이메일 인증'),
                                content:
                                    const Text('가입한 이메일의 메일을 통하여 간단한 인증하면 끝'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Approve'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          await postRequest(widget.user);
                        }),
                  )
                ],
              )
            ])));
  }
}
