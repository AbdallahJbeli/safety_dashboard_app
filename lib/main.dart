import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String dbUrl =
    "https://safetyapp-flutte-default-rtdb.europe-west1.firebasedatabase.app";

final Map<String, Map<String, String>> translations = {
  'English': {
    'title': 'Safety Dashboard',
    'secure': 'SYSTEM SECURE',
    'danger': 'DANGER DETECTED',
    'gas': 'Gas',
    'flame': 'Flame',
    'door': 'Door',
    'iron': 'Iron',
    'open': 'OPEN',
    'closed': 'CLOSED',
    'on': 'ON',
    'off': 'OFF',
    'select_lang': 'Select Language',
    'continue': 'CONTINUE',
    'login_title': 'Member Login',
    'email': 'Email Address',
    'password': 'Password',
    'login_btn': 'LOGIN',
    'history_title': 'Incident History',
    'no_logs': 'No incidents recorded.',
    'clear_history': 'Clear History',
    'confirm_delete': 'Are you sure?',
    'delete_msg': 'This will permanently delete all logs.',
    'cancel': 'Cancel',
    'delete': 'Delete',
  },
  'Arabic': {
    'title': 'لوحة تحكم السلامة',
    'secure': 'النظام آمن',
    'danger': 'تم اكتشاف خطر',
    'gas': 'غاز',
    'flame': 'لهب',
    'door': 'الباب',
    'iron': 'مكواة',
    'open': 'مفتوح',
    'closed': 'مغلق',
    'on': 'يعمل',
    'off': 'مطفأ',
    'select_lang': 'اختر اللغة',
    'continue': 'استمرار',
    'login_title': 'تسجيل الدخول',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'login_btn': 'دخول',
    'history_title': 'سجل الحوادث',
    'no_logs': 'لا توجد حوادث مسجلة',
    'clear_history': 'مسح السجل',
    'confirm_delete': 'هل أنت متأكد؟',
    'delete_msg': 'سيتم مسح جميع السجلات نهائياً.',
    'cancel': 'إلغاء',
    'delete': 'حذف',
  },
  'French': {
    'title': 'Tableau de Sécurité',
    'secure': 'SYSTÈME SÉCURISÉ',
    'danger': 'DANGER DÉTECTÉ',
    'gas': 'Gaz',
    'flame': 'Flamme',
    'door': 'Porte',
    'iron': 'Fer à repasser',
    'open': 'OUVERT',
    'closed': 'FERMÉ',
    'on': 'ALLUMÉ',
    'off': 'ÉTEINT',
    'select_lang': 'Choisir la langue',
    'continue': 'CONTINUER',
    'login_title': 'Connexion',
    'email': 'E-mail',
    'password': 'Mot de passe',
    'login_btn': 'SE CONNECTER',
    'history_title': 'Historique des Incidents',
    'no_logs': 'Aucun incident enregistré.',
    'clear_history': 'Effacer l\'historique',
    'confirm_delete': 'Êtes-vous sûr?',
    'delete_msg': 'Cela supprimera définitivement tous les journaux.',
    'cancel': 'Annuler',
    'delete': 'Supprimer',
  },
};

String currentLang = 'English';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
      ),
      home: const LoadingSplashScreen(),
    );
  }
}

class LoadingSplashScreen extends StatefulWidget {
  const LoadingSplashScreen({super.key});
  @override
  State<LoadingSplashScreen> createState() => _LoadingSplashScreenState();
}

class _LoadingSplashScreenState extends State<LoadingSplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  void _startApp() async {
    // Give time for splash animation
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();

