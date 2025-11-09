import 'package:intl/intl.dart';

String rupiahFormat(int amount) {
  final NumberFormat format = NumberFormat('#,##0.00', 'id_ID');
  final String result = 'Rp ${format.format(amount)}';
  return result;
}