import 'package:flutter_test/flutter_test.dart';
import 'package:movie_booking_app/main.dart';

void main() {
  testWidgets('app shows the main movie home screen', (tester) async {
    await tester.pumpWidget(const MovieBookingApp());

    expect(find.text('CINEMATE'), findsOneWidget);
    expect(find.text('Find your next story'), findsOneWidget);
    expect(find.text('The Last Horizon'), findsOneWidget);
  });

  testWidgets('genre chip filters the movie list', (tester) async {
    await tester.pumpWidget(const MovieBookingApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Drama'));
    await tester.pumpAndSettle();

    expect(find.text('Paper Planets'), findsOneWidget);
    expect(find.text('The Last Horizon'), findsNothing);
  });
}
