import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'seat_selection_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  static const List<String> _showtimes = [
    'Today · 7:30 PM',
    'Today · 9:15 PM',
    'Tomorrow · 6:00 PM',
    'Tomorrow · 8:45 PM',
  ];

  String _selectedShowtime = _showtimes.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(widget.movie.backdropUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(widget.movie.voteAverage.toStringAsFixed(1)),
                      const SizedBox(width: 16),
                      Text(widget.movie.releaseDate),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.movie.overview),
                  const SizedBox(height: 20),
                  const Text(
                    'Showtime',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _showtimes.map((showtime) {
                      final selected = showtime == _selectedShowtime;
                      return ChoiceChip(
                        label: Text(showtime),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _selectedShowtime = showtime;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SeatSelectionScreen(
                              movie: widget.movie,
                              showtime: _selectedShowtime,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
