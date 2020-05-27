import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lwplugin/lwplugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('lwplugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getbatteryLevel', () async {
    expect(await Lwplugin().batteryLevel, '42');
  });

}
