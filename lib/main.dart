import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:io';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (_) {
    cameras = [];
  }
  runApp(const UniversityEMSApp());
}

class UniversityEMSApp extends StatelessWidget {
  const UniversityEMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University EMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0B4F8A),
        scaffoldBackgroundColor: const Color(0xFFF4F7FA),
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}

class UserAccount {
  final String username;
  final String password;
  final String name;
  final String role;

  const UserAccount({
    required this.username,
    required this.password,
    required this.name,
    required this.role,
  });
}

class StaffModel {
  final String id;
  final String name;
  final String department;
  final String office;
  bool faceRegistered;
  final String email;

  StaffModel({
    required this.id,
    required this.name,
    required this.department,
    required this.office,
    required this.faceRegistered,
    required this.email,
  });
}

class EventModel {
  final String id;
  String title;
  String venue;
  String department;
  String office;
  String organizer;
  String description;
  int capacity;
  DateTime dateTime;
  bool isOpen;
  List<String> presentIds;

  EventModel({
    required this.id,
    required this.title,
    required this.venue,
    required this.department,
    required this.office,
    required this.organizer,
    required this.description,
    required this.capacity,
    required this.dateTime,
    this.isOpen = false,
    List<String>? presentIds,
  }) : presentIds = presentIds ?? [];
}

class AttendanceLog {
  final String eventId;
  final String staffId;
  final DateTime timeIn;
  final String status;
  final String method;

  AttendanceLog({
    required this.eventId,
    required this.staffId,
    required this.timeIn,
    required this.status,
    required this.method,
  });
}

class AppSettings {
  bool largeText;
  bool simpleMode;

