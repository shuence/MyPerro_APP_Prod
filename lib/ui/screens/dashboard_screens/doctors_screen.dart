import 'package:flutter/material.dart';

class DoctorsScreen extends StatefulWidget {
  final Function(String doctorName, String appointmentTime) onAppointmentBooked;

  const DoctorsScreen({super.key, required this.onAppointmentBooked});

  @override
  _DoctorsScreenState createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  String selectedDoctor = '';
  TimeOfDay? selectedTime;

  final List<Map<String, String>> doctors = [
    {'name': 'Dr. Rajendra Prasad', 'location': 'Phirangipuram, Bangalore 522238'},
    {'name': 'Dr. Aarav Patel', 'location': 'Koramangala, Bangalore 400050'},
    {'name': 'Dr. Ananya Reddy', 'location': 'Koramangala, Bangalore, Karnataka 560095'},
    {'name': 'Dr. Vikram Singh', 'location': 'Koramangala, Bengaluru 400050'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Doctor:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedDoctor.isEmpty ? null : selectedDoctor,
              hint: const Text('Select Doctor'),
              items: doctors.map((doctor) {
                return DropdownMenuItem<String>(
                  value: doctor['name'],
                  child: Text(doctor['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDoctor = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Select Appointment Time:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _selectTime,
              child: Text(selectedTime == null ? 'Select Time' : selectedTime!.format(context)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookAppointment,
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  // Time Picker
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Booking the appointment and adding it to the routine
  void _bookAppointment() {
    if (selectedDoctor.isEmpty || selectedTime == null) {
      return;
    }
    String formattedTime = selectedTime!.format(context);
    widget.onAppointmentBooked(selectedDoctor, formattedTime);  // Pass the booking to the routine
    Navigator.pop(context); // Go back to the dashboard
  }
}
