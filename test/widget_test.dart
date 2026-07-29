import 'package:flutter_test/flutter_test.dart';

import 'package:usman_portfolio/main.dart';

void main() {
  testWidgets('Portfolio home renders hero heading', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    expect(find.textContaining('Building'), findsOneWidget);
  });
}
