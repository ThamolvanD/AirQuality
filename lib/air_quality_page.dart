import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // Needed for BackdropFilter

void main() {
  runApp(const AirQualityApp());
}

class AirQualityApp extends StatelessWidget {
  const AirQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ).copyWith(
          secondary: const Color(0xFFF0F0F0),
        ),
        useMaterial3: true,
      ),
      home: const AirQualityPage(),
    );
  }
}

class AirQualityPage extends StatefulWidget {
  const AirQualityPage({super.key});

  @override
  State<AirQualityPage> createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  late Future<Map<String, dynamic>> _airQualityData;
  final String _apiToken = '551fca5a9f7b4a4cd5255ada55f2bbc5fecf9362';
  final String _city = 'Bangkok';

  @override
  void initState() {
    super.initState();
    _airQualityData = _fetchAirQuality();
  }

  Future<Map<String, dynamic>> _fetchAirQuality() async {
    final url = Uri.parse('https://api.waqi.info/feed/$_city/?token=$_apiToken');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          return data['data'];
        } else {
          throw Exception('API status not okay: ${data['status']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load air quality data: $e');
    }
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF4CAF50); // Green
    if (aqi <= 100) return const Color(0xFFFF9800); // Orange
    if (aqi <= 150) return const Color(0xFFF44336); // Red
    if (aqi <= 200) return const Color(0xFF9C27B0); // Purple
    if (aqi <= 300) return const Color(0xFF673AB7); // Deep Purple
    return const Color(0xFF3F51B5); // Indigo
  }

  String _getAqiStatus(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Add spacing from the bottom
        child: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _airQualityData = _fetchAirQuality();
            });
          },
          label: const Text('Refresh', style: TextStyle(fontSize: 18)),
          icon: const Icon(Icons.refresh, size: 24),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC)], // New cool tone colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _airQualityData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.black54));
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                final aqi = data['aqi'] ?? 0;
                final cityName = data['city']['name'] ?? 'N/A';
                final temperature = data['iaqi']?['t']?['v']?.toDouble() ?? 0.0;
                final humidity = data['iaqi']?['h']?['v']?.toDouble() ?? 0.0;
                final wind = data['iaqi']?['w']?['v']?.toDouble() ?? 0.0;
                return _buildAirQualityView(aqi, cityName, temperature, humidity, wind);
              } else {
                return const Center(
                  child: Text(
                    'No data available. Tap the button to refresh.',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityView(int aqi, String cityName, double temperature, double humidity, double wind) {
    final aqiColor = _getAqiColor(aqi);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.black54, size: 28),
                const SizedBox(width: 8),
                Text(
                  cityName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Adjusted card color
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: aqiColor.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Air Quality Index',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: aqiColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$aqi',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w700,
                            color: aqiColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getAqiStatus(aqi),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoColumn(Icons.thermostat, '${temperature.toStringAsFixed(1)}°C', 'Temperature'),
                            _buildInfoColumn(Icons.opacity, '${humidity.toStringAsFixed(0)}%', 'Humidity'),
                            _buildInfoColumn(Icons.air, '${wind.toStringAsFixed(1)} km/h', 'Wind'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // The original _buildCityHeader function is no longer needed but kept for reference
  Widget _buildCityHeader(String cityName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.black54, size: 32),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            cityName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
