import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApiService {
  static const String _apiKey = 'YOUR_TMDB_API_KEY';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getNowPlaying() async {
    if (_apiKey == 'YOUR_TMDB_API_KEY') return _localMovies;
    return _fetchMovieList('/movie/now_playing');
  }

  Future<List<Movie>> getPopular() async {
    return _fetchMovieList('/movie/popular');
  }

  Future<List<Movie>> getUpcoming() async {
    return _fetchMovieList('/movie/upcoming');
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (_apiKey == 'YOUR_TMDB_API_KEY') {
      final normalizedQuery = query.toLowerCase().trim();
      return _localMovies
          .where((movie) => movie.title.toLowerCase().contains(normalizedQuery))
          .toList();
    }
    final uri = Uri.parse('$_baseUrl/search/movie').replace(queryParameters: {
      'api_key': _apiKey,
      'query': query,
    });
    return _fetchAndParse(uri);
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final uri = Uri.parse('$_baseUrl/movie/$movieId').replace(queryParameters: {
      'api_key': _apiKey,
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load movie details (${response.statusCode})');
    }
  }

  Future<List<Movie>> _fetchMovieList(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: {
      'api_key': _apiKey,
      'page': '1',
    });
    return _fetchAndParse(uri);
  }

  Future<List<Movie>> _fetchAndParse(Uri uri) async {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load movies (${response.statusCode})');
    }
  }

  static final List<Movie> _localMovies = [
    Movie(
      id: 1,
      title: 'The Last Horizon',
      overview: 'A daring crew crosses the edge of known space to bring a lost signal home.',
      posterPath: 'https://images.unsplash.com/photo-1440404653325-ab127d49?auto=format&fit=crop&w=600&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&w=1200&q=80',
      voteAverage: 8.4,
      releaseDate: '2026-08-14',
      genreIds: [878, 12],
    ),
    Movie(
      id: 2,
      title: 'Neon District',
      overview: 'One detective. One impossible case. A city that never tells the whole truth.',
      posterPath: 'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=600&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1519608487953-e999c86e7455?auto=format&fit=crop&w=1200&q=80',
      voteAverage: 7.9,
      releaseDate: '2026-08-21',
      genreIds: [80, 53],
    ),
    Movie(
      id: 3,
      title: 'Paper Planets',
      overview: 'A quiet friendship becomes an unexpected journey across three continents.',
      posterPath: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&w=600&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&w=1200&q=80',
      voteAverage: 8.1,
      releaseDate: '2026-07-31',
      genreIds: [18, 10749],
    ),
    Movie(
      id: 4,
      title: 'Midnight Runway',
      overview: 'Ambition takes flight when a young designer gets one night to change everything.',
      posterPath: 'https://images.unsplash.com/photo-1531058020387-3be344556be6?auto=format&fit=crop&w=600&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1531058020387-3be344556be6?auto=format&fit=crop&w=1200&q=80',
      voteAverage: 7.6,
      releaseDate: '2026-08-07',
      genreIds: [35, 18],
    ),
  ];
}
