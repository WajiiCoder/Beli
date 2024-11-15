import 'package:flutter/material.dart';

class KYCVerificationScreen extends StatefulWidget {
  @override
  _KYCVerificationScreenState createState() => _KYCVerificationScreenState();
}

class _KYCVerificationScreenState extends State<KYCVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _dob = '';
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Verification'),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide your details to complete KYC verification.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                ),
                onChanged: (value) {
                  setState(() {
                    _dob = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process KYC verification
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('KYC Verified!'),
                      ),
                    );
                    Navigator.pushNamed(context,
                        '/browseinventoryScreen'); // Return to previous screen
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
