// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ChangePhotoPage extends StatefulWidget {
//   @override
//   _ChangePhotoPageState createState() => _ChangePhotoPageState();
// }

// class _ChangePhotoPageState extends State<ChangePhotoPage> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;

//   Future<void> _pickImage() async {
// 	final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// 	setState(() {
// 	  _image = pickedFile;
// 	});
// 	// Logique pour sauvegarder ou utiliser l'image sélectionnée
//   }

//   @override
//   Widget build(BuildContext context) {
// 	return Scaffold(
// 	  appBar: AppBar(
// 		title: const Text('Changer la photo'),
// 	  ),
// 	  body: Center(
// 		child: Column(
// 		  mainAxisAlignment: MainAxisAlignment.center,
// 		  children: <Widget>[
// 			_image != null ? Image.file(File(_image!.path)) : const Text('Aucune image sélectionnée.'),
// 			ElevatedButton(
// 			  onPressed: _pickImage,
// 			  child: const Text('Sélectionner une image'),
// 			),
// 		  ],
// 		),
// 	  ),
// 	);
//   }
// }