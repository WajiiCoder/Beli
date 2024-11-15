import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/session.dart';
import 'package:vendor_mate/Constants/user_status.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserSession();
    });
  }

  Future<void> _checkUserSession() async {
    SessionManager sessionManager = SessionManager();

    // Retrieve session data
    // String? sessionToken = await sessionManager.getSessionToken();
    // String? vendorId = await sessionManager.getVendorId();
    // String? userId = await sessionManager.getUserId();

    // Log session data for debugging
    debugPrint("Session Token : ${UserStatus.sessiontoken}");
    debugPrint("Vendor Id :${UserStatus.vendorId}");
    debugPrint("User Id : ${UserStatus.userId}");

    if (UserStatus.sessiontoken != null &&
        UserStatus.userId != null &&
        UserStatus.userId!.isNotEmpty &&
        UserStatus.vendorId != null &&
        UserStatus.vendorId!.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/homev2');
    } else if (UserStatus.sessiontoken != null &&
        UserStatus.userId != null &&
        UserStatus.userId!.isNotEmpty &&
        (UserStatus.vendorId == null || UserStatus.vendorId!.isEmpty)) {
      Navigator.pushReplacementNamed(context, '/profileSetup');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
