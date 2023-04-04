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
                    Stack(
                      children: [
                        (context.read<UserProvider>().image_memory != null
                            ? Container(
                                width: 100 / 852 * 100.h,
                                height: 100 / 852 * 100.h,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: MemoryImage(base64Decode(context
                                            .read<UserProvider>()
                                            .image_memory)),
                                        fit: BoxFit.fill)))
                            : Container(
                                width: 100 / 852 * 100.h,
                                height: 100 / 852 * 100.h,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Color(colorList[
                                      context.read<UserProvider>().userId % 7]),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(FlutterRemix.user_fill,
                                    color: Colors.white,
                                    size: 75 / 393 * 100.w))),
                        Container(
                          height: 30 / 393 * 100.w,
                          width: 30 / 393 * 100.w,
                          margin: EdgeInsets.only(
                              left: 70 / 393 * 100.w, top: 60 / 393 * 100.w),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.circle,
                              color: const Color(0xffFFFFFF)),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              await pickImage(ImageSource.gallery);
                            },
                            icon: Icon(FlutterRemix.camera_line,
                                color: Colors.grey, size: 25 / 393 * 100.w),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
