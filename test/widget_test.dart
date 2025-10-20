import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD
import 'package:mobile_arnold/main.dart';
=======
import 'package:logo_marketplace/main.dart';
>>>>>>> 352ad9eb32452724fcd256bf48663b160d35c179

void main() {
  testWidgets('Login page loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Cek apakah ada teks "LOGODESAIN"
    expect(find.text('LOGODESAIN'), findsOneWidget);

    // Cek apakah ada tombol Login
    expect(find.text('Login'), findsOneWidget);
  });
}
