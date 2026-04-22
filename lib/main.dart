import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String dbUrl = "https://safetyapp-flutte-default-rtdb.europe-west1.firebasedatabase.app";

final Map<String, Map<String, String>> translations = {
  'English': {
    'title': 'Safety Home',
    'secure': 'SYSTEM SECURE',
    'danger': 'DANGER DETECTED',
    'gas': 'Gas',
    'flame': 'Flame', // Changed from temp
    'door1': 'Door 1',
    'door2': 'Door 2',
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
    'connected': 'SYSTEM POWERED ON',
    'disconnected': 'SYSTEM UNPLUGGED/OFF',
    'sector': 'Main Power (Sector)',
    'battery': 'Battery Mode',
  },
  'Arabic': {
    'title': 'منزل السلامة',
    'secure': 'النظام آمن',
    'danger': 'تم اكتشاف خطر',
    'gas': 'غاز',
    'flame': 'لهب', // Changed from temp
    'door1': 'الباب 1',
    'door2': 'الباب 2',
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
    'connected': 'النظام متصل بالطاقة',
    'disconnected': 'النظام مفصول',
    'sector': 'الكهرباء الرئيسية',
    'battery': 'وضع البطارية',
  },
  'French': {
    'title': 'Accueil de Sécurité',
    'secure': 'SYSTÈME SÉCURISÉ',
    'danger': 'DANGER DÉTECTÉ',
    'gas': 'Gaz',
    'flame': 'Flamme', // Changed from temp
    'door1': 'Porte 1',
    'door2': 'Porte 2',
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
    'connected': 'SYSTÈME SOUS TENSION',
    'disconnected': 'SYSTÈME DÉBRANCHÉ',
    'sector': 'Secteur (Prise)',
    'battery': 'Mode Batterie',
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

// --- SCREEN 1: SPLASH ---
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
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
    if (mounted) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SensorDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LanguageSelectionPage()));
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
              decoration: BoxDecoration(color: const Color(0xFF2A6DEE).withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.security_rounded, size: 100, color: Color(0xFF2A6DEE)),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(strokeWidth: 5, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A6DEE))),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 2: LANGUAGE SELECTION ---
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
              Text(translations[tempSelected]!['select_lang']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Text(translations[tempSelected]!['continue']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
          border: Border.all(color: isSelected ? primaryBlue : Colors.grey.shade300, width: 2),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ]),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: primaryBlue),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 3: LOGIN ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';
    if (mounted) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
    await prefs.setString('saved_password', password);
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;
    if (email != "olfa@safety.com") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Denied.")));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await _saveCredentials(email, password);
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SensorDashboard()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = translations[currentLang]!;
    return Directionality(
      textDirection: currentLang == 'Arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Icon(Icons.lock_outline_rounded, size: 80, color: Color(0xFF2A6DEE)),
                const SizedBox(height: 20),
                Text(t['login_title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextField(controller: _emailController, decoration: InputDecoration(labelText: t['email'], border: const OutlineInputBorder())),
                const SizedBox(height: 20),
                TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: t['password'], border: const OutlineInputBorder())),
                const SizedBox(height: 30),
                _loading ? const CircularProgressIndicator() : SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _signIn, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A6DEE)), child: Text(t['login_btn']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 4: DASHBOARD (MAIN SYSTEM) ---
class SensorDashboard extends StatefulWidget {
  const SensorDashboard({super.key});
  @override
  State<SensorDashboard> createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  late final DatabaseReference _dbRef;
  late final DatabaseReference _logRef;
  
  // Track active alerts to prevent double logging.
  final Map<String, bool> _activeAlerts = {'gas': false, 'flame': false, 'door1': false, 'door2': false};
  final Color primaryBlue = const Color(0xFF2A6DEE), statusGreen = const Color(0xFF27AE60), statusRed = const Color(0xFFEB5757);

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "default";
    final baseRef = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbUrl).ref().child('users').child(uid);
    _dbRef = baseRef.child('sensors');
    _logRef = baseRef.child('logs');
  }

  void _processSensorData(Map data) async {
    data.forEach((key, value) {
      if (value is Map) {
        bool isCurrentlyDanger = false;

        // Logic updated for digital statuses
        if (value['status'] != null) {
          isCurrentlyDanger = value['status'] == 'on';
        }

        if (isCurrentlyDanger && _activeAlerts[key] == false) {
          _activeAlerts[key] = true;
          _logRef.push().set({'sensor': key, 'timestamp': ServerValue.timestamp, 'value': value['value'] ?? 'danger'});
          _vibrate();
        } else if (!isCurrentlyDanger && _activeAlerts[key] == true) {
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
      textDirection: currentLang == 'Arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.history, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()))),
          actions: [
            IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LanguageSelectionPage()));
            }),
          ],
          flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2A6DEE), Color(0xFF194CB3)]))),
        ),
        body: Column(
          children: [
            // SYSTEM & POWER STATUS
            StreamBuilder<DatabaseEvent>(
              stream: _dbRef.child('online').onValue,
              builder: (context, snapshot1) {
                final bool isSystemOn = snapshot1.data?.snapshot.value as bool? ?? false;
                
                return StreamBuilder<DatabaseEvent>(
                  stream: _dbRef.child('power').onValue,
                  builder: (context, snapshot2) {
                    String source = "sector";
                    int level = 100;
                    if (snapshot2.hasData && snapshot2.data!.snapshot.value != null) {
                      final pData = Map<dynamic, dynamic>.from(snapshot2.data!.snapshot.value as Map);
                      source = pData['source'] ?? "sector";
                      level = pData['level'] ?? 100;
                    }
                    bool isBattery = source == "battery";
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSystemOn ? Colors.blue.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isSystemOn ? Colors.blue : Colors.red, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isSystemOn ? Icons.power_rounded : Icons.power_off_rounded, size: 20, color: isSystemOn ? Colors.blue : Colors.red),
                          const SizedBox(width: 12),
                          Text(isSystemOn ? t['connected']! : t['disconnected']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSystemOn ? Colors.blue.shade700 : Colors.red.shade700)),
                          if (isBattery) ...[
                            const SizedBox(width: 20),
                            Icon(Icons.battery_alert_rounded, size: 20, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text("$level%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
                          ] else ...[
                            const SizedBox(width: 20),
                            Text(t['sector']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // GLOBAL SAFETY STATUS
            StreamBuilder<DatabaseEvent>(
              stream: _dbRef.onValue,
              builder: (context, snapshot) {
                bool isDanger = false;
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map;
                  
                  isDanger = data.entries.any((entry) {
                    final val = entry.value;
                    if (val is! Map) return false;
                    return val['status'] == 'on';
                  });

                  WidgetsBinding.instance.addPostFrameCallback((_) => _processSensorData(data));
                }
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: isDanger ? statusRed : statusGreen, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: (isDanger ? statusRed : statusGreen).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Column(children: [
                    Icon(isDanger ? Icons.gpp_maybe_rounded : Icons.gpp_good_rounded, color: Colors.white, size: 36),
                    const SizedBox(height: 5),
                    Text(isDanger ? t['danger']! : t['secure']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                );
              },
            ),

            // SENSOR GRID
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: sensorGridCard(t['gas']!, 'gas', Icons.gas_meter_rounded)),
                          const SizedBox(width: 15),
                          Expanded(child: sensorGridCard(t['flame']!, 'flame', Icons.local_fire_department_rounded)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      doorsCombinedCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doorsCombinedCard() {
    var t = translations[currentLang]!;
    return StreamBuilder<DatabaseEvent>(
      stream: _dbRef.onValue,
      builder: (context, snapshot) {
        bool door1Warning = false;
        bool door2Warning = false;
        
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = snapshot.data!.snapshot.value as Map;
          if (data['door1'] is Map) door1Warning = data['door1']['status'] == 'on';
          if (data['door2'] is Map) door2Warning = data['door2']['status'] == 'on';
        }
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: (door1Warning || door2Warning) ? statusRed.withOpacity(0.15) : Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
            border: Border.all(color: (door1Warning || door2Warning) ? statusRed.withOpacity(0.3) : Colors.transparent, width: 2),
          ),
          child: Column(
            children: [
              Text('Doors', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: door1Warning ? statusRed.withOpacity(0.1) : primaryBlue.withOpacity(0.05), shape: BoxShape.circle), child: Icon(Icons.door_sliding_rounded, color: door1Warning ? statusRed : primaryBlue, size: 28)),
                        const SizedBox(height: 8),
                        Text(t['door1']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: door1Warning ? statusRed : statusGreen, borderRadius: BorderRadius.circular(20)),
                          child: Text(door1Warning ? t['open']! : t['closed']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: door2Warning ? statusRed.withOpacity(0.1) : primaryBlue.withOpacity(0.05), shape: BoxShape.circle), child: Icon(Icons.door_sliding_rounded, color: door2Warning ? statusRed : primaryBlue, size: 28)),
                        const SizedBox(height: 8),
                        Text(t['door2']!, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: door2Warning ? statusRed : statusGreen, borderRadius: BorderRadius.circular(20)),
                          child: Text(door2Warning ? t['open']! : t['closed']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget sensorGridCard(String name, String sensorKey, IconData icon) {
    return StreamBuilder<DatabaseEvent>(
      stream: _dbRef.child(sensorKey).onValue,
      builder: (context, snapshot) {
        bool isWarning = false;
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          isWarning = data['status'] == 'on';
        }
        return sensorUI(name, icon, isWarning);
      },
    );
  }

  Widget sensorUI(String name, IconData icon, bool isWarning) {
    var t = translations[currentLang]!;
    
    String pillText;
    if (name == t['door1'] || name == t['door2']) {
      pillText = isWarning ? t['open']! : t['closed']!;
    } else {
      pillText = isWarning ? t['on']! : t['off']!;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: isWarning ? statusRed.withOpacity(0.15) : Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))], border: Border.all(color: isWarning ? statusRed.withOpacity(0.3) : Colors.transparent, width: 2)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isWarning ? statusRed.withOpacity(0.1) : primaryBlue.withOpacity(0.05), shape: BoxShape.circle), child: Icon(icon, color: isWarning ? statusRed : primaryBlue, size: 30)),
        const SizedBox(height: 10),
        Text(name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), 
          decoration: BoxDecoration(color: isWarning ? statusRed : statusGreen, borderRadius: BorderRadius.circular(20)), 
          child: Text(pillText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))
        ),
      ]),
    );
  }
}

