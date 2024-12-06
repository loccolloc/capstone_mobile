import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FanControlScreen extends StatefulWidget {
  final String adaFruitID;
  final String deviceId;

  const FanControlScreen(
      {super.key, required this.adaFruitID, required this.deviceId});

  @override
  FanControlScreenState createState() => FanControlScreenState();
}

class FanControlScreenState extends State<FanControlScreen> {
  late bool isFanOn;
  bool isLoading = true;
  late String deviceName;

  @override
  void initState() {
    super.initState();
    isFanOn = false;
    deviceName = "";
    _fetchDeviceData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDeviceData();
  }

  Future<void> _fetchDeviceData() async {
    final url =
        // Uri.parse("http://localhost:3000/api/devices/${widget.deviceId}");
        Uri.parse(
            "https://capstone-smartspeaker.onrender.com/api/devices/${widget.deviceId}");

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
          isFanOn = device['lastValue'] == 1;
        });
        // print("Device data: $deviceName");
        // print("Fan state: ${device['lastValue']}");
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

  Future<void> _showDeleteConfirmation() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa thiết bị này?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteDevice(widget.adaFruitID);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDevice(String deviceId) async {
    // final url =
    //     Uri.parse("http://localhost:3000/api/devices/$deviceId/removeUser");
    final url = Uri.parse(
        "https://capstone-smartspeaker.onrender.com/api/devices/$deviceId/removeUser");
    final response = await http.patch(url);

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thiết bị đã bị xóa $deviceId ")),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa thiết bị thất bại $deviceId')),
      );
    }
  }

  Future<void> _toggleFan(bool status) async {
    setState(() {
      isLoading = true;
    });

    // final url =
    //     Uri.parse("http://localhost:3000/api/devices/${widget.adaFruitID}");
    final url = Uri.parse(
        "https://capstone-smartspeaker.onrender.com/api/devices/${widget.adaFruitID}");
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "lastValue": status ? 1 : 0,
        "updatedTime": DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isFanOn = status;
      });
      // print("Fan status updated successfully");
    } else {
      // print("Failed to update fan status: ${response.body}");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Điều Khiển Quạt",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fan Control',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isFanOn ? 'Đang bật' : 'Đang tắt',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Tên thiết bị: $deviceName",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ID thiết bị: ${widget.adaFruitID}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bật/Tắt",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Transform.scale(
                        scale: 2,
                        child: Switch(
                          value: isFanOn,
                          onChanged: (value) async {
                            setState(() {
                              isFanOn = value;
                            });
                            await _toggleFan(value);
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // print("Auto Mode kích hoạt");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(Icons.auto_awesome),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // print("Hẹn giờ bật quạt");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(Icons.timer),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // print("Lưu cài đặt yêu thích");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(Icons.favorite),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _showDeleteConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white)),
                ],
              ),
            ),
    );
  }
}
