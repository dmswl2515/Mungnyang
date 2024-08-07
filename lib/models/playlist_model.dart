import 'song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String imageUrl;
  
  Playlist({
    required this.title, 
    required this.songs, 
    required this.imageUrl
  });

  static List<Playlist> playlists = [
    Playlist(
      title: '고양이가 좋아하는 음악', 
      songs: Song.songs, 
      imageUrl: 'assets/images/catcover.jpg',
    ),
    Playlist(
      title: '강아지가 좋아하는 음악', 
      songs: Song.songs, 
      imageUrl: 'assets/images/dogcover.png',
    ),
    Playlist(
      title: '동물이 좋아하는 음악', 
      songs: Song.songs, 
      imageUrl: 'assets/images/animalcover.png',
    ),
  ];
}