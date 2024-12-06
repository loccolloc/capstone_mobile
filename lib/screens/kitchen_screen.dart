import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'light_control_screen.dart';
import 'fan_control_screen.dart';
import 'speaker_control_screen.dart';
import './setting.dart';
import './home_screen.dart';
import 'bedroom.screen.dart';
import '../config/size_config.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  KitchenScreenState createState() => KitchenScreenState();
}

class KitchenScreenState extends State<KitchenScreen> {
  List<dynamic> devices = [];
  bool isLoading = true;
  double temperature = 0.0;
  String weatherDescription = '';
  String city = 'TP.HCM';
  String country = 'VN';
  String iconUrl = '';
  final double lat = 10.8231;
  final double lon = 106.6297;
  String? apiKey = dotenv.env['API_KEY'];
  late String weatherApiUrl;
  @override
  void initState() {
    super.initState();
    weatherApiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi';

    _fetchDevices();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final response = await http.get(Uri.parse(weatherApiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['main']['temp'].toDouble();
          weatherDescription = data['weather'][0]['description'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load weather data')),
      );
    }
  }

  Future<void> _fetchDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('_id');

    if (userId != null) {
      final response = await http.get(
        // Uri.parse('http://localhost:3000/api/devices/$userId/10'),
        Uri.parse(
            'https://capstone-smartspeaker.onrender.com/api/devices/$userId/10'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          devices = jsonDecode(response.body)['devices'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load devices')));
      }
    }
  }

  Future<void> _addDevice(String name, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('_id');

    if (userId != null) {
      final response = await http.patch(
        // Uri.parse('http://localhost:3000/api/devices/addDevice'),
        Uri.parse(
            'https://capstone-smartspeaker.onrender.com/api/devices/addDevice'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userID": userId,
          "deviceID": id,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          devices.add({"adaFruitID": id});
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thiết bị được thêm thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm thiết bị thất bại')),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy ID người dùng')),
      );
    }
  }

  void _showAddDeviceDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm thiết bị mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID thiết bị',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                final String id = idController.text.trim();

                if (name.isNotEmpty && id.isNotEmpty) {
                  await _addDevice(name, id);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập đủ thông tin')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<dynamic> validDevices = devices.where((device) {
      String adaFruitID = device['adaFruitID'] ?? '';
      return adaFruitID.startsWith('3');
    }).toList();
    String capitalize(String s) {
      if (s.isEmpty) return s;
      return s[0].toUpperCase() + s.substring(1).toLowerCase();
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f7fa),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aya, xin chào',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'assets/images/aya.png',
                  height: 50,
                  width: 50,
                ),
              ],
            ),
            const SizedBox(height: 1),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/weather/0.png',
                      height: getProportionateScreenHeight(110),
                      width: getProportionateScreenWidth(140),
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temperature°C',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            capitalize(weatherDescription),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy', 'vi_VN')
                                .format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const Text(
                            'TP.HCM, Việt Nam',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab("Phòng khách", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }),
                _buildTab("Phòng bếp", isSelected: true),
                _buildTab("Phòng ngủ", onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BedroomScreen()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            height: size.height * 0.3,
                            width: size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              image: DecorationImage(
                                image: AssetImage('assets/images/kitchen.webp'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 20,
                          left: 16,
                          child: Text(
                            "Phòng khách",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: validDevices.length + 3,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _buildDeviceCard(
                                  context,
                                  title: "Loa thông minh",
                                  icon: Icons.speaker,
                                  color: Colors.black,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SpeakerControlScreen()),
                                  ),
                                );
                              } else if (index == 1) {
                                return _buildMusicCard();
                              } else if (index == validDevices.length + 2) {
                                return _buildAddDeviceCard();
                              } else {
                                var device = validDevices[index - 2];
                                String title = '';
                                IconData icon = Icons.device_unknown;
                                Color color = Colors.grey;

                                if (device['deviceType'].contains('light')) {
                                  title = 'Đèn';
                                  icon = Icons.lightbulb_outline;
                                  color = Colors.amber;
                                } else if (device['deviceType']
                                    .contains('fan')) {
                                  title = 'Quạt';
                                  icon = Icons.wind_power;
                                  color = Colors.blue;
                                } else if (device['deviceType'] == 'sensor') {
                                  title = 'Cảm biến';
                                  icon = Icons.wifi_outlined;
                                  color = Colors.purple;
                                } else if (device['deviceType'] ==
                                    'air_condition') {
                                  title = 'Máy lạnh';
                                  icon = Icons.air_outlined;
                                  color = Colors.teal;
                                }

                                return _buildDeviceCard(
                                  context,
                                  title: title,
                                  icon: icon,
                                  color: color,
                                  onTap: () => _navigateToDeviceControl(
                                    device['adaFruitID'] ?? '',
                                    device['deviceState'] ?? '0',
                                    device['_id'] ?? '',
                                    device['deviceType'] ?? '',
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nhà'),
          BottomNavigationBarItem(
              icon: Icon(Icons.flash_on), label: 'Năng lượng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cài đặt'),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage2()),
            );
          }
        },
      ),
    );
  }

  Widget _buildTab(String title,
      {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 36, color: Colors.orange),
          SizedBox(height: 10),
          Text(
            "Nhạc",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Give a Little Bit",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAddDeviceCard() {
    return GestureDetector(
      onTap: () => _showAddDeviceDialog(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 36, color: Colors.black),
            SizedBox(height: 10),
            Text('Thêm thiết bị',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _navigateToDeviceControl(String adaFruitID, String deviceState,
      String deviceId, String deviceType) async {
    if (adaFruitID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID thiết bị không hợp lệ')),
      );
      return;
    }
    if (deviceType.contains('light')) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LightControlScreen(
            adaFruitID: adaFruitID,
            deviceId: deviceId,
          ),
        ),
      );
      if (result == true) {
        setState(() {
          _fetchDevices();
        });
      }
    } else if (deviceType.contains('fan')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FanControlScreen(
            adaFruitID: adaFruitID,
            deviceId: deviceId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loại thiết bị không hợp lệ')),
      );
    }
  }
}
