import 'package:flutter/material.dart';
import 'package:huduma/screens/widgets/expansionTextWidget.dart';

class DetailPage extends StatelessWidget {
  final Map<String, String> emergencyDetail;

  const DetailPage(this.emergencyDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(emergencyDetail['title']!),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(emergencyDetail['image']!),
                        fit: BoxFit.cover)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icône de flèche arrière et titre
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            // Action pour le bouton de retour
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          emergencyDetail['title']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    // Bouton ElevatedButton
                    ElevatedButton(
                      onPressed: () {
                        // Action pour le bouton
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                            .withOpacity(0.3), // Couleur rouge avec opacité
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)), // Radius de 10
                        ),
                      ),
                      child: const Text(
                        'Appeler',
                        style: TextStyle(color: Colors.white), // Texte en blanc
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Column(
                  children: [
                    Text(
                      emergencyDetail['details']!,
                      style: const TextStyle(fontSize: 18),
                    ),

                    // AUTRES INFORMATIONS

                    const ExpansionTextWidget()
                
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}
