import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_3d_card_animation/3D_cards_home.dart';
import 'package:flutter_app_3d_card_animation/cards.dart';

class CardsDetails extends StatelessWidget {
  const CardsDetails({Key? key, required this.card}) : super(key: key);
  final Card3D card;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black45),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Align(
              child: SizedBox(
                  height: 300.0,
                  child:
                      Hero(tag: card.title, child: Card3DWidget(card: card)))),
          const SizedBox(
            height: 20,
          ),
          Text(card.title,
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold)),
          Text(card.author,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
