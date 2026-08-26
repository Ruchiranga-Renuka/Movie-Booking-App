class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  // TMDB image base URL - append posterPath/backdropPath to this
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

    String get posterUrl => posterPath.startsWith('http')
      ? posterPath
      : posterPath.isNotEmpty
        ? '$imageBaseUrl$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Poster';

    String get backdropUrl => backdropPath.startsWith('http')
      ? backdropPath
      : backdropPath.isNotEmpty
        ? '$imageBaseUrl$backdropPath'
      : 'https://via.placeholder.com/780x439?text=No+Image';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String? ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
    };
  }
}
