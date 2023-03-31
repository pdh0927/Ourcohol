import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourcohol/provider_ourcohol.dart';
import 'package:ourcohol/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MyInformation extends StatefulWidget {
  const MyInformation({super.key});

  @override
  State<MyInformation> createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
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
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Text('내 정보'),
                Row(
                  children: [
                    (context.read<UserProvider>().image_memory != null
                        ? Container(
                            width: 150 / 852 * 100.h,
                            height: 150 / 852 * 100.h,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: MemoryImage(base64Decode(context
                                        .read<UserProvider>()
                                        .image_memory)),
                                    fit: BoxFit.fill)))
                        : Container(
                            width: (100.w - 50) / 7,
                            height: (100.w - 50) / 7,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Color(colorList[
                                  context.read<PartyProvider>().participants[
                                          context
                                              .read<PartyProvider>()
                                              .myPaticipantIndex]['id'] %
                                      7]),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(FlutterRemix.user_2_fill,
                                color: Colors.white, size: 40 / 852 * 100.h)))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
