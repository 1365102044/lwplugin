#import "LwpluginPlugin.h"
#if __has_include(<lwplugin/lwplugin-Swift.h>)
#import <lwplugin/lwplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lwplugin-Swift.h"
#endif

#import "lwTotas.h"

@interface LwpluginPlugin()<FlutterStreamHandler>
{
  FlutterEventSink _eventSink;
    lwTotas *totas;
}

@end

@implementation LwpluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  // [SwiftLwpluginPlugin registerWithRegistrar:registrar];
  LwpluginPlugin *instance = [[LwpluginPlugin alloc] init];
  FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"plugin.flutter.io/lwplugin" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
  FlutterEventChannel *eventchannel = [FlutterEventChannel eventChannelWithName:@"plugin.flutter.io/lwplugin.event" binaryMessenger:[registrar messenger]];
  [eventchannel setStreamHandler:instance];
    instance->totas = [[lwTotas alloc] init];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"%@", [NSString stringWithFormat:@"%@",call.method]);
    NSLog(@"%@", [NSString stringWithFormat:@"%@",call.arguments]);
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++++++++");
    if ([@"getbatteryLevel" isEqualToString:call.method]) {
        
        int batterylevel = [self getBatteryLevel];
        
        if (batterylevel == -1) {
            result([FlutterError errorWithCode:@"UNAVAILABLE" message:@"battery info unavailable" details:nil]);
        }else{
            result(@(batterylevel));
        }
        
    }else if([@"showtotas" isEqualToString:call.method]){
        [totas show:call.arguments];
    }
    
    else{
        result(FlutterMethodNotImplemented);
    }
}

- (int )getBatteryLevel
{
    UIDevice* device = UIDevice.currentDevice;
     device.batteryMonitoringEnabled = YES;
     if (device.batteryState == UIDeviceBatteryStateUnknown) {
       return -1;
     } else {
       return ((int)(device.batteryLevel * 100));
     }
}

- (void)sendBatteryStateEvent
{
    if (_eventSink) {
        return;
    }
    UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
    switch (state) {
        case UIDeviceBatteryStateFull:
            _eventSink(@"full");
            break;
        case UIDeviceBatteryStateCharging:
            _eventSink(@"charging");
            break;
        case UIDeviceBatteryStateUnplugged:
            _eventSink(@"discharging");
            break;
        default:
            _eventSink([FlutterError errorWithCode:@"UNAVAILABLE" message:@"battery info unavailable" details:nil]);
            break;
    }
}

- (void)onBatteryStateDidChange:(NSNotification *)noti
{
    [self sendBatteryStateEvent];
}

#pragma mark FlutterStreamHandler impl

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    _eventSink = events;
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [self sendBatteryStateEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBatteryStateDidChange:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    return nil;
}
@end
