import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'booking_confirmation_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Movie movie;
  final String showtime;

  const SeatSelectionScreen({
    super.key,
    required this.movie,
    required this.showtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  static const int rows = 6;
  static const int seatsPerRow = 8;
  static const double pricePerSeat = 12.0;
  static const List<String> _rowLetters = ['A', 'B', 'C', 'D', 'E', 'F'];

  // Pretend a few seats are already booked
  final Set<String> _bookedSeats = {'C4', 'C5', 'D2'};
  final Set<String> _selectedSeats = {};

  void _toggleSeat(String seatId) {
    if (_bookedSeats.contains(seatId)) return;
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        _selectedSeats.add(seatId);
      }
    });
  }

  Color _seatColor(String seatId) {
    if (_bookedSeats.contains(seatId)) return Colors.grey;
    if (_selectedSeats.contains(seatId)) return Colors.green;
    return Colors.blueGrey.shade200;
  }

  double get _totalPrice => _selectedSeats.length * pricePerSeat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seats · ${widget.movie.title}')),
      body: Column(
        children: [
          // Screen indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text('SCREEN', style: TextStyle(letterSpacing: 4, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(rows, (rowIndex) {
                  final rowLetter = _rowLetters[rowIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 24, child: Text(rowLetter)),
                        const SizedBox(width: 8),
                        ...List.generate(seatsPerRow, (seatIndex) {
                          final seatId = '$rowLetter${seatIndex + 1}';
                          return GestureDetector(
                            onTap: () => _toggleSeat(seatId),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _seatColor(seatId),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          _buildLegend(),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    Widget legendItem(Color color, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, color: color, margin: const EdgeInsets.symmetric(horizontal: 6)),
            Text(label),
          ],
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          legendItem(Colors.blueGrey.shade200, 'Available'),
          legendItem(Colors.green, 'Selected'),
          legendItem(Colors.grey, 'Booked'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedSeats.length} seat(s) · \$${_totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: _selectedSeats.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingConfirmationScreen(
                            movie: widget.movie,
                            showtime: widget.showtime,
                            seatIds: _selectedSeats.toList()..sort(),
                            totalPrice: _totalPrice,
                          ),
                        ),
                      );
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
