import 'package:delivery_app/core/constant/color.dart';
import 'package:delivery_app/ui/screens/layout_templete/layout_templete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/ui/screens/auth_screens/auth_screens_provider.dart';
import 'package:flutter/services.dart';
import 'package:delivery_app/core/enums/view_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showPhoneInput = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // Left Section
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Consumer<AuthScreensProvider>(
                builder: (context, model, child) {
                  return _showPhoneInput
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  _showPhoneInput = false;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Enter your phone number',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: model.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/papkistani_flag.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                "+92",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: model.phoneNumberController,
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 10,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                              LengthLimitingTextInputFormatter(10),
                                            ],
                                            decoration: const InputDecoration(
                                              hintText: "3134624528",
                                              hintStyle: TextStyle(color: Colors.black38),
                                              border: InputBorder.none,
                                              counter: SizedBox(),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your phone number';
                                              }
                                              String cleanedNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
                                              if (cleanedNumber.length != 10) {
                                                return 'Please enter a valid 10-digit phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: model.state == ViewState.busy
                                    ? null
                                    : () async {
                                        if (model.formKey.currentState!.validate()) {
                                          try {
                                            String cleanedNumber = model.phoneNumberController.text.replaceAll(RegExp(r'[^0-9]'), '');
                                            await model.verifyPhoneNumber(
                                              '+92$cleanedNumber',
                                              context,
                                              null,
                                              isWeb: true,
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Failed to send verification code. Please try again later.'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: model.state == ViewState.busy
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        'CONTINUE',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Cheezious Logo (Placeholder)
                            Image.asset(
                              'assets/images/Frame 1261155164.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) => const Text('kabir Logo',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 80),
                            const Text(
                              'Hey there, feeling hungry?',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Let's enjoy your food with Kabir!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showPhoneInput = true;
                                  });
                                },
                                icon: const Icon(Icons.phone, color: Colors.white),
                                label: const Text(
                                  'CONTINUE WITH PHONE',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>LayoutTemplate()));
                                },
                                icon: const Icon(Icons.person, color: Colors.black),
                                label: const Text(
                                  'CONTINUE AS A GUEST',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black38),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
          // Right Section
          Expanded(
            flex: 1,
            child: Container(
              // color: const Color(0xFFF9D000), // Yellow background color from image
              child:    Image.network(
                'data:image/jpeg;base64,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', // Placeholder for delivery illustration
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
