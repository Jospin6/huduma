import 'package:flutter/material.dart';

class ExpansionTextWidget extends StatefulWidget {
  final String titre;
  final String description;
  final String image;
  const ExpansionTextWidget({super.key, required this.titre, required this.description, required this.image});

  @override
  // ignore: library_private_types_in_public_api
  _ExpansionTextWidgetState createState() => _ExpansionTextWidgetState();
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
              Image.asset(
                'assets/images/viol.png', 
                width: 80,
                height: 50,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titre,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    // Text(
                    //   widget.description,
                    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
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
                  )
                : Container(), // Utilisez un Container vide si non étendu
          ),
        ],
      ),
    );
  }
}