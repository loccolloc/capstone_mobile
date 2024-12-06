import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpeakerControlScreen extends StatefulWidget {
  const SpeakerControlScreen({super.key});

  @override
  SpeakerControlScreenState createState() => SpeakerControlScreenState();
}

class SpeakerControlScreenState extends State<SpeakerControlScreen> {
  bool isLightOn = false;
  bool isLoading = true;
  double volume = 50.0;
  String deviceName = '';

  final String adafruitID = "1230567";
  final String deviceID = "674d6184a9c124efd363b0c6";

  @override
  void initState() {
    super.initState();
    _fetchDeviceData();
  }

  Future<void> _fetchDeviceData() async {
    // final url = Uri.parse("http://localhost:3000/api/devices/$deviceID");
    final url = Uri.parse(
        "https://capstone-smartspeaker.onrender.com/api/devices/$deviceID");
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final device = data['device'];

        setState(() {
          deviceName = device['deviceName'];
          volume = device['lastValue'].toDouble();
          isLightOn = device['lastValue'] == 70;
        });
      } else {
        // print("Failed to fetch data: ${response.body}");
      }
    } catch (error) {
      // print("Connection error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _setVolume(double value) async {
    final url = Uri.parse("http://localhost:3000/api/devices/$adafruitID");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "lastValue": value.toInt(),
          "updatedTime": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          volume = value;
        });
        // print("Volume status updated successfully");
      } else {
        // print("Failed to update volume status: ${response.body}");
      }
    } catch (error) {
      // print("Connection error: $error");
    }
  }

  Future<void> _toggleLight(bool value) async {
    final url = Uri.parse("http://localhost:3000/api/devices/$adafruitID");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "lastValue": value ? 70 : 0,
          "updatedTime": DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLightOn = value;
        });
      } else {
        // print("Failed to update light status: ${response.body}");
      }
    } catch (error) {
      // print("Connection error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Điều Khiển Loa",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bật/Tắt",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Transform.scale(
                        scale: 2,
                        child: Switch(
                          value: isLightOn,
                          onChanged: (value) async {
                            setState(() {
                              isLightOn = value;
                            });
                            await _toggleLight(value);
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text("Tên thiết bị: $deviceName",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("ID Thiết bị: $adafruitID",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Điều chỉnh âm lượng",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8.0,
                      thumbColor: Colors.green,
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                      overlayColor: Colors.green.withOpacity(0.2),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 16.0),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: "${volume.round()}",
                      onChanged: (value) async {
                        setState(() {
                          volume = value;
                        });
                        await _setVolume(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
