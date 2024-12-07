import 'package:flutter/material.dart';

class ExpansionTextWidget extends StatefulWidget {
  final String titre;
  final String description;
  final String image;

  const ExpansionTextWidget({
    super.key,
    required this.titre,
    required this.description,
    required this.image,
  });

  @override
  State<ExpansionTextWidget> createState() => _ExpansionTextWidgetState();
}

class _ExpansionTextWidgetState extends State<ExpansionTextWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              // Utilisation de l'image passée en paramètre
              Image.asset(
                widget.image,
                width: 80,
                height: 50,
                fit: BoxFit.cover, // Ajout d'un fit pour une meilleure présentation
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titre,
                      style: const TextStyle(
                        color: Colors.white, // Changer la couleur pour plus de contraste
                        fontSize: 16, // Augmenter la taille pour une meilleure visibilité
                        fontWeight: FontWeight.bold, // Mettre en gras pour le titre
                      ),
                    ),
                    // Affichage de la description si nécessaire
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isExpanded
                ? Text(
                    widget.description,
                    style: const TextStyle(fontSize: 14, color: Colors.white), // Style pour la description
                  )
                : Container(), // Conteneur vide si non étendu
          ),
        ],
      ),
    );
  }
}