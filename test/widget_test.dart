import 'package:flutter_test/flutter_test.dart';
import 'package:logo_marketplace/main.dart';

void main() {
  testWidgets('Login page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Cek apakah ada teks "LOGODESAIN"
    expect(find.text('LOGODESAIN'), findsOneWidget);

    // Cek apakah ada tombol Login
    expect(find.text('Login'), findsOneWidget);
  });
}