    if (mounted) {
      // CHECK AUTH STATE: If user is already logged in, skip to Dashboard
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SensorDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LanguageSelectionPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF2A6DEE).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                size: 100,
                color: Color(0xFF2A6DEE),
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A6DEE)),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});
  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String tempSelected = 'English';
  final Color primaryBlue = const Color(0xFF2A6DEE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.language_rounded, size: 80, color: primaryBlue),
              const SizedBox(height: 20),
              Text(
                translations[tempSelected]!['select_lang']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              languageCard("English", "Welcome", "🇺🇸"),
              languageCard("Arabic", "أهلاً بك", "🇸🇦"),
              languageCard("French", "Bienvenue", "🇫🇷"),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    currentLang = tempSelected;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    translations[tempSelected]!['continue']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageCard(String title, String subtitle, String flag) {
    bool isSelected = tempSelected == title;
    return GestureDetector(
      onTap: () => setState(() => tempSelected = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryBlue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: primaryBlue),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;
    if (email != "olfa@safety.com") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Access Denied.")));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SensorDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = translations[currentLang]!;
    return Directionality(
      textDirection: currentLang == 'Arabic'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: Color(0xFF2A6DEE),
                ),
                const SizedBox(height: 20),
                Text(
                  t['login_title']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: t['email'],
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t['password'],
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                _loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A6DEE),
                          ),
                          child: Text(
                            t['login_btn']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SensorDashboard extends StatefulWidget {
  const SensorDashboard({super.key});
  @override
  State<SensorDashboard> createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  late final DatabaseReference _dbRef;
  late final DatabaseReference _logRef;

  final Map<String, bool> _activeAlerts = {
    'gas': false,
    'flame': false,
    'door': false,
    'iron': false,
  };

  final Color primaryBlue = const Color(0xFF2A6DEE),
      statusGreen = const Color(0xFF27AE60),
      statusRed = const Color(0xFFEB5757);

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "default";
    final baseRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: dbUrl,
    ).ref().child('users').child(uid);
    _dbRef = baseRef.child('sensors');
    _logRef = baseRef.child('logs');
  }

  void _processSensorData(Map data) async {
    data.forEach((key, value) {
      if (value is Map && value['status'] != null) {
        bool isCurrentlyOn = value['status'] == 'on';
        if (isCurrentlyOn && _activeAlerts[key] == false) {
          _activeAlerts[key] = true;
          _logRef.push().set({
            'sensor': key,
            'timestamp': ServerValue.timestamp,
          });
          _vibrate();
        } else if (!isCurrentlyOn && _activeAlerts[key] == true) {
          _activeAlerts[key] = false;
        }
      }
    });
  }

  void _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 800);
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = translations[currentLang]!;
    return Directionality(
      textDirection: currentLang == 'Arabic'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            t['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageSelectionPage(),
                    ),
                  );
                }
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A6DEE), Color(0xFF194CB3)],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            StreamBuilder<DatabaseEvent>(
              stream: _dbRef.onValue,
              builder: (context, snapshot) {
                bool isDanger = false;
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map;
                  isDanger = data.values.any(
                    (v) => v is Map && v['status'] == 'on',
                  );
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _processSensorData(data),
                  );
                }
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDanger ? statusRed : statusGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isDanger ? statusRed : statusGreen).withOpacity(
                          0.4,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isDanger
                            ? Icons.gpp_maybe_rounded
                            : Icons.gpp_good_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isDanger ? t['danger']! : t['secure']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.9,
                children: [
                  sensorGridCard(t['gas']!, 'gas', Icons.gas_meter_rounded),
                  sensorGridCard(
                    t['flame']!,
                    'flame',
                    Icons.local_fire_department_rounded,
                  ),
                  sensorGridCard(
                    t['door']!,
                    'door',
                    Icons.door_sliding_rounded,
                  ),
                  sensorGridCard(t['iron']!, 'iron', Icons.iron_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sensorGridCard(String name, String sensor, IconData icon) {
    return StreamBuilder<DatabaseEvent>(
      stream: _dbRef.child(sensor).onValue,
      builder: (context, snapshot) {
        bool isWarning = false;
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );
          isWarning = data['status'] == 'on';
        }
        return sensorUI(name, icon, isWarning);
      },
    );
  }

  Widget sensorUI(String name, IconData icon, bool isWarning) {
    var t = translations[currentLang]!;
    String displayStatus = (name == t['door'])
        ? (isWarning ? t['open']! : t['closed']!)
        : (isWarning ? t['on']! : t['off']!);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isWarning
                ? statusRed.withOpacity(0.15)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isWarning ? statusRed.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isWarning
                  ? statusRed.withOpacity(0.1)
                  : primaryBlue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isWarning ? statusRed : primaryBlue,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: isWarning ? statusRed : statusGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              displayStatus,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void _showClearConfirmDialog(BuildContext context, DatabaseReference logRef) {
    var t = translations[currentLang]!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(t['confirm_delete']!),
          content: Text(t['delete_msg']!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                t['cancel']!,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                logRef.remove();
                Navigator.pop(context);
              },
              child: Text(
                t['delete']!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = translations[currentLang]!;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "default";
    final DatabaseReference logRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: dbUrl,
    ).ref().child('users').child(uid).child('logs');

    return Directionality(
      textDirection: currentLang == 'Arabic'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['history_title']!),
          centerTitle: true,
          backgroundColor: const Color(0xFF2A6DEE),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: t['clear_history'],
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () => _showClearConfirmDialog(context, logRef),
            ),
          ],
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: logRef.orderByChild('timestamp').onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(
                child: Text(
                  t['no_logs']!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            final data = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map,
            );
            final List<Map<dynamic, dynamic>> logs =
                data.values.map((e) => Map<dynamic, dynamic>.from(e)).toList()
                  ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final date = DateTime.fromMillisecondsSinceEpoch(
                  log['timestamp'],
                );
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEB5757),
                      child: Icon(Icons.warning, color: Colors.white),
                    ),
                    title: Text(
                      "${t['danger']}: ${t[log['sensor']] ?? log['sensor']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
