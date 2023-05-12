import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:http/http.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourcohol/home/tabs/party_page/plus_menu.dart';
import 'package:ourcohol/home/tabs/party_page/popup_munu.dart';

import 'package:ourcohol/provider_ourcohol.dart';
import 'package:http/http.dart' as http;
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class ActiveParty extends StatefulWidget {
  ActiveParty({super.key, this.updateParty, this.rebuild1, this.rebuild2});
  var updateParty;
  var rebuild1;
  var rebuild2;
  @override
  State<ActiveParty> createState() => _ActivePartyState();
}

class _ActivePartyState extends State<ActiveParty> {
  int count = 0;
  int sojuStandard = 8;
  int beerStandard = 3;
  int kingAlcohol = -1;
  int lastAlcohol = 999999;

  addPicture() async {
    http.StreamedResponse response;
    try {
      if (Platform.isIOS) {
        String url =
            "http://127.0.0.1:8000/api/party/${context.read<PartyProvider>().partyId}/";
        var request = http.MultipartRequest(
          'PATCH',
          Uri.parse(url),
        );
        request.headers.addAll({
          'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}'
        });
        request.files
            .add(await http.MultipartFile.fromPath('image', resultImage!.path));

        response = await request.send();
      } else {
        String url =
            "http://10.0.2.2:8000/api/party/${context.read<PartyProvider>().partyId}/";
        var request = http.MultipartRequest('PATCH', Uri.parse(url));
        request.headers.addAll({
          'Authorization': 'Bearer ${context.read<UserProvider>().tokenAccess}'
        });
        request.files
            .add(await http.MultipartFile.fromPath('image', resultImage!.path));

        response = await request.send();
      }
      if (response.statusCode == 200) {
        print('사진 잘 올리감');
      } else {
        print('사진 잘 못 올리감');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  setKingAndLast() {
    kingAlcohol = context.read<PartyProvider>().participants[0]['drank_beer'] +
        context.read<PartyProvider>().participants[0]['drank_soju'];
    lastAlcohol = context.read<PartyProvider>().participants[0]['drank_beer'] +
        context.read<PartyProvider>().participants[0]['drank_soju'];
    for (int i = 1;
        i < context.read<PartyProvider>().participants.length;
        i++) {
      if (context.read<PartyProvider>().participants[i]['drank_beer'] +
              context.read<PartyProvider>().participants[i]['drank_soju'] >
          kingAlcohol) {
        kingAlcohol = context.read<PartyProvider>().participants[i]
                ['drank_beer'] +
            context.read<PartyProvider>().participants[i]['drank_soju'];
      }
      if (context.read<PartyProvider>().participants[i]['drank_beer'] +
              context.read<PartyProvider>().participants[i]['drank_soju'] <
          lastAlcohol) {
        lastAlcohol = context.read<PartyProvider>().participants[i]
                ['drank_beer'] +
            context.read<PartyProvider>().participants[i]['drank_soju'];
      }
    }
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

  getTabeHorizon() {
    setKingAndLast();
    int tepCount = count;
    List<Widget> childs = [];
    for (int i = tepCount; i < tepCount + 2; i++) {
      childs.add(Container(
          width: (100.w - 32) / 2,
          height: (100.w - 50) / 2,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 13, bottom: 2),
          decoration: BoxDecoration(
              color: (i % 4 == 1 || i % 4 == 2)
                  ? const Color(0xff8F8F8F)
                  : const Color(0xffEAEAEA)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (context.read<PartyProvider>().participants[i]['user']
                              ['image_memory'] !=
                          null
                      ? Container(
                          width: (100.w - 50) / 7,
                          height: (100.w - 50) / 7,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: MemoryImage(base64Decode(context
                                          .read<PartyProvider>()
                                          .participants[i]['user']
                                      ['image_memory'])),
                                  fit: BoxFit.fill)))
                      : Container(
                          width: (100.w - 50) / 7,
                          height: (100.w - 50) / 7,
                          decoration: BoxDecoration(
                            color: Color(colorList[context
                                    .read<PartyProvider>()
                                    .participants[i]['id'] %
                                7]),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(FlutterRemix.user_2_fill,
                              color: Colors.white, size: 40))),
                  Container(
                    width: (100.w - 50) / 8,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (context.read<PartyProvider>().participants[i]
                                        ['drank_beer'] +
                                    context
                                        .read<PartyProvider>()
                                        .participants[i]['drank_soju']) ==
                                kingAlcohol
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FlutterRemix.vip_crown_fill,
                                      color: Color(0xffFFDE2F)),
                                  Text(
                                    '술고래',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: "GowunBatang",
                                        color: Color(0xffFFDE2F),
                                        fontWeight: FontWeight.w700,
                                        height: 1.3),
                                  )
                                ],
                              )
                            : (context.read<PartyProvider>().participants[i]
                                            ['drank_beer'] +
                                        context
                                            .read<PartyProvider>()
                                            .participants[i]['drank_soju']) ==
                                    lastAlcohol
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(FlutterRemix.delete_bin_2_fill,
                                          color: Color(0xff131313)),
                                      Text(
                                        '알쓰',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: "GowunBatang",
                                            color: Color(0xff131313),
                                            fontWeight: FontWeight.w700,
                                            height: 1.3),
                                      )
                                    ],
                                  )
                                : const Icon(FlutterRemix.vip_crown_fill,
                                    size: 0),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: (15 / 393 * 100).w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: (10 / 393 * 100).w),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              context.read<PartyProvider>().participants[i]
                                  ['user']['nickname'],
                              style: textStyle14),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              context.read<PartyProvider>().participants[i]
                                              ['drank_soju'] /
                                          sojuStandard >
                                      0
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          (context.read<PartyProvider>().participants[
                                                              i]['drank_soju'] /
                                                          sojuStandard)
                                                      .toInt() >
                                                  0
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 13 / 393 * 100.w),
                                                  child: Column(children: [
                                                    Container(
                                                        width: (100.w - 50) / 9,
                                                        height:
                                                            (100.w - 50) / 9,
                                                        margin: const EdgeInsets
                                                            .only(bottom: 3),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/soju_bottle.png',
                                                          fit: BoxFit.fill,
                                                        )),
                                                    Text(
                                                        'X${(context.read<PartyProvider>().participants[i]['drank_soju'] / sojuStandard).toInt()}',
                                                        style: textStyle23)
                                                  ]),
                                                )
                                              : const SizedBox(
                                                  height: 0, width: 0),
                                          context
                                                              .read<PartyProvider>()
                                                              .participants[i]
                                                          ['drank_soju'] %
                                                      sojuStandard >
                                                  0
                                              ? Column(children: [
                                                  Container(
                                                      width: (100.w - 50) / 9,
                                                      height: (100.w - 50) / 9,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 3),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/soju.png',
                                                        fit: BoxFit.fill,
                                                      )),
                                                  Text(
                                                      'X${context.read<PartyProvider>().participants[i]['drank_soju'] % sojuStandard}',
                                                      style: textStyle23)
                                                ])
                                              : const SizedBox(
                                                  height: 0, width: 0),
                                        ],
                                      ))
                                  : const SizedBox(height: 0, width: 0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (context.read<PartyProvider>().participants[i]
                                                      ['drank_beer'] /
                                                  beerStandard)
                                              .toInt() >
                                          0
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              right: 13 / 393 * 100.w),
                                          child: Column(children: [
                                            Container(
                                                width: (100.w - 50) / 9,
                                                height: (100.w - 50) / 9,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    bottom: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/beer_bottle.png',
                                                  fit: BoxFit.fill,
                                                )),
                                            Text(
                                                'X${(context.read<PartyProvider>().participants[i]['drank_beer'] / beerStandard).toInt()}',
                                                style: textStyle23)
                                          ]),
                                        )
                                      : const SizedBox(height: 0, width: 0),
                                  context.read<PartyProvider>().participants[i]
                                                  ['drank_beer'] %
                                              beerStandard >
                                          0
                                      ? Column(children: [
                                          Container(
                                              width: (100.w - 50) / 9,
                                              height: (100.w - 50) / 9,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Image.asset(
                                                'assets/images/beer.png',
                                                fit: BoxFit.fill,
                                              )),
                                          Text(
                                              'X${context.read<PartyProvider>().participants[i]['drank_beer'] % beerStandard}',
                                              style: textStyle23)
                                        ])
                                      : const SizedBox(height: 0, width: 0),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              )
            ],
          )));
      count++;
      if (count == context.read<PartyProvider>().participants.length) {
        break;
      }
    }
    return Row(children: childs);
  }

  getTable() {
    List<Widget> childs = [];

    for (int i = 0;
        i < (context.read<PartyProvider>().participants.length) / 2;
        i++) {
      childs.add(getTabeHorizon());
    }

    return childs;
  }

  Future _modifyAlcohol(String modifyType, String alcoholType) async {
    http.Response response;
    http.Response response2;
    if (Platform.isIOS) {
      response = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/api/participant/${modifyType}/${alcoholType}/${context.read<PartyProvider>().participants[context.read<PartyProvider>().myPaticipantIndex]['id']}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
      response2 = await http.get(
          Uri.parse(
              'http://127.0.0.1:8000/api/party/${modifyType}/${alcoholType}/${context.read<PartyProvider>().partyId}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
    } else {
      response = await http.get(
          Uri.parse(
              'http://10.0.2.2:8000/api/participant/${modifyType}/${alcoholType}/${context.read<PartyProvider>().participants[context.read<PartyProvider>().myPaticipantIndex]['id']}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
      response2 = await http.get(
          Uri.parse(
              'http://10.0.2.2:8000/api/party/${modifyType}/${alcoholType}/${context.read<PartyProvider>().partyId}/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer ${context.read<UserProvider>().tokenAccess}',
          });
    }
    return;
  }

  modifyAlcohol(String modifyType, String alcoholType) {
    if (modifyType == 'minus') {
      if ((alcoholType == 'soju' &&
              context.read<PartyProvider>().participants[context
                      .read<PartyProvider>()
                      .myPaticipantIndex]['drank_soju'] ==
                  0) ||
          (alcoholType == 'beer' &&
              context.read<PartyProvider>().participants[context
                      .read<PartyProvider>()
                      .myPaticipantIndex]['drank_beer'] ==
                  0)) {
        // 먹고빼라 알림
        return;
      }
    } else {
      if ((alcoholType == 'soju' &&
              context.read<PartyProvider>().participants[context
                      .read<PartyProvider>()
                      .myPaticipantIndex]['drank_soju'] ==
                  sojuStandard * 100) ||
          (alcoholType == 'beer' &&
              context.read<PartyProvider>().participants[context
                      .read<PartyProvider>()
                      .myPaticipantIndex]['drank_beer'] ==
                  beerStandard * 100)) {
        // 더 먹으면 사망합니다 알림
        return;
      }
    }

    _modifyAlcohol(modifyType, alcoholType);
    setState(() {
      if (alcoholType == 'soju') {
        if (modifyType == 'add') {
          context
                  .read<PartyProvider>()
                  .participants[context.read<PartyProvider>().myPaticipantIndex]
              ['drank_soju']++;
          context.read<PartyProvider>().drank_soju++;
        } else {
          context
                  .read<PartyProvider>()
                  .participants[context.read<PartyProvider>().myPaticipantIndex]
              ['drank_soju']--;
          context.read<PartyProvider>().drank_soju--;
        }
      } else {
        if (modifyType == 'add') {
          context
                  .read<PartyProvider>()
                  .participants[context.read<PartyProvider>().myPaticipantIndex]
              ['drank_beer']++;
          context.read<PartyProvider>().drank_beer++;
        } else {
          context
                  .read<PartyProvider>()
                  .participants[context.read<PartyProvider>().myPaticipantIndex]
              ['drank_beer']--;
          context.read<PartyProvider>().drank_beer--;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    count = 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          PopupMenu(
              rebuild1: widget.rebuild1,
              rebuild2: widget.rebuild2,
              updateParty: widget.updateParty)
        ],
      ),
      floatingActionButton: PlusMenu(modifyAlcohol: modifyAlcohol),
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Container(
            width: 100.w,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: 100.w - 32,
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 20),
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Text(context.read<PartyProvider>().name,
                                  style: textStyle22)),
                          context.read<PartyProvider>().image_memory != ''
                              ? Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  width: 100.w - 32 - 50,
                                  height: (100.w - 32 - 50) / 7 * 5,
                                  child: Image.memory(
                                    base64Decode(context
                                        .read<PartyProvider>()
                                        .image_memory),
                                    fit: BoxFit.fill,
                                  ))
                              : Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  width: 100.w - 32 - 50,
                                  height: (100.w - 32 - 50) / 7 * 5,
                                  child: MaterialButton(
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('!!주의!!'),
                                              content: const Text(
                                                  '한번 찍으면 돌이킬수 없습니다!'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('확인'),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    print('before');
                                                    await pickImage(
                                                        ImageSource.camera);
                                                    print('after');
                                                    await addPicture();
                                                    widget.rebuild2();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text('우리들의 추억을 남겨보세요 :)')))
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w - 32,
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 15),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('우리들의 테이블', style: textStyle14),
                                Container(
                                  width: 25,
                                  height: 25,
                                  child: MaterialButton(
                                    minWidth: 0,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      widget.rebuild2();
                                    },
                                    child: const Icon(FlutterRemix.refresh_line,
                                        size: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: getTable(),
                          ))
                        ],
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
