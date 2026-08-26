import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';

class BookingService {
  static const String _storageKey = 'bookings';

  Future<List<Booking>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    return raw
        .map((s) => Booking.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.bookedAt.compareTo(a.bookedAt));
  }

  Future<void> saveBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    raw.add(jsonEncode(booking.toJson()));
    await prefs.setStringList(_storageKey, raw);
  }
}
