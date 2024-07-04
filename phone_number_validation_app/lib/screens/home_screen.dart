import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country.dart';
import '../services/twilio_service.dart';
import 'country_picker_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  Country _selectedCountry = Country('Hong Kong', '852');
  List<Map<String, dynamic>> _phoneNumbers = [];

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('phone_numbers');
    if (storedData != null) {
      setState(() {
        _phoneNumbers = List<Map<String, dynamic>>.from(jsonDecode(storedData));
      });
    }
  }

  Future<void> _showStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('phone_numbers');
    final phoneNumbers = storedData != null
        ? List<Map<String, dynamic>>.from(jsonDecode(storedData))
        : [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stored Phone Numbers'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: phoneNumbers.length,
              itemBuilder: (BuildContext context, int index) {
                final phoneNumber = phoneNumbers[index];
                final isValid = phoneNumber['isValid'];
                return ListTile(
                  leading: Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  ),
                  title: Text(phoneNumber['number']),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePhoneNumber(String number, bool isValid) async {
    final prefs = await SharedPreferences.getInstance();
    _phoneNumbers.add({'number': number, 'isValid': isValid});
    await prefs.setString('phone_numbers', jsonEncode(_phoneNumbers));
  }

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            color: Colors.lightBlueAccent,
            child: Center(
              child: Text(
                'Phone Number Validation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Image.asset(
              'icon.png',
              width: 100.0,
              height: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Please enter a phone number',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CountryPickerScreen()),
                );
                if (result != null) {
                  setState(() {
                    _selectedCountry = result;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_selectedCountry.phoneCode} ${_selectedCountry.name}'),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final phoneNumber = '${_selectedCountry.phoneCode}${_phoneController.text}';
                final isValid = await TwilioService().validatePhoneNumber(phoneNumber);
                await _savePhoneNumber(phoneNumber, isValid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isValid ? 'Phone number saved' : 'Invalid phone number')),
                );
              },
              child: Text('Confirm'),
            ),
          ],)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showStoredData,
        child: Icon(Icons.storage),
      ),
    );
  }
}
