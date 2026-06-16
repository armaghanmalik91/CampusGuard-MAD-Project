import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/app_colors.dart';
import '../../services/api_service.dart';

class ReportIncidentScreen extends StatefulWidget {
  final String userEmail;

  const ReportIncidentScreen({super.key, required this.userEmail});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  String selectedCategory = 'Suspicious Activity';
  final List<String> categories = ['Suspicious Activity', 'Harassment', 'Medical Emergency', 'Fire/Hazard', 'Other'];
  
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  // Media States
  File? selectedImage;
  String? audioPath;
  bool isRecording = false;
  final AudioRecorder audioRecorder = AudioRecorder();

  // Photo Pick Function
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // Audio Recording Functions
  Future<void> toggleRecording() async {
    if (isRecording) {
      // Stop Recording
      final path = await audioRecorder.stop();
      setState(() {
        isRecording = false;
        audioPath = path;
      });
    } else {
      // Start Recording
      if (await Permission.microphone.request().isGranted) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String filePath = '${appDocDir.path}/incident_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await audioRecorder.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
          audioPath = null; // Purani audio hata dein naye ke liye
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission required')));
      }
    }
  }

  // Submit Logic
  Future<void> submitReport() async {
    String description = descriptionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a description'), backgroundColor: AppColors.danger));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ApiService.submitIncidentReport(
      email: widget.userEmail,
      category: selectedCategory,
      description: description,
      photoPath: selectedImage?.path,
      audioPath: audioPath,
    );

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Report Submitted!'),
          backgroundColor: result['success'] == true ? Colors.green : AppColors.danger,
        ),
      );

      if (result['success'] == true) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Report Incident'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // 👇 PREVIEW HISTORY SECTION 👇
                if (selectedImage != null || audioPath != null || isRecording) ...[
                  const Text('Media Attached', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkText)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Image Preview
                      if (selectedImage != null)
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(selectedImage!, height: 80, width: 80, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: -10, right: -10,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => setState(() => selectedImage = null),
                              ),
                            )
                          ],
                        ),
                      const SizedBox(width: 15),
                      
                      // Audio Preview
                      if (audioPath != null || isRecording)
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isRecording ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isRecording ? Colors.red : Colors.green),
                            ),
                            child: Row(
                              children: [
                                Icon(isRecording ? Icons.mic : Icons.audiotrack, color: isRecording ? Colors.red : Colors.green, size: 30),
                                const SizedBox(width: 10),
                                Expanded(child: Text(isRecording ? 'Recording Audio...' : 'Audio Ready to Send', style: TextStyle(color: isRecording ? Colors.red : Colors.green, fontWeight: FontWeight.bold))),
                                if (!isRecording)
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => setState(() => audioPath = null),
                                  )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                ],
                // 👆 PREVIEW SECTION END 👆

                const Text('Incident Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkText)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(filled: true, fillColor: AppColors.cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (val) => setState(() => selectedCategory = val!),
                ),
                const SizedBox(height: 20),
                
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkText)),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(hintText: 'Describe what happened...', filled: true, fillColor: AppColors.cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Add Photo'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: toggleRecording,
                        icon: Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.white),
                        label: Text(isRecording ? 'Stop Recording' : 'Record Audio'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRecording ? Colors.red : Colors.blueGrey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12)
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                ElevatedButton(
                  onPressed: isLoading || isRecording ? null : submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Submit Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          if (isLoading) Container(color: Colors.black.withOpacity(0.2)),
        ],
      ),
    );
  }
}