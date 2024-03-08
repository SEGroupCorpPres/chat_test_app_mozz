import 'dart:io';

import 'package:chat_app_mozz_test/core/helpers/image_helper.dart';
import 'package:chat_app_mozz_test/models/message.dart';
import 'package:chat_app_mozz_test/models/user.dart';
import 'package:chat_app_mozz_test/repositories/message_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _messageController = TextEditingController();
  bool _isTextEmpty = true;
  final ImageHelper imageHelper = ImageHelper();
  FocusNode _messageFieldFocus = FocusNode();

  File? _image;
  List<File> _images = [];

  Widget _buildCupertinoImagePicker(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
            onPressed: () async {
              final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera);
              if (files.isNotEmpty) {
                final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
                if (croppedFile != null) {
                  setState(() => _image = File(croppedFile.path));
                }
              }
            },
            child: const Text('Camera')),
        CupertinoActionSheetAction(
          onPressed: () async {
            final List<XFile> files = await imageHelper.pickImage(multiple: true);
            if (files.isNotEmpty) {
              if (files.length == 1) {
                final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
                if (croppedFile != null) {
                  setState(() => _image = File(croppedFile.path));
                }
              } else {
                setState(() => _images = files.map((e) => File(e.path)).toList());
                print(_images.map((e) => print(e.path)).toList());
              }
            }
          },
          child: const Text('Select photo'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
    );
  }

  Future<dynamic> _showMaterialImageDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Пожалуйста, выберите опцию',
            style: GoogleFonts.montserrat(
              color: Colors.greenAccent,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            MaterialButton(
              splashColor: Colors.lightGreenAccent,
              onPressed: () async {
                final List<XFile> files = await imageHelper.pickImage(source: ImageSource.camera);
                if (files.isNotEmpty) {
                  final croppedFile = await imageHelper.crop(file: files.single, cropStyle: CropStyle.rectangle);
                  if (croppedFile != null) {
                    setState(() => _image = File(croppedFile.path));
                  }
                  await MessageRepository.sendChatImage(widget.userModel, _image!);
                }
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.camera,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Камера',
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              splashColor: Colors.lightGreenAccent,
              onPressed: () async {
                final List<XFile> files = await imageHelper.pickImage(multiple: true);
                if (files.isNotEmpty) {
                  if (files.length == 1) {
                    final croppedFile = await imageHelper.crop(file: files.first, cropStyle: CropStyle.rectangle);
                    if (croppedFile != null) {
                      setState(() => _image = File(croppedFile.path));
                    }
                    await MessageRepository.sendChatImage(widget.userModel, _image!);
                  } else {
                    setState(() => _images = files.map((e) => File(e.path)).toList());
                    print(_images.toList());
                    _images.map((e) async => await MessageRepository.sendChatImage(widget.userModel, e));
                  }
                }
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.image,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Галерея',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 40, top: 10),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: .3)), color: Colors.white),
      width: size.width,
      height: 80.h,
      constraints: const BoxConstraints(maxHeight: 200, minHeight: 75),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _isTextEmpty
              ? Container(
                  padding: EdgeInsets.zero,
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFEDF2F6),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Platform.isIOS ? showCupertinoModalPopup(context: context, builder: _buildCupertinoImagePicker) : _showMaterialImageDialog();
                    },
                    icon: const Icon(Icons.attach_file),
                  ),
                )
              : Container(),
          Container(
            width: _isTextEmpty ? 220 : size.width - 100,
            // height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFEDF2F6),
            ),
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: TextField(
              onChanged: (text) {
                if (text.isNotEmpty) {
                  _isTextEmpty = false;
                } else {
                  _isTextEmpty = true;
                }
                setState(() {});
              },
              focusNode: _messageFieldFocus,
              maxLines: 10,
              minLines: 1,
              controller: _messageController,
              decoration: const InputDecoration(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  // minHeight: 75
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border: InputBorder.none,
                isDense: true,
                fillColor: Colors.grey,
                hoverColor: Colors.red,
                focusColor: Colors.green,
                hintText: 'Сообщение',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _isTextEmpty
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.mic),
                  )
                : IconButton(
                    onPressed: () {
                      print('send message');
                      print(_messageController.text);
                      if (_messageController.text.isNotEmpty) {
                        MessageRepository.sendMessage(widget.userModel, _messageController.text, Type.text).onError(
                          (e, _) => print("Error writing document: $e"),
                        );
                        _messageController.text = '';
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.send),
                  ),
          ),
        ],
      ),
    );
  }
}
