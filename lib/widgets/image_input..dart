import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath ;

class ImageInput extends StatefulWidget {


  final Function onSavedImage;
  ImageInput(this.onSavedImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {

  File? _storedImage;
  Future<void> _takePicture() async {
    final picker = ImagePicker();
   final imageXFile = await  picker.pickImage(source: ImageSource.camera,maxWidth: 600);
   if (imageXFile == null) {
     return;
   }
   final imageFile = File(imageXFile!.path);
  setState(() {
    _storedImage = imageFile;
  });
final appDir = await syspath.getApplicationDocumentsDirectory();
final fileName = path.basename(imageFile!.path);
  final savedImage = await imageFile!.copy('${appDir.path}/$fileName');
    widget.onSavedImage(_storedImage as File);

    print('${appDir.path}');
    print('$fileName');
    print('$savedImage.path');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text('No image taken yet'),
          alignment: Alignment.center,
        ),
        Expanded(
          child: TextButton.icon(
              onPressed:_takePicture,
              label: Text(
                'Open camera',
                // style: TextStyle(color: Theme.of(context).colorScheme.secondary),textAlign: TextAlign.center,
              ),
              icon: Icon(Icons.camera,),
              // style: ButtonStyle(
              //     backgroundColor: MaterialStateColor.resolveWith(
              //   (states) => Theme.of(context).primaryColor,
              // )),
            ),
        ),
      ],
    );
  }
}
