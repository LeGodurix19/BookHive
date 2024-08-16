import 'package:betta/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class ProfilCustom extends StatefulWidget {

  const ProfilCustom({super.key });

  @override
  // ignore: library_private_types_in_public_api
  _ProfilCustomState createState() => _ProfilCustomState();
}

class _ProfilCustomState extends State<ProfilCustom> {
  final TextEditingController _pseudoController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });
    String pseudo = _pseudoController.text;
    String? imagePath = _imageFile?.path;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (imagePath != null) {
      try {
        // Upload de l'image sur Firebase Storage
        File file = File(imagePath);
        String fileName = 'profile_images/$uid.jpg';
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(file);

        // Récupérer l'URL de téléchargement de l'image
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Mettre à jour Firestore avec le pseudo et l'URL de l'image
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'username': pseudo,
          'Picture': downloadUrl,
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès.')),
        );
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          "firstTime": false,
        });
      } catch (e) {
        setState(() {
              _isLoading = false;
            });
        print('Erreur lors de la mise à jour du profil : $e');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour du profil.')),
        );
      }
    } else {
      // Mettre à jour uniquement le pseudo si aucune image n'est sélectionnée
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'pseudo': pseudo,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pseudo mis à jour avec succès.')),
        );
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          "firstTime": false,
        });
      } catch (e) {
        print('Erreur lors de la mise à jour du pseudo : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour du pseudo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Définir Pseudo & Image'),
      ),
      body: (_isLoading) ? const Center(child: CircularProgressIndicator()) :
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pseudoController,
              decoration: const InputDecoration(
                labelText: 'Entrez votre pseudo',
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? const Icon(Icons.add_a_photo, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}