// --- SCREEN 5: HISTORY ---
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var t = translations[currentLang]!;
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "default";
    final DatabaseReference logRef = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: dbUrl).ref().child('users').child(uid).child('logs');

    return Directionality(
      textDirection: currentLang == 'Arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['history_title']!),
          centerTitle: true,
          backgroundColor: const Color(0xFF2A6DEE),
          foregroundColor: Colors.white,
          actions: [
            IconButton(icon: const Icon(Icons.delete_sweep_rounded), onPressed: () {
              showDialog(context: context, builder: (c) => AlertDialog(
                title: Text(t['confirm_delete']!),
                content: Text(t['delete_msg']!),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(c), child: Text(t['cancel']!)),
                  TextButton(onPressed: () { logRef.remove(); Navigator.pop(c); }, child: Text(t['delete']!, style: const TextStyle(color: Colors.red))),
                ],
              ));
            }),
          ],
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: logRef.orderByChild('timestamp').onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) return Center(child: Text(t['no_logs']!));
            final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
            final List<Map<dynamic, dynamic>> logs = data.values.map((e) => Map<dynamic, dynamic>.from(e)).toList()..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final date = DateTime.fromMillisecondsSinceEpoch(log['timestamp']);
                String sensorNameKey = log['sensor'] ?? 'unknown';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFFEB5757), child: Icon(Icons.warning, color: Colors.white)),
                    title: Text("${t['danger']}: ${t[sensorNameKey] ?? sensorNameKey}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}"),
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