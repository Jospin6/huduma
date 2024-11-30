import 'package:flutter/material.dart';

class ExpansionTextWidget extends StatefulWidget {
  const ExpansionTextWidget({super.key});

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
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text 1',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      'Text 2',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
                ? const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  )
                : Container(), // Utilisez un Container vide si non étendu
          ),
        ],
      ),
    );
  }
}