// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:io';

// class VoiceCallPage extends StatefulWidget {
//   const VoiceCallPage({super.key});

//   @override
//   VoiceCallPageState createState() => VoiceCallPageState();
// }

// class VoiceCallPageState extends State<VoiceCallPage> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   late IO.Socket socket;
//   bool _isRecording = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeSocket();
//     _initRecorder();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   void _initializeSocket() {
//     socket = IO.io('http://<YOUR_BACKEND_IP>:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });

//     socket.onConnect((_) {
//       // print('Connected to WebSocket');
//     });
//   }

//   Future<void> startRecording() async {
//     await _recorder.startRecorder(toFile: 'audio.wav');
//     setState(() {
//       _isRecording = true;
//     });
//   }

//   Future<void> stopRecording() async {
//     String? path = await _recorder.stopRecorder();
//     if (path != null) {
//       sendAudio(path);
//     }
//     setState(() {
//       _isRecording = false;
//     });
//   }

//   void sendAudio(String filePath) async {
//     File audioFile = File(filePath);
//     List<int> audioData = await audioFile.readAsBytes();
//     socket.emit('audio_data', audioData);
//   }

//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     socket.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Gọi Aya',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Container(
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10.0,
//                 spreadRadius: 2.0,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: IconButton(
//             icon: Icon(
//               _isRecording ? Icons.mic_off : Icons.mic,
//               size: 100,
//               color: _isRecording ? Colors.red : Colors.blue,
//             ),
//             onPressed: _isRecording ? stopRecording : startRecording,
//           ),
//         ),
//       ),
//     );
//   }
// }
