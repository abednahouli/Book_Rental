import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  

  File _image;

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 100,maxWidth: 150);

    setState(() {
      _image = image;
    });

    widget.imagePickFn(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image) : null,
          radius: 40,
        ),
        FlatButton.icon(
          onPressed:
              // ignore: unnecessary_statements
              getImage,
          textColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.image),
          label: Text('Add image'),
        ),
      ],
    );
  }
}
