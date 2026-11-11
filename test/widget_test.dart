import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quickbitex/main.dart';
import 'package:quickbitex/order_controller.dart';

void main() {
  setUp(() => Get.put(OrderController()));
  tearDown(Get.reset);

  testWidgets('diner opens the menu', (tester) async {
    await tester.pumpWidget(const QuickBiteXApp());
    await tester.tap(find.text('Find dinner'));
    await tester.pumpAndSettle();
    expect(find.text('Chili crisp bao'), findsOneWidget);
  });
}
