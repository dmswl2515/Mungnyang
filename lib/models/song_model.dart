class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });

  static List<Song> songs = [
    Song(
      title: '새소리',
      description: '새소리',
      url: 'assets/music/bird.mp3',
      coverUrl: 'assets/images/bird.jpg',
    ),
    Song(
      title: '물소리',
      description: '물소리',
      url: 'assets/music/water.mp3',
      coverUrl: 'assets/images/water.jpg',
    ),
    Song(
      title: '안정음악',
      description: '안정음악',
      url: 'assets/music/bird.mp3',
      coverUrl: 'assets/images/안정.jpg',
    ),
    Song(
      title: '비닐봉지소리',
      description: '비닐봉지소리',
      url: 'assets/music/bird.mp3',
      coverUrl: 'assets/images/비닐봉지.jpg',
    ),
    Song(
      title: '딸랑이',
      description: '딸랑이',
      url: 'assets/music/bird.mp3',
      coverUrl: 'assets/images/딸랑이.jpg',
    ),
    Song(
      title: '풀벌레소리',
      description: '풀벌레소리',
      url: 'assets/music/bird.mp3',
      coverUrl: 'assets/images/풀벌레.jpg',
    ),
  ];
}
