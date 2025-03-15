import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Sample events
    _events = {
      DateTime(2024, 8, 1): ['Appointment with Dr. Archita'],
      DateTime(2024, 7, 12): ['Appointment with Dr. Smith'],
      DateTime(2024, 7, 27): ['Appointment with Dr. Ian'],
    };
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your Appointments',
          style: TextStyle(
            color: Color(0xFF056E55),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/profile_picture.png'),
            radius: 20,
          ),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCurrentDateDisplay(),
            const SizedBox(height: 16),
            Text(
              'View upcoming and past appointments.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Card(
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: _getEventsForDay,
                // Add these properties:
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color:
                        const Color(0xFF2E8B57).withAlpha((0.5 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF2E8B57),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFF2E8B57),
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2E8B57),
                          ),
                          width: 6,
                          height: 6,
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildUpcomingAppointments(),
            const SizedBox(height: 16),
            _buildPastAppointments(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentDateDisplay() {
    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now);
    String monthDay = DateFormat('MMMM d').format(now);
    String year = DateFormat('yyyy').format(now);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF056E55),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                monthDay,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            year,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildAppointmentItem('Dr. Smith', DateTime(2024, 12, 5, 10, 0)),
            _buildAppointmentItem('Dr. Dan', DateTime(2024, 12, 15, 11, 0)),
            _buildAppointmentItem('Dr. Ian', DateTime(2024, 12, 22, 10, 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildPastAppointments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Past Appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildPastAppointmentItem('Dr Smith', DateTime(2024, 7, 12, 9, 0)),
            _buildPastAppointmentItem('Dr Dan', DateTime(2024, 7, 14, 11, 0)),
            _buildPastAppointmentItem('Dr Ian', DateTime(2024, 7, 27, 10, 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(String doctor, DateTime dateTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => _selectDateInCalendar(dateTime),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF2E8B57)),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd MMM').format(dateTime)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => _showReminderDialog(doctor, dateTime),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFF2E8B57)),
                  const SizedBox(width: 8),
                  Text(DateFormat('hh:mm a').format(dateTime)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(doctor,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  void _showReminderDialog(String doctor, DateTime dateTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set a reminder?'),
          content: Text(
              'Would you like to set a reminder for your appointment with $doctor on ${DateFormat('dd MMM, hh:mm a').format(dateTime)}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // TODO: Implement reminder setting logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Reminder set for appointment with $doctor')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _selectDateInCalendar(DateTime date) {
    setState(() {
      _selectedDay = date;
      _focusedDay = date;
    });
  }

  Widget _buildPastAppointmentItem(String doctor, DateTime dateTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => _selectDateInCalendar(dateTime),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF2E8B57)),
                  const SizedBox(width: 8),
                  Text(DateFormat('dd MMM').format(dateTime)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFF2E8B57)),
                const SizedBox(width: 8),
                Text(DateFormat('hh:mm a').format(dateTime)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(doctor,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
