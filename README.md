# vicinity_location_tags

Vicinity Location Tags

## Getting Started

 create a folder named plugins clone the repository to the repository then add the following 

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
    var data;
  
    try {
      int zoneId = 12345;
      data =
          (await _vicinityLocationTagsPlugin.initUserAgentState(zoneId));
      print(data );
      //if you want to validate if the data has been saved or not.
    }
  
  }
```

```
You also need to check if the location is enabled in _handleLocationPermission
```

```
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
```
