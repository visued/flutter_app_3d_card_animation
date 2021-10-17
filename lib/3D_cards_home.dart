import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_3d_card_animation/3D_cards_details.dart';
import 'package:flutter_app_3d_card_animation/cards.dart';

class CardsHome extends StatelessWidget {
  const CardsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Magic the Gathering',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => null,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: CardsBody(),
          ),
          Expanded(
            flex: 2,
            child: CardsHorizontal(),
          )
        ],
      ),
    );
  }
}

class CardsBody extends StatefulWidget {
  const CardsBody({Key? key}) : super(key: key);
  @override
  _CardsBodyState createState() => _CardsBodyState();
}

class _CardsBodyState extends State<CardsBody> with TickerProviderStateMixin {
  bool _selectedMode = false;
  late AnimationController _animationControllerSelection;
  late AnimationController _animationControllerMovement;
  int? _selectedIndex;

  Future<void> _onCardSelected(Card3D card, int index) async {
    setState(() {
      _selectedIndex = index;
    });

    final duration = Duration(milliseconds: 750);
    _animationControllerMovement.forward();
    ;
    await Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (context, animation, _) => FadeTransition(
            opacity: animation, child: CardsDetails(card: card))));
    _animationControllerMovement.reverse(from: 1.0);
  }

  int _getCurrentFactor(int currentIndex) {
    if (_selectedIndex == null || currentIndex == _selectedIndex) {
      return 0;
    } else if (currentIndex > _selectedIndex!) {
      return -1;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    _animationControllerSelection = AnimationController(
      vsync: this,
      lowerBound: 0.15,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 500),
    );

    _animationControllerMovement = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 880),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationControllerSelection.dispose();
    _animationControllerMovement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
            animation: _animationControllerSelection,
            builder: (context, snapshot) {
              final selectValue = _animationControllerSelection.value;
              return GestureDetector(
                onTap: () {
                  if (!_selectedMode) {
                    _animationControllerSelection
                        .forward()
                        .whenComplete(() => {_selectedMode = true});
                  } else {
                    _animationControllerSelection
                        .reverse()
                        .whenComplete(() => {_selectedMode = false});
                  }
                },
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(selectValue),
                  child: AbsorbPointer(
                    absorbing: !_selectedMode,
                    child: Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth * 0.50,
                      color: Colors.white,
                      child: Stack(clipBehavior: Clip.none, children: [
                        ...List.generate(
                            4,
                            (index) => Card3DItem(
                                height: constraints.maxHeight / 2,
                                card: cardList[index],
                                depth: index,
                                verticalFactor: _getCurrentFactor(index),
                                onCardSelected: (card) {
                                  _onCardSelected(card, index);
                                },
                                animation: _animationControllerMovement,
                                percent: selectValue)).reversed,
                      ]),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

class Card3DItem extends AnimatedWidget {
  const Card3DItem(
      {Key? key,
      required this.card,
      required this.percent,
      required this.height,
      required this.depth,
      required this.onCardSelected,
      required Animation<double> animation,
      this.verticalFactor = 0})
      : super(key: key, listenable: animation);

  final Card3D card;
  final double percent;
  final double height;
  final int depth;
  final ValueChanged<Card3D> onCardSelected;
  final int verticalFactor;
  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final depthFactor = 50.0;
    final bottomMargin = height / 4.0;
    return Positioned(
      child: Opacity(
        opacity: verticalFactor == 0 ? 1 : 1 - animation.value,
        child: Hero(
          tag: card.title,
          flightShuttleBuilder: (context, animation, flighDirection,
              fromHeroContext, toHeroContext) {
            Widget _current;
            if (flighDirection == HeroFlightDirection.push) {
              _current = toHeroContext.widget;
            } else {
              _current = fromHeroContext.widget;
            }


            return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final newValue = lerpDouble(0.0, 2 * pi, animation.value);
                  return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(newValue!),
                      child: _current);
                });
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(
                  0.0,
                  verticalFactor *
                      animation.value *
                      MediaQuery.of(context).size.height,
                  depth * depthFactor),
            child: GestureDetector(
              onTap: () {
                onCardSelected(card);
              },
              child: SizedBox(
                height: height,
                child: Card3DWidget(
                  card: card,
                ),
              ),
            ),
          ),
        ),
      ),
      left: 0,
      right: 0,
      top: height + -depth * height / 2.0 * percent - bottomMargin,
    );
  }
}

class CardsHorizontal extends StatelessWidget {
  const CardsHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Recently opened'),
        ),
        Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cardList.length,
                itemBuilder: (context, index) {
                  final card = cardList[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card3DWidget(card: card),
                  );
                }))
      ],
    );
  }
}

class Card3DWidget extends StatelessWidget {
  const Card3DWidget({Key? key, required this.card}) : super(key: key);
  final Card3D card;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(15.0);
    return PhysicalModel(
      elevation: 10,
      borderRadius: border,
      color: Colors.white,
      child: Image.asset(
        card.image,
        fit: BoxFit.cover,
      ),
    );
  }
}
