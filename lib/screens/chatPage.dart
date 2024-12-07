import 'package:flutter/material.dart';
import 'package:huduma/utils/user_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Message {
  final String text;
  final bool isUser;
  final String? imageUrl;

  Message({required this.text, required this.isUser, this.imageUrl});
}

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> option;

  const ChatPage({super.key, required this.option});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  String? userUID;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool isLoading = false; // Indicateur de chargement pour l'image

  @override
  void initState() {
    super.initState();
    _loadUserUID();
    _fetchMessages();
  }

  Future<void> _loadUserUID() async {
    userUID = await UserPreferences.getUserUID();
    setState(() {});
  }

  Future<void> _sendMessage({String? imageUrl}) async {
    if (_controller.text.isNotEmpty || imageUrl != null) {
      final message = {
        'userUID': userUID,
        'title': widget.option['title'],
        'message': _controller.text,
        'imageUrl': imageUrl,
        'date': FieldValue.serverTimestamp(),
        'is_readed': false,
      };

      try {
        await _firestore.collection('chats').add(message);
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi du message: $e')),
        );
      }
    }
  }

  Future<void> _fetchMessages() async {
    _firestore
        .collection('chats')
        .where('title', isEqualTo: widget.option['title'])
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        messages.clear();
        for (var doc in snapshot.docs) {
          messages.add(Message(
            text: doc['message'],
            isUser: doc['userUID'] == userUID,
            imageUrl: doc['imageUrl'], // Récupérer l'URL de l'image
          ));
        }
      });
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        isLoading = true; // Démarrer le chargement
      });
      String imageUrl = await _uploadImage(File(image.path));
      _sendMessage(imageUrl: imageUrl); // Envoyer le message avec l'URL de l'image
      setState(() {
        isLoading = false; // Fin du chargement
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      String filePath = 'chat_images/${DateTime.now().millisecondsSinceEpoch}.png';
      await _storage.ref(filePath).putFile(image);
      String downloadUrl = await _storage.ref(filePath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Échec du téléchargement de l\'image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat d\'Urgence ${widget.option['title']}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Pour afficher les messages les plus récents en haut
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: messages[index].isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: messages[index].isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: messages[index].isUser
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messages[index].text,
                          style: TextStyle(
                            color: messages[index].isUser
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      if (messages[index].imageUrl != null && messages[index].imageUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Image.network(
                            messages[index].imageUrl!,
                            width: 200, // Ajustez la largeur selon vos besoins
                            height: 200, // Ajustez la hauteur selon vos besoins
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
          if (isLoading) // Indicateur de chargement pendant le téléchargement de l'image
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}