import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:university_library/components/appcolors.dart';
import '../components/appbar.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  final _regNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _otherNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _schoolController = TextEditingController();
  final _levelController = TextEditingController();

  Future<void> _captureImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.front,
      );

      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture photo: $e')),
        );
      }
    }
  }

  Future<void> _handleRegistration() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final Uri apiUrl = Uri.parse(
        "https://nsalibrentrebk.onrender.com/users/student/register");

    final request = http.MultipartRequest('POST', apiUrl);
    request.fields['regNo'] = _regNumberController.text;
    request.fields['firstName'] = _firstNameController.text;
    request.fields['otherName'] = _otherNameController.text;
    request.fields['department'] = _departmentController.text;
    request.fields['school'] = _schoolController.text;
    request.fields['level'] = _levelController.text;
    request.fields['gender'] = selectedGender ?? '';

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo', 
        _imageFile!.path,
      ));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
    } else {
      // Extract error message from the response body
      final responseBody = await response.stream.bytesToString();
      final responseData = jsonDecode(responseBody);

      String errorMessage = responseData['message'] ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  void dispose() {
    _regNumberController.dispose();
    _firstNameController.dispose();
    _otherNameController.dispose();
    _departmentController.dispose();
    _schoolController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register here to get started',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _regNumberController,
                    label: 'Reg number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter registration number';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _otherNameController,
                    label: 'Other Name',
                  ),
                  _buildTextField(
                    controller: _departmentController,
                    label: 'Department',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter department';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _schoolController,
                    label: 'School',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter school';
                      }
                      return null;
                    },
                  ),
                  _buildDropdown(),
                  _buildTextField(
                    controller: _levelController,
                    label: 'Level',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter level';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildCameraCapture(),
                  if (_imageFile != null) _buildImagePreview(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: 'Select Gender',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        value: selectedGender,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select gender';
          }
          return null;
        },
        items: ['male', 'female', 'Other']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
        },
      ),
    );
  }

  Widget _buildCameraCapture() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _captureImage,
        icon: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
        label: const Text(
          'Take a profile picture',
          style: TextStyle(color: Colors.blue),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _imageFile!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _captureImage,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
