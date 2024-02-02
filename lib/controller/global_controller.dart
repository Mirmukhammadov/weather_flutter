import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp_starter_project/api/fetch_weather.dart';
import 'package:weatherapp_starter_project/model/weather_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weatherapp_starter_project/app_state.dart';

// Import the file where AppState is defined
String globalVariable1 = AppState().globalVariable;
String city = "Tashkent";

Future<String> loadStoredValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('city') ?? 'Tashkent';
}

Future<List<double>> fetchLocation() async {
  var loadStoredValue2 = await loadStoredValue();
  String apiUrl = (!loadStoredValue2.isEmpty)
      ? "http://api.openweathermap.org/geo/1.0/direct?q=" +
          loadStoredValue2 +
          "&limit=5&appid=0d88e5e71e27827804250661532f5eab"
      : "http://api.openweathermap.org/geo/1.0/direct?q=Tashkent&limit=5&appid=0d88e5e71e27827804250661532f5eab";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        final Map<String, dynamic> firstLocation = data[0];

        // Extract latitude and longitude
        final double latitude = firstLocation['lat'];
        final double longitude = firstLocation['lon'];

        // Return a List<double> with latitude and longitude
        return [latitude, longitude];
      } else {
        // Return an empty List if no location data found
        return [];
      }
    } else {
      // Handle the case when the API request fails
      // print(
      //     'Failed to load location data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    // Handle other errors
    // print('Error: $e');
    return [];
  }
}

class GlobalController extends GetxController {
  // create various variables
  final RxBool _isLoading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  // instance for them to be called
  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _lattitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }
    super.onInit();
  }

  getLocation() async {
    List<double> location = await fetchLocation();

    // getting the currentposition
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      // update our lattitude and longitude
      _lattitude.value = location[0];
      _longitude.value = location[1];
      // calling our weather api
      return FetchWeatherAPI()
          .processData(location[0], location[1])
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    });
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