  AppSettings({
    this.largeText = false,
    this.simpleMode = true,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  String errorText = '';

  final List<UserAccount> accounts = const [
    UserAccount(
      username: 'admin',
      password: '1234',
      name: 'University Admin',
      role: 'Super Admin',
    ),
    UserAccount(
      username: 'deptadmin',
      password: '1234',
      name: 'Department Admin',
      role: 'Department Admin',
    ),
    UserAccount(
      username: 'scanner',
      password: '1234',
      name: 'Scanner Operator',
      role: 'Scanner',
    ),
  ];

  void handleLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    UserAccount? matched;
    for (final account in accounts) {
      if (account.username == username && account.password == password) {
        matched = account;
        break;
      }
    }

    if (matched != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeShell(
            adminName: matched!.name,
            role: matched.role,
          ),
        ),
      );
    } else {
      setState(() {
        errorText = 'Invalid username or password.';
      });
    }
  }

  Widget buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, isMobile ? 32 : 40, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0B4F8A),
            Color(0xFF156BB5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.account_balance_rounded,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Event Management System',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontSize: isMobile ? 28 : 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Smart Facial Recognition for University Offices and Departments',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Demo accounts:\nadmin / 1234\ndeptadmin / 1234\nscanner / 1234',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFEAF2FB),
            child: Icon(
              Icons.admin_panel_settings_rounded,
              size: 32,
              color: Color(0xFF0B4F8A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14213D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to manage events and attendance records.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: passwordController,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          if (errorText.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B4F8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        if (isMobile) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildHeader(true),
                    buildLoginCard(),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                Expanded(flex: 5, child: buildHeader(false)),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: buildLoginCard(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  final String adminName;
  final String role;

  const HomeShell({
    super.key,
    required this.adminName,
    required this.role,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;
  final settings = AppSettings();

  String selectedEventId = '';
  String selectedDepartmentFilter = 'All';
  String selectedAttendanceFilter = 'All';
  String dashboardMessage = 'System ready.';
  String scanMessage = 'Ready to open camera.';

  final TextEditingController eventSearchController = TextEditingController();
  final TextEditingController attendanceSearchController =
  TextEditingController();
  final TextEditingController faceSearchController = TextEditingController();

  final List<String> departments = [
    'All',
    'Campus Ministry',
    'College of Information Technology',
    'Registrar',
    'Guidance Office',
    'Human Resource',
  ];

  late List<StaffModel> staff;
  late List<EventModel> events;
  late List<AttendanceLog> logs;

  bool isLoadingEvents = false;
  String? eventsError;

  @override
  void initState() {
    super.initState();

    staff = [
      StaffModel(
        id: 'EMP-001',
        name: 'Jeremiah Marcelo',
        department: 'Campus Ministry',
        office: 'Chaplain Office',
        faceRegistered: true,
        email: 'jeremiah@uls.edu',
      ),
      StaffModel(
        id: 'EMP-002',
        name: 'Marie Genielle Mendoza',
        department: 'College of Information Technology',
        office: 'IT Office',
        faceRegistered: true,
        email: 'marie@uls.edu',
      ),
      StaffModel(
        id: 'EMP-003',
        name: 'Justine Mariano',
        department: 'Registrar',
        office: 'Academic Records Office',
        faceRegistered: true,
        email: 'justine@uls.edu',
      ),
      StaffModel(
        id: 'EMP-004',
        name: 'Charibelle Guzman',
        department: 'Guidance Office',
        office: 'Student Affairs Office',
        faceRegistered: true,
        email: 'charibelle@uls.edu',
      ),
      StaffModel(
        id: 'EMP-005',
        name: 'Ava Dela Cruz',
        department: 'Human Resource',
        office: 'HR Office',
        faceRegistered: false,
        email: 'ava@uls.edu',
      ),

    ];

    events = [];

    logs = [];
    loadEvents();

  }
  Future<void> loadEvents() async {
    setState(() {
      isLoadingEvents = true;
      eventsError = null;
    });

    try {
      print('loadEvents() started');

      final data = await ApiService.getEvents();
      print('RAW API DATA: $data');

      final loadedEvents = data.map<EventModel>((e) {
        final rawDate =
            e['date_time'] ?? e['starts_at'] ?? e['event_date'] ?? e['date'];

        print('EVENT ITEM: $e');
        print('RAW DATE: $rawDate');

        return EventModel(
          id: e['id'].toString(),
          title: (e['title'] ?? '').toString(),
          venue: (e['venue'] ?? '').toString(),
          department: (e['department'] ?? '').toString(),
          office: (e['office'] ?? '').toString(),
          organizer: (e['organizer'] ?? '').toString(),
          description: (e['description'] ?? '').toString(),
          capacity: e['capacity'] is int
              ? e['capacity']
              : int.tryParse(e['capacity']?.toString() ?? '0') ?? 0,
          dateTime: rawDate != null
              ? DateTime.tryParse(rawDate.toString()) ?? DateTime.now()
              : DateTime.now(),
          isOpen: e['is_open'] == 1 || e['is_open'] == true,
        );
      }).toList();

      print('LOADED EVENTS COUNT: ${loadedEvents.length}');

      setState(() {
        events = loadedEvents;

        if (events.isNotEmpty) {
          final stillExists = events.any((e) => e.id == selectedEventId);
          selectedEventId = stillExists ? selectedEventId : events.first.id;
        } else {
          selectedEventId = '';
        }
      });

      print('EVENTS IN STATE: ${events.length}');
    } catch (e) {
      print('API ERROR IN loadEvents(): $e');

      setState(() {
        eventsError = e.toString();
        events = [];
        selectedEventId = '';
      });
    } finally {
      setState(() {
        isLoadingEvents = false;
      });
    }
  }

  double get fontScale => settings.largeText ? 1.15 : 1.0;

  EventModel? get currentEventOrNull {
    try {
      return events.firstWhere((event) => event.id == selectedEventId);
    } catch (_) {
      return null;
    }
  }

  int get totalAttendance => logs.length;
  int get openEventsCount => events.where((e) => e.isOpen).length;
  int get registeredFaces => staff.where((s) => s.faceRegistered).length;

  List<EventModel> get filteredEvents {
    return events.where((event) {
      final matchesDepartment = selectedDepartmentFilter == 'All' ||
          event.department == selectedDepartmentFilter;

      final query = eventSearchController.text.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          event.title.toLowerCase().contains(query) ||
          event.venue.toLowerCase().contains(query) ||
          event.department.toLowerCase().contains(query);

      return matchesDepartment && matchesSearch;
    }).toList();
  }

  List<AttendanceLog> get filteredLogs {
    return logs.where((log) {
      final person = staff.firstWhere((s) => s.id == log.staffId);
      final event = events.firstWhere((e) => e.id == log.eventId);

      final query = attendanceSearchController.text.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          person.name.toLowerCase().contains(query) ||
          event.title.toLowerCase().contains(query) ||
          person.department.toLowerCase().contains(query);

      final matchesFilter = selectedAttendanceFilter == 'All' ||
          person.department == selectedAttendanceFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<StaffModel> get filteredFaces {
    return staff.where((person) {
      final q = faceSearchController.text.trim().toLowerCase();
      return q.isEmpty ||
          person.name.toLowerCase().contains(q) ||
          person.department.toLowerCase().contains(q) ||
          person.id.toLowerCase().contains(q);
    }).toList();
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void toggleEventStatus(EventModel event) {
    setState(() {
      event.isOpen = !event.isOpen;
      dashboardMessage =
      '${event.title} is now ${event.isOpen ? 'open' : 'closed'}.';
    });
  }

  void addEvent({
    required String title,
    required String venue,
    required String department,
    required String office,
    required String organizer,
    required String description,
    required int capacity,
    required DateTime dateTime,
  }) {
    setState(() {
      events.add(
        EventModel(
          id: 'EVT-${(events.length + 1).toString().padLeft(3, '0')}',
          title: title,
          venue: venue,
          department: department,
          office: office,
          organizer: organizer,
          description: description,
          capacity: capacity,
          dateTime: dateTime,
        ),
      );
      dashboardMessage = 'New event added successfully.';
    });
  }

  void editEvent(EventModel event) {
    final titleController = TextEditingController(text: event.title);
    final venueController = TextEditingController(text: event.venue);
    final deptController = TextEditingController(text: event.department);
    final officeController = TextEditingController(text: event.office);
    final organizerController = TextEditingController(text: event.organizer);
    final descriptionController =
    TextEditingController(text: event.description);
    final capacityController =
    TextEditingController(text: event.capacity.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Event'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Event Title')),
              const SizedBox(height: 10),
              TextField(controller: venueController, decoration: const InputDecoration(labelText: 'Venue')),
              const SizedBox(height: 10),
              TextField(controller: deptController, decoration: const InputDecoration(labelText: 'Department')),
              const SizedBox(height: 10),
              TextField(controller: officeController, decoration: const InputDecoration(labelText: 'Office')),
              const SizedBox(height: 10),
              TextField(controller: organizerController, decoration: const InputDecoration(labelText: 'Organizer')),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: null, // 👈 unlimited
                minLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await ApiService.updateEvent(
                id: event.id,
                title: titleController.text.trim(),
                venue: venueController.text.trim(),
                department: deptController.text.trim(),
                office: officeController.text.trim(),
                organizer: organizerController.text.trim(),
                description: descriptionController.text.trim(),
                capacity: int.tryParse(capacityController.text.trim()) ?? 0,
              );

              if (!mounted) return;

              if (result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event updated successfully'),
                  ),
                );

                Navigator.pop(context);
                await loadEvents();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Update failed: ${result['body']}'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteEvent(EventModel event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await ApiService.deleteEvent(event.id);

              if (!mounted) return;

              Navigator.pop(context);

              if (result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event deleted successfully'),
                  ),
                );

                await loadEvents();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Delete failed: ${result['body']}'),
                  ),
                );
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void showAddEventDialog() {
    final titleController = TextEditingController();
    final venueController = TextEditingController();
    final deptController = TextEditingController();
    final officeController = TextEditingController();
    final organizerController = TextEditingController();
    final descriptionController = TextEditingController();
    final capacityController = TextEditingController(text: '100');

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Event Title')),
                const SizedBox(height: 10),
                TextField(controller: venueController, decoration: const InputDecoration(labelText: 'Venue')),
                const SizedBox(height: 10),
                TextField(controller: deptController, decoration: const InputDecoration(labelText: 'Department')),
                const SizedBox(height: 10),
                TextField(controller: officeController, decoration: const InputDecoration(labelText: 'Office')),
                const SizedBox(height: 10),
                TextField(controller: organizerController, decoration: const InputDecoration(labelText: 'Organizer')),
                const SizedBox(height: 10),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 10),
                TextField(
                  controller: capacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Capacity'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Event Date'),
                  subtitle: Text(
                    '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await ApiService.createEvent(
                  title: titleController.text.trim(),
                  venue: venueController.text.trim(),
                  department: deptController.text.trim(),
                  office: officeController.text.trim(),
                  organizer: organizerController.text.trim(),
                  description: descriptionController.text.trim(),
                  capacity: int.tryParse(capacityController.text.trim()) ?? 100,
                  dateTime: selectedDate.toIso8601String(),
                );

                if (!mounted) return;

                if (result['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event added successfully'),
                    ),
                  );

                  Navigator.pop(context);
                  await loadEvents();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Add failed: ${result['body']}'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void toggleFaceEnrollment(StaffModel person) {
    setState(() {
      person.faceRegistered = !person.faceRegistered;
      dashboardMessage =
      '${person.name} face enrollment ${person.faceRegistered ? 'enabled' : 'disabled'}.';
    });
  }

  void addAttendance({
    required String staffId,
    required String method,
  }) {
    final currentEvent = currentEventOrNull;

    if (currentEvent == null) {
      setState(() {
        scanMessage = 'No selected event.';
      });
      return;
    }

    final alreadyPresent =
    currentEvent.presentIds.any((existingId) => existingId == staffId);

    if (alreadyPresent) {
      setState(() {
        scanMessage = 'This staff member is already checked in.';
      });
      return;
    }

    final eventStart = currentEvent.dateTime;
    final status =
    DateTime.now().isAfter(eventStart) ? 'Late' : 'On Time';

    setState(() {
      currentEvent.presentIds.add(staffId);
      logs.add(
        AttendanceLog(
          eventId: currentEvent.id,
          staffId: staffId,
          timeIn: DateTime.now(),
          status: status,
          method: method,
        ),
      );
      final person = staff.firstWhere((s) => s.id == staffId);
      scanMessage = '${person.name} marked present successfully.';
    });
  }

  Future<void> openCameraScanner() async {
    final currentEvent = currentEventOrNull;

    if (currentEvent == null) {
      setState(() {
        scanMessage = 'No event selected.';
      });
      return;
    }

    if (!currentEvent.isOpen) {
      setState(() {
        scanMessage = 'Selected event is closed. Open it first.';
      });
      return;
    }

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => FaceScanCameraPage(
          eventTitle: currentEvent.title,
          cameras: cameras,
        ),
      ),
    );

    if (result == null) return;

    if (result.isNotEmpty) {
      StaffModel? nextCandidate;
      for (final person in staff) {
        if (!currentEvent.presentIds.contains(person.id)) {
          nextCandidate = person;
          break;
        }
      }
      nextCandidate ??= staff.first;

      if (!nextCandidate.faceRegistered) {
        setState(() {
          scanMessage = 'Face not registered for ${nextCandidate!.name}.';
        });
        return;
      }

      final imageFile = File(result);

      final faceResult =
      await ApiService.matchFace(imageFile);

      print(
        'FACE MATCH RESULT: ${faceResult['body']}',
      );

      if (faceResult['success'] != true) {
        return;
      }

      final detectedStaffId =
      faceResult['body']['staff_id'];

      final response =
      await ApiService.getStaffById(
        detectedStaffId,
      );

      print(
        'SCAN STAFF RESPONSE: ${response['body']}',
      );
      //here
      final attendanceResult = await ApiService.saveAttendance(
        eventId: currentEvent.id,
        staffId: detectedStaffId,
        method: 'Face Scan',
      );

      print('ATTENDANCE RESULT: ${attendanceResult['body']}');

      if (!mounted) return;

      if (attendanceResult['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face attendance saved successfully'),
          ),
        );

        setState(() {
          scanMessage = 'Face attendance saved successfully.';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance failed: ${attendanceResult['body']}'),
          ),
        );
      }

    } else {
      setState(() {
        scanMessage = result;
      });
    }
  }

  void manualAttendanceDialog() {
    String? chosenStaffId;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Manual Attendance'),
        content: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Select Staff',
            border: OutlineInputBorder(),
          ),
          items: staff
              .map(
                (person) => DropdownMenuItem(
              value: person.id,
              child: Text(person.name),
            ),
          )
              .toList(),
          onChanged: (value) {
            chosenStaffId = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
onPressed: () async {//HERE

  if (chosenStaffId != null) {

    final result =
        await ApiService.saveAttendance(
      eventId: currentEventOrNull!.id,
      staffId: chosenStaffId!,
      method: 'Manual Entry',
    );

    print(
      'ATTENDANCE RESULT: ${result['body']}',
    );

    if (!mounted) return;

    if (result['success'] == true) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Attendance saved successfully',
          ),
        ),
      );

      setState(() {
        scanMessage =
            'Manual attendance recorded successfully.';
      });

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Failed: ${result['body']}',
          ),
        ),
      );
    }
  }

  Navigator.pop(context);
}, //HERE
            
            child: const Text('Mark Present'),
          ),
        ],
      ),
    );
  }

  void showSimpleExportMessage(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type export workflow is ready for package integration later.'),
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0B4F8A)),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13 * fontScale,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 21 * fontScale,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14213D),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionCard(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18 * fontScale,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14213D),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget buildDashboard() {
    final currentEvent = currentEventOrNull;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: [Color(0xFF0B4F8A), Color(0xFF156BB5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${widget.adminName}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14 * fontScale,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'University Event Management Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * fontScale,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Role: ${widget.role}\n$dashboardMessage',
                style: TextStyle(
                  color: Colors.white.withOpacity(.92),
                  height: 1.5,
                  fontSize: 14 * fontScale,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: statCard('Total Events', '${events.length}', Icons.event_note_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard('Open Events', '$openEventsCount', Icons.lock_open_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: statCard('Attendance Logs', '$totalAttendance', Icons.fact_check_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard('Registered Faces', '$registeredFaces', Icons.face_retouching_natural_rounded),
            ),
          ],
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Quick Actions',
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: showAddEventDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Event'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => selectedIndex = 2);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Go to Scan'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => selectedIndex = 4);
                },
                icon: const Icon(Icons.face),
                label: const Text('Face Enrollment'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Highlighted Event',
          currentEvent == null
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No events available.'),
          )
              : ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFFEAF2FB),
              child: Icon(Icons.church_rounded, color: Color(0xFF0B4F8A)),
            ),
            title: Text(
              currentEvent.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16 * fontScale,
              ),
            ),
            subtitle: Text(
              '${currentEvent.department} • ${currentEvent.office}\n${currentEvent.venue}',
              style: TextStyle(fontSize: 13 * fontScale),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: currentEvent.isOpen
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                currentEvent.isOpen ? 'OPEN' : 'CLOSED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12 * fontScale,
                  color: currentEvent.isOpen
                      ? Colors.green.shade800
                      : Colors.orange.shade800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEventsPage() {
    if (isLoadingEvents) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventsError != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Failed to load events:\n$eventsError',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionCard(
          'Event Filters',
          Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedDepartmentFilter,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                decoration: const InputDecoration(
                  labelText: 'Filter by Department',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: departments.map((d) {
                  return DropdownMenuItem<String>(
                    value: d,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        d,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartmentFilter = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: eventSearchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Search Events',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: showAddEventDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
          ),
        ),

        const SizedBox(height: 16),
          sectionCard(
            'Event Management',
            filteredEvents.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('No events available.'),
            )
                : Column(
              children: filteredEvents.map((event) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: event.id == selectedEventId
                        ? const Color(0xFFEAF3FF)
                        : const Color(0xFFF9FBFD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: event.id == selectedEventId
                          ? const Color(0xFF0B4F8A)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  color: event.isOpen
                                      ? Colors.green
                                      : const Color(0xFF0B4F8A),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16 * fontScale,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${event.department} • ${event.office}',
                                      style: TextStyle(
                                        fontSize: 13 * fontScale,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      event.venue,
                                      style: TextStyle(
                                        fontSize: 13 * fontScale,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Organizer: ${event.organizer}',
                                      style: TextStyle(
                                        fontSize: 13 * fontScale,
                                        color: Colors.black54,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => editEvent(event),
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => deleteEvent(event),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Delete'),
                              ),

                              // 👉 ADD THIS BUTTON
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final staffResponse = await ApiService.getStaffById("EMP-001");

                                  if (!mounted) return;

                                  if (staffResponse['success'] == true) {
                                    final result = await ApiService.saveAttendance(
                                      eventId: event.id,
                                      staffId: "EMP-001",
                                      method: "Face Scan",
                                    );

                                    if (!mounted) return;

                                    if (result['success'] == true) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Attendance saved successfully'),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed: ${result['body']}'),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Staff not found: ${staffResponse['body']}'),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.check),
                                label: const Text('Mark Present'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget infoMiniCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0B4F8A)),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.black54, fontSize: 12 * fontScale),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14 * fontScale,
              color: const Color(0xFF14213D),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAttendancePage() {
    final currentEvent = currentEventOrNull;

    if (currentEvent == null) {
      return const Center(
        child: Text('No event available.'),
      );
    }

    final currentPresent =
    logs.where((log) => log.eventId == currentEvent.id).toList();


    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionCard(
          'Smart Facial Recognition Scanner',
          Column(
            children: [
              DropdownButtonFormField<String>(
                value: events.any((e) => e.id == selectedEventId)
                    ? selectedEventId
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Select Event',
                  border: OutlineInputBorder(),
                ),
                items: events.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(
                      e.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedEventId = value;
                    scanMessage = 'Ready to open camera.';
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBFD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Color(0xFFEAF2FB),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 34,
                        color: Color(0xFF0B4F8A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentEvent.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * fontScale,
                        color: const Color(0xFF14213D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scanMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                        fontSize: 14 * fontScale,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: openCameraScanner,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Open Face Scan Camera'),
                        ),
                        OutlinedButton.icon(
                          onPressed: manualAttendanceDialog,
                          icon: const Icon(Icons.edit_note),
                          label: const Text('Manual Attendance'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: infoMiniCard(
                      'Selected Event',
                      currentEvent.title,
                      Icons.event,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: infoMiniCard(
                      'Present Count',
                      '${currentEvent.presentIds.length}',
                      Icons.groups,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Attendance Logs for Selected Event',
          currentPresent.isEmpty
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No attendance record yet.'),
          )
              : Column(
            children: currentPresent.map((log) {
              final person = staff.firstWhere((s) => s.id == log.staffId);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEAFBF0),
                  child: Icon(Icons.check_circle, color: Colors.green),
                ),
                title: Text(
                  person.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15 * fontScale,
                  ),
                ),
                subtitle: Text(
                  '${person.department} • ${log.method}\n${log.timeIn.hour.toString().padLeft(2, '0')}:${log.timeIn.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 13 * fontScale),
                ),
                trailing: Text(
                  log.status,
                  style: TextStyle(
                    color: log.status == 'Late' ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * fontScale,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildAttendanceHistoryPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionCard(
          'Attendance Filters',
          Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedDepartmentFilter,
                decoration: const InputDecoration(
                  labelText: 'Filter by Department',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                isExpanded: true,
                items: departments.map((d) {
                  return DropdownMenuItem<String>(
                    value: d,
                    child: Text(
                      d,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartmentFilter = value!;
                  });
                },
              ),

              const SizedBox(height: 12),

              TextField(
                controller: eventSearchController,
                decoration: const InputDecoration(
                  hintText: 'Search Events',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Attendance History',
          filteredLogs.isEmpty
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No records found.'),
          )
              : Column(
            children: filteredLogs.map((log) {
              final person = staff.firstWhere((s) => s.id == log.staffId);
              final event = events.firstWhere((e) => e.id == log.eventId);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEAF2FB),
                  child: Icon(Icons.history, color: Color(0xFF0B4F8A)),
                ),
                title: Text(
                  person.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15 * fontScale,
                  ),
                ),
                subtitle: Text(
                  '${event.title}\n${person.department} • ${log.method}',
                  style: TextStyle(fontSize: 13 * fontScale),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      log.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: log.status == 'Late'
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                    Text(
                      '${log.timeIn.month}/${log.timeIn.day}',
                      style: TextStyle(fontSize: 12 * fontScale),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildFaceEnrollmentPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionCard(
          'Search Staff',
          TextField(
            controller: faceSearchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Search by name, ID, or department',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Face Enrollment',
          Column(
            children: filteredFaces.map((person) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBFD),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: person.faceRegistered
                        ? const Color(0xFFEAFBF0)
                        : const Color(0xFFFFF4E5),
                    child: Icon(
                      person.faceRegistered ? Icons.face : Icons.face_retouching_off,
                      color: person.faceRegistered ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(
                    person.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * fontScale,
                    ),
                  ),
                  subtitle: Text(
                    '${person.id} • ${person.department}\n${person.office}',
                    style: TextStyle(fontSize: 13 * fontScale),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => toggleFaceEnrollment(person),
                    child: Text(person.faceRegistered ? 'Disable' : 'Enroll'),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget reportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14 * fontScale),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14 * fontScale,
              color: const Color(0xFF0B4F8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReportsPage() {
    final departmentSummary = <String, int>{};
    for (final log in logs) {
      final person = staff.firstWhere((s) => s.id == log.staffId);
      departmentSummary[person.department] =
          (departmentSummary[person.department] ?? 0) + 1;
    }

    final EventModel? mostAttended = events.isEmpty
        ? null
        : events.reduce(
          (a, b) => a.presentIds.length >= b.presentIds.length ? a : b,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionCard(
          'Attendance Summary Report',
          Column(
            children: [
              reportRow('Total Staff', '${staff.length}'),
              reportRow('Registered Faces', '$registeredFaces'),
              reportRow('Total Events', '${events.length}'),
              reportRow('Total Attendance Logs', '$totalAttendance'),
              reportRow('Currently Open Events', '$openEventsCount'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Most Attended Event',
          mostAttended == null
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No events available.'),
          )
              : ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFEAF2FB),
              child: Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFF0B4F8A),
              ),
            ),
            title: Text(
              mostAttended.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * fontScale,
              ),
            ),
            subtitle: Text(
              '${mostAttended.department} • ${mostAttended.venue}',
              style: TextStyle(fontSize: 13 * fontScale),
            ),
            trailing: Text(
              '${mostAttended.presentIds.length} present',
              style: TextStyle(
                color: const Color(0xFF0B4F8A),
                fontWeight: FontWeight.bold,
                fontSize: 13 * fontScale,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Department Participation',
          departmentSummary.isEmpty
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No department attendance data yet.'),
          )
              : Column(
            children: departmentSummary.entries.map((entry) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.apartment,
                  color: Color(0xFF0B4F8A),
                ),
                title: Text(entry.key),
                trailing: Text(
                  '${entry.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B4F8A),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Export Options',
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => showSimpleExportMessage('PDF'),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export PDF'),
              ),
              ElevatedButton.icon(
                onPressed: () => showSimpleExportMessage('Excel'),
                icon: const Icon(Icons.table_chart),
                label: const Text('Export Excel'),
              ),
              ElevatedButton.icon(
                onPressed: () => showSimpleExportMessage('CSV'),
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSettingsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        sectionCard(
          'Accessibility and Display',
          Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: settings.largeText,
                title: const Text('Large Text Mode'),
                subtitle: const Text('Makes text easier to read'),
                onChanged: (value) {
                  setState(() {
                    settings.largeText = value;
                  });
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: settings.simpleMode,
                title: const Text('Simple Interface Mode'),
                subtitle: const Text('Keeps the layout clear and easy to use'),
                onChanged: (value) {
                  setState(() {
                    settings.simpleMode = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        sectionCard(
          'Account',
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person, color: Color(0xFF0B4F8A)),
                title: Text(widget.adminName),
                subtitle: Text(widget.role),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.school, color: Color(0xFF0B4F8A)),
                title: const Text('University EMS'),
                subtitle: const Text('Prototype with camera scan workflow'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> get pages => [
    buildDashboard(),
    buildEventsPage(),
    buildAttendancePage(),
    buildAttendanceHistoryPage(),
    buildFaceEnrollmentPage(),
    buildReportsPage(),
    buildSettingsPage(),
  ];

  List<String> get titles => [
    'Dashboard',
    'Events',
    'Attendance',
    'History',
    'Face Enrollment',
    'Reports',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[selectedIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20 * fontScale,
            color: const Color(0xFF14213D),
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout, color: Color(0xFF0B4F8A)),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF0B4F8A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B4F8A), Color(0xFF156BB5)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.adminName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.role,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              drawerItem(Icons.dashboard_customize_rounded, 'Dashboard', 0),
              drawerItem(Icons.event_note_rounded, 'Events', 1),
              drawerItem(Icons.face_retouching_natural_rounded, 'Attendance', 2),
              drawerItem(Icons.history, 'History', 3),
              drawerItem(Icons.face, 'Face Enrollment', 4),
              drawerItem(Icons.assessment_rounded, 'Reports', 5),
              drawerItem(Icons.settings, 'Settings', 6),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: showAddEventDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B4F8A),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Event'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex <= 4 ? selectedIndex : 0,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_rounded),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.face_retouching_natural_rounded),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_rounded),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String label, int index) {
    final selected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? const Color(0xFF0B4F8A) : Colors.black54,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? const Color(0xFF0B4F8A) : Colors.black87,
        ),
      ),
      selected: selected,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}

class FaceScanCameraPage extends StatefulWidget {
  final String eventTitle;
  final List<CameraDescription> cameras;

  const FaceScanCameraPage({
    super.key,
    required this.eventTitle,
    required this.cameras,
  });

  @override
  State<FaceScanCameraPage> createState() => _FaceScanCameraPageState();
}

class _FaceScanCameraPageState extends State<FaceScanCameraPage> {
  CameraController? controller;
  bool isReady = false;
  bool useFront = true;
  String status = 'Initializing camera...';

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async {
    if (widget.cameras.isEmpty) {
      setState(() {
        status = 'No camera available on this device.';
      });
      return;
    }

    CameraDescription selectedCamera;
    try {
      selectedCamera = widget.cameras.firstWhere(
            (cam) => useFront
            ? cam.lensDirection == CameraLensDirection.front
            : cam.lensDirection == CameraLensDirection.back,
      );
    } catch (_) {
      selectedCamera = widget.cameras.first;
    }

    await controller?.dispose();

    controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await controller!.initialize();
      if (!mounted) return;
      setState(() {
        isReady = true;
        status = 'Camera ready. Align face inside the frame.';
      });
    } catch (_) {
      setState(() {
        status = 'Unable to open camera.';
      });
    }
  }

  Future<void> switchCamera() async {
    setState(() {
      isReady = false;
      useFront = !useFront;
      status = 'Switching camera...';
    });
    await setupCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.eventTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: isReady && controller != null
                ? CameraPreview(controller!)
                : Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Text(
                status,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 220,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent, width: 3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 110,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.55),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: switchCamera,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.cameraswitch_outlined),
                    label: const Text('Switch'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isReady
                        ? () async {
                      final image =
                      await controller!.takePicture();

                      if (!mounted) return;

                      Navigator.pop(
                        context,
                        image.path,
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B4F8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.face_retouching_natural),
                    label: const Text('Capture'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}