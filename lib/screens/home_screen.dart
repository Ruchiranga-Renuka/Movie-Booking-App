import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieApiService _apiService = MovieApiService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Movie>> _moviesFuture;
  String _selectedGenre = 'All';

  static const _genres = ['All', 'Action', 'Drama', 'Comedy', 'Thriller'];

  @override
  void initState() {
    super.initState();
    _moviesFuture = _apiService.getNowPlaying();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchMovies(String query) {
    setState(() {
      _moviesFuture = query.trim().isEmpty
          ? _apiService.getNowPlaying()
          : _apiService.searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CINEMATE',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh movies',
            onPressed: () => setState(() => _moviesFuture = _apiService.getNowPlaying()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return _ErrorState(onRetry: _searchMovies);
          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text('No movies found'));
          }
          final visibleMovies = _selectedGenre == 'All' ? movies : movies;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final movie = visibleMovies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
                        ),
                      );
                    },
                    childCount: visibleMovies.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 230,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find your next story',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Handpicked films for your next night out.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white60,
                ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _searchController,
            onSubmitted: _searchMovies,
            decoration: InputDecoration(
              hintText: 'Search movies',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Search',
                onPressed: () => _searchMovies(_searchController.text),
                icon: const Icon(Icons.arrow_forward),
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _genres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final genre = _genres[index];
                return ChoiceChip(
                  label: Text(genre),
                  selected: _selectedGenre == genre,
                  onSelected: (_) => setState(() => _selectedGenre = genre),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final ValueChanged<String> onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            const Text('Movies are temporarily unavailable', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => onRetry(''), child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
