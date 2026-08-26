enum SeatStatus { available, selected, booked }

class Seat {
  final String id; // e.g. "A1", "B5"
  final String row;
  final int number;
  SeatStatus status;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
  });
}

class Booking {
  final String id;
  final int movieId;
  final String movieTitle;
  final String posterUrl;
  final String showtime; // e.g. "2026-08-30 19:30"
  final List<String> seatIds;
  final double totalPrice;
  final DateTime bookedAt;

  Booking({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterUrl,
    required this.showtime,
    required this.seatIds,
    required this.totalPrice,
    required this.bookedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      movieId: json['movieId'] as int,
      movieTitle: json['movieTitle'] as String,
      posterUrl: json['posterUrl'] as String,
      showtime: json['showtime'] as String,
      seatIds: List<String>.from(json['seatIds'] as List),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      bookedAt: DateTime.parse(json['bookedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'posterUrl': posterUrl,
      'showtime': showtime,
      'seatIds': seatIds,
      'totalPrice': totalPrice,
      'bookedAt': bookedAt.toIso8601String(),
    };
  }
}
