class Card3D {
  const Card3D({required this.author, required this.title, required this.image});
  
  final String author;
  final String title;
  final String image;
}

const _path = 'assets/images';

final cardList = [
  Card3D(author: 'Erica Yang', title: 'Abomination of Gudul', image: '$_path/1.png'),
  Card3D(author: 'Vincent Proce', title: 'Abundant Growth', image: '$_path/2.png'),
  Card3D(author: 'Iris Compiet', title: 'Abundant Harvest', image: '$_path/3.png'),
  Card3D(author: 'Steve Prescott', title: 'Abzan Guide', image: '$_path/4.png'),
  Card3D(author: 'Edward P. Beard, Jr.', title: ' Accelerated Mutation', image: '$_path/5.png')
];

