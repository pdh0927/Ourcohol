import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class MyInformation extends StatefulWidget {
  const MyInformation({super.key});

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  bool _isEnabled = false;
  TextEditingController _nicknameController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  void _onEditingComplete() {
    // 그냥 변경 안눌렀을 때 원래의 닉네임이 저장
    setState(() {
      _isEnabled = false;
      _nicknameController =
          TextEditingController(text: context.read<UserProvider>().nickname);
    });
  }

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

  logout() async {
    context.read<UserProvider>().initUserInformation(); // provider 정보 초기화
    await context.read<UserProvider>().storage.delete(key: 'login');
  }

  getAmountAlcoholList() {
    List<PopupMenuEntry<double>> childs = [];

    for (int i = 1; i <= 20; i++) {
      childs.add(PopupMenuItem<double>(
        value: i * 0.5,
        child: SizedBox(
          width: 100.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${i * 0.5}병',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff131313),
                      fontWeight: FontWeight.w400,
                      height: 1.3)),
              context.read<UserProvider>().amount_alcohol == i * 0.5
                  ? const Icon(FlutterRemix.check_line, size: 20)
                  : const Icon(FlutterRemix.check_line, size: 0)
            ],
          ),
        ),
      ));
    }

    return childs;
  }

  Future<void> modifyMyInformation(key, value) async {
    http.StreamedResponse response;
    try {
      var dio = Dio();
      var formData;
      if (key != 'image') {
        formData = FormData.fromMap({key: value});
      } else {
        var file = File(resultImage!.path); // 파일 객체 생성

        var fileSize = await file.length(); // 파일 크기 확인
        print('File size: $fileSize bytes'); // 파일 크기 출력
        formData = FormData.fromMap(
            {'image': await MultipartFile.fromFile(resultImage!.path)});
      }
      final options = Options(headers: {
        'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}'
      });

      // 업로드 요청
      final response = await dio.patch(
          'http://127.0.0.1:8000/api/accounts/${context.read<UserProvider>().userId}/',
          //'http://ourcohol-server-dev.ap-northeast-2.elasticbeanstalk.com/api/accounts/${context.read<UserProvider>().userId}/',
          data: formData,
          options: options);

      setState(() {
        context.read<UserProvider>().image_memory =
            response.data['image_memory'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    _nicknameController =
        TextEditingController(text: context.read<UserProvider>().nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100.w - 40,
                          margin: const EdgeInsets.only(
                              bottom: 20, right: 20, left: 20),
                          child: const Text('내 정보',
                              style: TextStyle(
                                  fontSize: 33,
                                  color: Color(0xff131313),
                                  fontWeight: FontWeight.w700,
                                  height: 1.3)),
                        ),
                        Container(
                          width: 100.w - 40,
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  (context.read<UserProvider>().image_memory !=
                                          ''
                                      ? Container(
                                          width: 100 / 393 * 100.w,
                                          height: 100 / 393 * 100.w,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: MemoryImage(
                                                      base64Decode(context
                                                          .read<UserProvider>()
                                                          .image_memory)),
                                                  fit: BoxFit.fill)))
                                      : Container(
                                          width: 100 / 393 * 100.w,
                                          height: 100 / 393 * 100.w,
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Color(colorList[context
                                                    .read<UserProvider>()
                                                    .userId %
                                                7]),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Icon(FlutterRemix.user_fill,
                                              color: Colors.white,
                                              size: 75 / 393 * 100.w))),
                                  Container(
                                    height: 30 / 393 * 100.w,
                                    width: 30 / 393 * 100.w,
                                    margin: EdgeInsets.only(
                                        left: 70 / 393 * 100.w,
                                        top: 60 / 393 * 100.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        shape: BoxShape.circle,
                                        color: const Color(0xffFFFFFF)),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        await pickImage(ImageSource.gallery);
                                        if (resultImage != null) {
                                          await modifyMyInformation(
                                              'image', resultImage);
                                        }
                                      },
                                      icon: Icon(FlutterRemix.camera_line,
                                          color: Colors.grey,
                                          size: 25 / 393 * 100.w),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: (100.w - 32) / 6,
                                width: 150,
                                margin: const EdgeInsets.only(left: 25),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextField(
                                  enabled: _isEnabled,
                                  controller: _nicknameController,
                                  focusNode: myFocusNode,
                                  onEditingComplete: _onEditingComplete,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLength: 8,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  style: const TextStyle(
                                      fontSize: 20, color: Color(0xff131313)),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '1글자 이상 입력',
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff686868)),
                                      filled: true,
                                      fillColor: Color(0xffFFFFFF),
                                      counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: (100.w - 32) / 9,
                                height: (100.w - 32) / 9,
                                child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      if (_isEnabled == true &&
                                          _nicknameController.text != '') {
                                        context.read<UserProvider>().nickname =
                                            _nicknameController.text;
                                        setState(() {
                                          _isEnabled = !_isEnabled;
                                        });
                                        await modifyMyInformation('nickname',
                                            _nicknameController.text);
                                      } else if (_isEnabled == true &&
                                          _nicknameController.text == '') {
                                        setState(() {
                                          _nicknameController.text = context
                                              .read<UserProvider>()
                                              .nickname;
                                          _isEnabled = !_isEnabled;
                                        });
                                      } else {
                                        setState(() {
                                          _isEnabled = !_isEnabled;
                                        });
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          // 위의 isenabled가 바뀌기 전 호출되어 callback하도록
                                          if (_isEnabled) {
                                            myFocusNode.requestFocus();
                                          }
                                        });
                                      }
                                    },
                                    child: Icon(
                                        _isEnabled == false
                                            ? FlutterRemix.edit_2_line
                                            : FlutterRemix.check_line,
                                        size: 25)),
                              )
                            ],
                          ),
                        ),
                        Container(
                            width: 100.w - 40,
                            height: 40,
                            margin: const EdgeInsets.only(
                                top: 20, right: 20, left: 20),
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('초대 코드',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w700,
                                        height: 1.3)),
                                Text('${context.read<UserProvider>().userId}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w700,
                                        height: 1.3))
                              ],
                            )),
                        Container(
                          width: 100.w - 40,
                          margin: const EdgeInsets.only(
                              top: 25, right: 20, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('주량 설정',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff131313),
                                      fontWeight: FontWeight.w700,
                                      height: 1.3)),
                              Container(
                                  width: 100.w - 40,
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(
                                      right: 40 / 393 * 100.w,
                                      left: 40 / 393 * 100.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xff131313))),
                                  child: Column(
                                    children: [
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        offset: const Offset(0, -1),
                                        child: Container(
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              right: 8 / 393 * 100.w,
                                              left: 8 / 393 * 100.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  context
                                                              .read<
                                                                  UserProvider>()
                                                              .type_alcohol ==
                                                          'soju'
                                                      ? '소주'
                                                      : '맥주',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xff131313),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.3)),
                                              const Icon(
                                                  FlutterRemix
                                                      .arrow_drop_down_fill,
                                                  size: 40)
                                            ],
                                          ),
                                        ),
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'soju',
                                            child: SizedBox(
                                              width: 100.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('소주',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xff131313),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.3)),
                                                  context
                                                              .read<
                                                                  UserProvider>()
                                                              .type_alcohol ==
                                                          'soju'
                                                      ? const Icon(
                                                          FlutterRemix
                                                              .check_line,
                                                          size: 20)
                                                      : const Icon(
                                                          FlutterRemix
                                                              .check_line,
                                                          size: 0)
                                                ],
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'beer',
                                            child: SizedBox(
                                              width: 100.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text('맥주',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xff131313),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.3)),
                                                  context
                                                              .read<
                                                                  UserProvider>()
                                                              .type_alcohol !=
                                                          'soju'
                                                      ? const Icon(
                                                          FlutterRemix
                                                              .check_line,
                                                          size: 20)
                                                      : const Icon(
                                                          FlutterRemix
                                                              .check_line,
                                                          size: 0)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                        onSelected: (String value) async {
                                          setState(() {
                                            context
                                                .read<UserProvider>()
                                                .type_alcohol = value;
                                          });
                                          await modifyMyInformation(
                                              'type_alcohol', value);
                                        },
                                      ),
                                      const Divider(
                                        height: 0,
                                        thickness: 1,
                                      ),
                                      PopupMenuButton<double>(
                                        padding: EdgeInsets.zero,
                                        offset: Offset(0, -1),
                                        child: Container(
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              right: 8 / 393 * 100.w,
                                              left: 8 / 393 * 100.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${context.read<UserProvider>().amount_alcohol}병',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xff131313),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.3)),
                                              const Icon(
                                                  FlutterRemix
                                                      .arrow_drop_down_fill,
                                                  size: 40)
                                            ],
                                          ),
                                        ),
                                        itemBuilder: (BuildContext context) =>
                                            getAmountAlcoholList(),
                                        onSelected: (double value) async {
                                          setState(() {
                                            context
                                                .read<UserProvider>()
                                                .amount_alcohol = value;
                                          });
                                          await modifyMyInformation(
                                              'amount_alcohol', value);
                                        },
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: 100.w - 40,
                          margin: const EdgeInsets.only(
                              top: 25, right: 20, left: 20, bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('술자리 유형 검사 ACTI',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff131313),
                                      fontWeight: FontWeight.w700,
                                      height: 1.3)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('ACTI가 없습니다!',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff131313),
                                          fontWeight: FontWeight.w400,
                                          height: 1.3)),
                                  MaterialButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      child: Row(
                                        children: const [
                                          Text('검사하기',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xff131313),
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.3)),
                                          Icon(FlutterRemix.arrow_right_s_fill)
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100.w - 40,
                          margin: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('고객센터',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff131313),
                                      fontWeight: FontWeight.w700,
                                      height: 1.3)),
                              MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  child: Row(
                                    children: const [
                                      Text('개발자와 소통하기',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff131313),
                                              fontWeight: FontWeight.w400,
                                              height: 1.3)),
                                      Icon(FlutterRemix.arrow_right_s_fill)
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Container(
                            width: 100.w,
                            decoration:
                                const BoxDecoration(color: Color(0xffDADADA)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('${context.read<UserProvider>().email}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff131313),
                                        fontWeight: FontWeight.w400,
                                        height: 1.3)),
                                MaterialButton(
                                    onPressed: () async {
                                      await logout();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('로그아웃',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff131313),
                                            fontWeight: FontWeight.w400,
                                            height: 1.3))),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
