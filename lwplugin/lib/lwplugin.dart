

import 'package:flutter/services.dart';

enum BatteryState{
  full,
  charging,
  discharging,
}

class Lwplugin {
  static const MethodChannel _channel =
      const MethodChannel('plugin.flutter.io/lwplugin');
  static const EventChannel _eventChannel = const EventChannel('plugin.flutter.io/lwplugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  Stream<BatteryState>_onBatteryStateChanged;

Future<int> get batteryLevel{
  _channel.invokeMethod('getbatteryLevel').then<int>((dynamic level){
    return level;
  });
}

Stream get onListerBatteryChange{
  if(_onBatteryStateChanged == null){
    _onBatteryStateChanged = _eventChannel.receiveBroadcastStream().map((dynamic event){
    return batteryPrase(event);
    });
  }
  return _onBatteryStateChanged;
}

 BatteryState batteryPrase(String event){
switch(event){
  case 'full':
  return BatteryState.full;
  case 'charging':
  return BatteryState.charging;
case 'discharging':
  return BatteryState.discharging;
   default:
      throw ArgumentError('$event is not a valid BatteryState.');
  }

 }

void showTotas(String msg){
  print('--------------------showTotas--------------');
 _channel.invokeMethod('showtotas',msg);
}
}
