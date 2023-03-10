# vicinity_location_tags

Vicinity Location Tags

## Getting Started

 create a folder named plugins clone the the repository to the repository then add the following 

 in the pubspec.yaml
```
 vicinity_location_tags:
    path: plugins/vicinity_location_tags 
```
Then run flutter pub get. 

Usage 
add the following to the android manifest 

```
 <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
import the plugin 

```
import 'package:vicinity_location_tags/vicinity_location_tags.dart';
```

add the folloling code.

```
  Future<void> initVicinityTags() async {
    final hasPermission = await _handleLocationPermission();
    WidgetsFlutterBinding.ensureInitialized();
    if (!hasPermission) return;
    var platformVersion;
    try {
      int zoneId = 12345;
     platformVersion =
          (await _vicinityLocationTagsPlugin.initUserAgentState(zoneId));
      print(platformVersion );
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }
```

