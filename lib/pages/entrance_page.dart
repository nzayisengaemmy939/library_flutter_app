import 'package:flutter/material.dart';
import 'package:university_library/components/appbar.dart';
import 'package:university_library/components/appcolors.dart';
import 'package:university_library/localization.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class EntrancePage extends StatefulWidget {
  const EntrancePage({super.key});

  @override
  State<EntrancePage> createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  final TextEditingController _regNumberController = TextEditingController();
  String _qrCodeString = '';
  bool isLoading = false;
  bool containerIsVisible = true;

  Future<void> _sendEntranceRequest() async {
    if (_regNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a registration number')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String regNo = _regNumberController.text;

    try {
      final Uri apiUrl = Uri.parse(
          "https://nsalibrentrebk.onrender.com/users/student/entry/$regNo");

      final response = await http.post(
        apiUrl,
        body: json.encode({
          'regNo': regNo,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrance request sent successfully!')),
      );

      setState(() {
        _qrCodeString = responseData['qrcode'];
        containerIsVisible = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColors.gray100,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 270,
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: containerIsVisible
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalization.of(context)?.translate("enterRegNumber") ??
                                "Enter reg number to make an entrance",
                            style: const TextStyle(
                                color: AppColors.blue500, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _regNumberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.gray100,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _sendEntranceRequest,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(17),
                                backgroundColor: AppColors.primary,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white) // Show loader during API call
                                  : Text(
                                      AppLocalization.of(context)
                                              ?.translate("send") ??
                                          "Send",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          if (_qrCodeString.isNotEmpty)
                            Container(
                              alignment: Alignment.center,
                              child: QrImageView(
                                data: _qrCodeString,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
