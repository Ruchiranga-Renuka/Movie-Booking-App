import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/movie.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import 'home_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Movie movie;
  final String showtime;
  final List<String> seatIds;
  final double totalPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.movie,
    required this.showtime,
    required this.seatIds,
    required this.totalPrice,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final BookingService _bookingService = BookingService();
  bool _saving = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saveBooking();
  }

  Future<void> _saveBooking() async {
    final booking = Booking(
      id: const Uuid().v4(),
      movieId: widget.movie.id,
      movieTitle: widget.movie.title,
      posterUrl: widget.movie.posterUrl,
      showtime: widget.showtime,
      seatIds: widget.seatIds,
      totalPrice: widget.totalPrice,
      bookedAt: DateTime.now(),
    );
    await _bookingService.saveBooking(booking);
    if (mounted) {
      setState(() {
        _saving = false;
        _saved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmed')),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _saved ? Icons.check_circle : Icons.error,
                      color: _saved ? Colors.green : Colors.red,
                      size: 72,
                    ),
                    const SizedBox(height: 16),
                    Text(widget.movie.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Showtime: ${widget.showtime}'),
                    Text('Seats: ${widget.seatIds.join(', ')}'),
                    Text('Total: \$${widget.totalPrice.toStringAsFixed(2)}'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
