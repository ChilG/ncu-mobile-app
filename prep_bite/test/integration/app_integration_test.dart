import 'package:flutter_test/flutter_test.dart';

import 'auth_flow_test.dart' as auth_flow;
import 'checklist_flow_test.dart' as checklist_flow;
import 'navigation_test.dart' as navigation;

void main() {
  group('PrepBite Integration Tests Suite', () {
    navigation.main();
    checklist_flow.main();
    auth_flow.main();
  });
}
