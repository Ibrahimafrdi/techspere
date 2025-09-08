import 'package:delivery_app/core/enums/view_state.dart';
import 'package:delivery_app/core/models/appUser.dart';
import 'package:delivery_app/core/services/auth_services.dart';
import 'package:delivery_app/core/services/database_services.dart';
import 'package:delivery_app/core/view_models/base_view_model.dart';
import 'package:delivery_app/locator.dart';
import 'package:delivery_app/ui/screens/homeScreen/home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:delivery_app/ui/screens/auth_screens/sign_up/signUpScreen.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/core/data_providers/user_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/ui/custom_widgets/otp_dialog.dart';

class AuthScreensProvider extends BaseViewModel {
  final authServices = locator<AuthServices>();
  final databaseServices = DatabaseServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  AppUser appUser = AppUser();

  int? resendToken;

  bool get isAuthenticated => _auth.currentUser != null;

  void reinitializeProviders(BuildContext context) {
    // Get provider instances
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Reinitialize all providers
    userProvider.reinitialize();
    itemsProvider.reinitialize();
    cartProvider.reinitialize();
  }

  void continueAsGuest(BuildContext context, Widget? navigateToScreen) {
    if (navigateToScreen != null) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
  

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    BuildContext context,
    Widget? navigateToScreen,
    {bool isWeb = false}
  ) async {
    setState(ViewState.busy);
    appUser.phone = phoneNumber;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        setState(ViewState.idle);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        this.resendToken = resendToken;
        setState(ViewState.idle);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                bool isBusy = false;
                Future<void> onVerify(String smsCode) async {
                  setDialogState(() => isBusy = true);
                  try {
                    UserCredential user = await authServices.signInWithPhoneNumber(
                      verificationId,
                      smsCode,
                    );
                    if (user.user != null) {
                      setDialogState(() => isBusy = false);
                      bool isNewUser = await databaseServices.getUser(user.user!.uid) == null;
                      reinitializeProviders(context);
                      if (isNewUser) {
                        await authServices.register(appUser);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      } else {
                        if (navigateToScreen != null) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => LayoutTemplate()),
                          // );
                        }
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    setDialogState(() => isBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? 'Authentication failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (e) {
                    setDialogState(() => isBusy = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An unexpected error occurred'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                return OtpDialog(
                  verificationId: verificationId,
                  onVerify: onVerify,
                  isBusy: isBusy,
                  onResend: () async {
                    setState(ViewState.busy);
                    await verifyPhoneNumber(phoneNumber, context, navigateToScreen, isWeb: isWeb);
                  },
                  isWeb: isWeb,
                );
              },
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Add these inside AuthScreensProvider class

Future<void> signInWithEmail(
    String email, String password, BuildContext context) async {
  setState(ViewState.busy);
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Reinitialize after login
    reinitializeProviders(context);

    setState(ViewState.idle);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    setState(ViewState.idle);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Sign in failed'), backgroundColor: Colors.red),
    );
  }
}
// ONLY THE UPDATED registerWithEmail METHOD
// Replace your existing registerWithEmail method with this:

Future<void> registerWithEmail(
    String email, String password, String name, BuildContext context) async {
  setState(ViewState.busy);
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update Firebase Auth profile with display name
    await userCredential.user!.updateDisplayName(name);
    await userCredential.user!.reload();

    // Save user info in Firestore
    appUser.id = userCredential.user!.uid;
    appUser.email = email;
    appUser.name = name; // Save the name in your custom user object
    await authServices.register(appUser);

    // Reinitialize providers
    reinitializeProviders(context);

    setState(ViewState.idle);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    setState(ViewState.idle);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Registration failed'), backgroundColor: Colors.red),
    );
  }
}


  Future<void> registerUser(
      BuildContext context, Widget? navigateToScreen) async {
    setState(ViewState.busy);
    appUser.name = nameController.text;
    await authServices.register(appUser);

    // Reinitialize providers after registration
    reinitializeProviders(context);

    setState(ViewState.idle);
    if (navigateToScreen != null) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }


// Add this method to your AuthScreensProvider class

Future<void> resetPassword(String email, BuildContext context) async {
  setState(ViewState.busy);
  try {
    await _auth.sendPasswordResetEmail(email: email);
    setState(ViewState.idle);
    
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Link Sent'),
          content: Text(
            'A password reset link has been sent to $email. Please check your email and follow the instructions to reset your password.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } on FirebaseAuthException catch (e) {
    setState(ViewState.idle);
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      default:
        message = e.message ?? 'Failed to send reset email.';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    setState(ViewState.idle);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An unexpected error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
