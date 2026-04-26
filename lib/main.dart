import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HTISmartApp());
}

// ========== COLORS ==========
class AppColors {
  static const Color primary = Color(0xFF0D2B5E);
  static const Color secondary = Color(0xFF1565C0);
  static const Color accent = Color(0xFF42A5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFF5F6FA);
  static const Color darkGrey = Color(0xFF8E9BAD);
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF43A047);
  static const Color orange = Color(0xFFFB8C00);
  static const Color cardBg = Color(0xFFEEF2FF);
}

// ========== APP ==========
class HTISmartApp extends StatelessWidget {
  const HTISmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTI Smart App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ========== SPLASH SCREEN ==========
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (t) {
      setState(() {
        _progress += 0.033;
        if (_progress >= 1.0) {
          _progress = 1.0;
          t.cancel();
          Future.delayed(const Duration(milliseconds: 400), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('HTI',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('HTI Smart App',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
              const SizedBox(height: 8),
              const Text('المعهد التكنولوجي العالي',
                  style: TextStyle(fontSize: 16, color: AppColors.darkGrey)),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        backgroundColor: AppColors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'جاري تحميل البيانات... ${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                          color: AppColors.darkGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== LOGIN SCREEN ==========
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;
  bool _saveLogin = true;
  String? _errorMsg;
  bool _loading = false;

  static const String _correctId = '120221354';
  static const String _correctPassword = '123456';

  void _login() async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_idController.text != _correctId ||
        _passController.text != _correctPassword) {
      setState(() {
        _errorMsg = 'اسم المستخدم أو كلمة المرور خطأ ❌';
        _loading = false;
      });
      return;
    }
    setState(() => _loading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MajorSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Center(
                  child: Text('HTI',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900)),
                          ),
              ),
              const SizedBox(height: 20),
              const Text('تسجيل الدخول',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
              const SizedBox(height: 6),
              const Text('أدخل كود الطالب وكلمة المرور',
                  style: TextStyle(color: AppColors.darkGrey, fontSize: 14)),
              const SizedBox(height: 36),
              TextField(
                controller: _idController,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'كود الطالب (Student ID)',
                  prefixIcon: const Icon(Icons.badge_outlined,
                      color: AppColors.secondary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.secondary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.grey,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: _obscurePass,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور (Password)',
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.secondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.darkGrey),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.secondary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.grey,
                ),
              ),
              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.red.withOpacity(0.4)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.red, size: 18),
                    const SizedBox(width: 8),
                    Text(_errorMsg!,
                        style: const TextStyle(
                            color: AppColors.red, fontSize: 13)),
                  ]),
                ),
              ],
              const SizedBox(height: 14),
              Row(children: [
                Checkbox(
                  value: _saveLogin,
                  activeColor: AppColors.secondary,
                  onChanged: (v) => setState(() => _saveLogin = v ?? true),
                ),
                const Text('حفظ بيانات الدخول (Auto-save)',
                    style: TextStyle(fontSize: 13, color: AppColors.darkGrey)),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('دخول',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.secondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const GuestGuideScreen())),
                icon: const Icon(Icons.explore_outlined,
                    color: AppColors.secondary),
                label: const Text('اكتشف المعهد (دليل المستجدين)',
                    style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('يرجى التواصل مع الدعم: support@hti.edu.eg'),
                    backgroundColor: AppColors.secondary,
                  ));
                },
                icon: const Icon(Icons.support_agent, size: 18),
                label: const Text('تواصل مع الدعم'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== GUEST GUIDE SCREEN ==========
class GuestGuideScreen extends StatelessWidget {
  const GuestGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دليل المستجدين')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المعهد التكنولوجي العالي',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                  Text('Higher Technological Institute - HTI',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 12),
                  Text(
                      'تأسس المعهد عام 1988م بمدينة العاشر من رمضان، '
                      'ويعد أول معهد تكنولوجي خاص في مصر.',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('🏆 إنجازاتنا', [
              'أول معهد تكنولوجي خاص في مصر',
              'معتمد من نقابة المهندسين المصرية',
              'أكثر من 35 عاماً من التميز الأكاديمي',
              'خريجون في كبرى الشركات المصرية والدولية',
            ]),
            const SizedBox(height: 16),
            _buildSection('🎓 الأقسام العلمية', [
              'هندسة معمارية',
              'هندسة كهربية (اتصالات وإلكترونيات)',
              'هندسة مدنية',
              'هندسة ميكانيكية',
              'هندسة طبية حيوية',
              'هندسة كيميائية',
              'إدارة أعمال تكنولوجية',
              'علوم حاسب',
              'ميكاترونكس',
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🌐 الموقع الرسمي',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  SizedBox(height: 6),
                  Text('www.hti.edu.eg',
                      style: TextStyle(color: AppColors.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.grey, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(item,
                          style: const TextStyle(fontSize: 13))),
                ]),
              )),
        ],
      ),
    );
  }
}

// ========== MAJOR SELECTION SCREEN ==========
class MajorSelectionScreen extends StatefulWidget {
  const MajorSelectionScreen({super.key});
  @override
  State<MajorSelectionScreen> createState() => _MajorSelectionScreenState();
}

class _MajorSelectionScreenState extends State<MajorSelectionScreen> {
  int? _selected;

  final List<Map<String, dynamic>> majors = [
    {
      'name': 'طالب إدارة أعمال',
      'icon': Icons.business_center,
      'color': const Color(0xFF4E342E),
      'code': 'biz'
    },
    {
      'name': 'هندسة كهربية',
      'icon': Icons.electric_bolt,
      'color': const Color(0xFFF57F17),
      'code': 'elec'
    },
    {
      'name': 'هندسة مدنية',
      'icon': Icons.foundation,
      'color': const Color(0xFF1B5E20),
      'code': 'civil'
    },
    {
      'name': 'هندسة ميكانيكية',
      'icon': Icons.settings,
      'color': const Color(0xFF0D47A1),
      'code': 'mech'
    },
    {
      'name': 'هندسة طبية',
      'icon': Icons.health_and_safety,
      'color': const Color(0xFFC62828),
      'code': 'bio'
    },
    {
      'name': 'هندسة كيميائية',
      'icon': Icons.science,
      'color': const Color(0xFF00695C),
      'code': 'chem'
    },
    {
      'name': 'إدارة أعمال',
      'icon': Icons.business_center,
      'color': const Color(0xFF4E342E),
      'code': 'biz'
    },
    {
      'name': 'علوم حاسب',
      'icon': Icons.computer,
      'color': const Color(0xFF0277BD),
      'code': 'cs'
    },
    {
      'name': 'ميكاترونكس',
      'icon': Icons.precision_manufacturing,
      'color': const Color(0xFF37474F),
      'code': 'mechatronics'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('اختيار التخصص'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('اختر قسمك الدراسي',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
            const SizedBox(height: 6),
            const Text('سيتم تخصيص التطبيق بالكامل لقسمك',
                style: TextStyle(color: AppColors.darkGrey)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: majors.length,
                itemBuilder: (ctx, i) {
                  final isSelected = _selected == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (majors[i]['color'] as Color).withOpacity(0.15)
                            : AppColors.grey,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? majors[i]['color'] as Color
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (majors[i]['color'] as Color)
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(majors[i]['icon'] as IconData,
                              color: isSelected
                                  ? majors[i]['color'] as Color
                                  : AppColors.darkGrey,
                              size: 32),
                          const SizedBox(height: 8),
                          Text(majors[i]['name'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? majors[i]['color'] as Color
                                    : AppColors.primary,
                              )),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.check_circle,
                                  color: AppColors.green, size: 16),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selected != null
                      ? AppColors.primary
                      : AppColors.darkGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _selected == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DashboardScreen(
                                majorName:
                                    majors[_selected!]['name'] as String,
                                majorCode:
                                    majors[_selected!]['code'] as String,
                              ),
                            ));
                      },
                child: const Text('تأكيد الاختيار',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== DASHBOARD SCREEN ==========
class DashboardScreen extends StatefulWidget {
  final String majorName;
  final String majorCode;
  const DashboardScreen(
      {super.key, required this.majorName, required this.majorCode});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: _currentIndex == 0
          ? _buildHomeBody()
          : _currentIndex == 1
              ? const AIAssistantScreen()
              : _currentIndex == 2
                  ? const MapScreen()
                  : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), label: 'المساعد'),
          BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'الخريطة'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
  Widget _buildHomeBody() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          actions: [
            IconButton(
              icon: Stack(children: [
                const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle)),
                ),
              ]),
              onPressed: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20))),
                builder: (_) => const NotificationsSheet(),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20, bottom: 20, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('صباح الخير، مصطفى 👋',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('قسم: ${widget.majorName}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Text('م',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('مصطفى أحمد محمد',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('ID: ••••••••  |  ${widget.majorName}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 6),
                            Row(children: [
                              _buildBadge('GPA: 3.4', AppColors.green),
                              const SizedBox(width: 8),
                              _buildBadge('نشط ✅', AppColors.accent),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('الخدمات',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    _buildServiceCard(
                        context,
                        '👤',
                        'ملفي الشخصي',
                        AppColors.primary,
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()))),
                    _buildServiceCard(
                        context,
                        '📅',
                        'الجدول الدراسي',
                        const Color(0xFF1565C0),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ScheduleScreen()))),
                    _buildServiceCard(
                        context,
                        '📍',
                        'خريطة المعهد',
                        const Color(0xFF00695C),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MapScreen()))),
                    _buildServiceCard(
                        context,
                        '🎓',
                        'الأقسام العلمية',
                        const Color(0xFF7B1FA2),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const DepartmentsScreen()))),
                    _buildServiceCard(
                        context,
                        '💳',
                        'الكارنيه الإلكتروني',
                        const Color(0xFF2E7D32),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DigitalIDScreen()))),
                    _buildServiceCard(
                        context,
                        '📧',
                        'التواصل مع الإدارة',
                        const Color(0xFF0277BD),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const SupportChatScreen()))),
                    _buildServiceCard(
                        context,
                        '✨',
                        'الأحداث والفعاليات',
                        const Color(0xFFF57F17),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EventsScreen()))),
                    _buildServiceCard(
                        context,
                        '🗞️',
                        'آخر الأخبار',
                        const Color(0xFFC62828),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewsScreen()))),
                    _buildServiceCard(
                        context,
                        '🚨',
                        'الطوارئ',
                        AppColors.red,
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const EmergencyScreen()))),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xFF1A237E),
                        Color(0xFF283593)
                      ]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.smart_toy,
                            color: Colors.white, size: 30),
                        SizedBox(width: 14),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المساعد الذكي AI',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Text('اسألني أي سؤال عن المعهد...',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12)),
                          ],
                        )),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildServiceCard(BuildContext context, String emoji, String label,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                  child: Text(emoji,
                      style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

// ========== NOTIFICATIONS SHEET ==========
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final notifs = [
      {
        'title': 'تنبيه: محاضرة الرياضيات',
        'body': 'بعد 10 دقائق - قاعة A2',
        'time': 'الآن'
      },
      {
        'title': 'إعلان هام',
        'body': 'فتح باب الانسحاب من المقررات',
        'time': 'منذ ساعة'
      },
      {
        'title': 'معرض الفنون التشكيلية',
        'body': 'السبت 2 مايو 2026',
        'time': 'أمس'
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('الإشعارات',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          const SizedBox(height: 16),
          ...notifs.map((n) => ListTile(
                leading: const CircleAvatar(
                    backgroundColor: AppColors.cardBg,
                    child: Icon(Icons.notifications,
                        color: AppColors.secondary)),
                title: Text(n['title']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text(n['body']!,
                    style: const TextStyle(fontSize: 12)),
                trailing: Text(n['time']!,
                    style: const TextStyle(
                        color: AppColors.darkGrey, fontSize: 11)),
              )),
        ],
      ),
    );
  }
}

// ========== AI ASSISTANT SCREEN ==========
class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});
  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _loading = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'bot',
      'text': 'مرحباً! أنا مساعدك الذكي في HTI Smart App 🎓\n'
          'يمكنك سؤالي عن أي شيء يخص المعهد.'
    }
  ];
  final List<String> _suggested = [
    'إيه هو الكود الخاص بي أو الـ ID بتاعي؟',
    'إزاي أقدر أحسب المعدل التراكمي GPA بتاعي؟',
    'إمتحانات آخر السنة هتبدأ إمتى؟',
    'إيه هي خطوات تقديم شكوى ضد دكتور معين؟',
    'أنا مش عارف أدفع المصاريف أونلاين.',
    'فين أقرب معمل حاسب مفتوح دلوقتي؟',
    'أنا حاسس بضيق نفس، في عيادة طبية شغالة؟',
    'إزاي أطبع الكارنيه الإلكتروني بتاعي؟',
    'أيه هي إجراءات الانسحاب من مادة؟',
    'مين الدكتور المسؤول عن مادة الرياضيات؟',
  ];

  String _getAnswer(String q) {
    final ql = q.toLowerCase();
    if (ql.contains('كود') || ql.contains('id'))
      return 'كودك الخاص محفوظ في ملفك الشخصي.\nيمكنك مشاهدته في الكارنيه الإلكتروني.';
    if (ql.contains('gpa') || ql.contains('معدل'))
      return 'لحساب GPA:\n1. اجمع (درجة كل مادة × ساعاتها)\n2. اقسم على إجمالي الساعات\n\nمعدلك الحالي: 3.4';
    if (ql.contains('امتحان') || ql.contains('إمتحان'))
      return 'امتحانات نهاية الترم الثاني تبدأ يونيو 2026.\nتابع الجدول التفصيلي من أيقونة "الجدول الدراسي".';
    if (ql.contains('شكوى'))
      return 'خطوات تقديم شكوى:\n1. اضغط "التواصل مع الإدارة"\n2. اختر سؤال الشكوى الجاهز\n3. اشرح المشكلة بالتفصيل\n4. انتظر الرد خلال 48 ساعة.';
    if (ql.contains('مصاريف') || ql.contains('دفع'))
      return 'لدفع المصاريف:\n• الموقع الرسمي: www.hti.edu.eg\n• أو تواصل مع الإدارة المالية مباشرة.';
    if (ql.contains('معمل') || ql.contains('ستوديو'))
      return 'معامل الحاسب: مبنى C الدور الأول\nمفتوحة 8 ص - 8 م\nستوديوهات التصميم: مبنى D الدور الثاني.';
    if (ql.contains('عيادة') || ql.contains('طبية') || ql.contains('ضيق'))
      return '🏥 العيادة الطبية: مبنى الإدارة - الدور الأرضي\nمواعيد العمل: 9 ص - 4 م\n\nللطوارئ اضغط أيقونة 🚨 فوراً!';
    if (ql.contains('كارنيه') || ql.contains('طبع'))
      return 'لعرض الكارنيه:\n1. اضغط أيقونة 💳 في الرئيسية\n2. سيظهر QR Code يمكن استخدامه في البوابات والمكتبة.';
    if (ql.contains('انسحاب'))
      return 'إجراءات الانسحاب:\n1. شؤون الطلاب مباشرة\n2. أو من الموقع الرسمي خلال الفترة المحددة.\n\n⚠️ باب الانسحاب مفتوح حالياً للترم الثاني 2025/2026.';
    if (ql.contains('رياضيات'))
      return 'للاطلاع على أعضاء هيئة التدريس، زر صفحة قسمك في "الأقسام العلمية" أو تواصل مع الإدارة الأكاديمية.';
    if (ql.contains('قاعة') || ql.contains('a2'))
      return 'قاعة A2: مبنى A الدور الأول 📍\nاضغط "خريطة المعهد" لبدء التوجيه إليها مباشرةً.';
    return 'شكراً لسؤالك!\n• راجع أقسام التطبيق المختلفة\n• أو تواصل مع الإدارة مباشرةً\n• أو زر www.hti.edu.eg';
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _loading = true;
      _msgCtrl.clear();
    });
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _messages.add({'sender': 'bot', 'text': _getAnswer(text)});
      _loading = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(children: [
          Icon(Icons.smart_toy, size: 22),
          SizedBox(width: 8),
          Text('المساعد الذكي AI'),
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (_loading && i == _messages.length) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.secondary)),
                            SizedBox(width: 8),
                            Text('المساعد يكتب...',
                                style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 12)),
                          ]),
                    ),
                  );
                }
                final msg = _messages[i];
                final isBot = msg['sender'] == 'bot';
                return Align(
                  alignment: isBot
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(ctx).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: isBot
                          ? AppColors.white
                          : AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isBot
                            ? Radius.zero
                            : const Radius.circular(16),
                        bottomRight: isBot
                            ? const Radius.circular(16)
                            : Radius.zero,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(msg['text'] as String,
                        style: TextStyle(
                            color: isBot
                                ? AppColors.primary
                                : Colors.white,
                            fontSize: 13,
                            height: 1.5)),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              itemCount: _suggested.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => _sendMessage(_suggested[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.secondary.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(_suggested[i],
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: InputDecoration(
                      hintText: 'اكتب سؤالك هنا...',
                      hintStyle:
                          const TextStyle(color: AppColors.darkGrey),
                      filled: true,
                      fillColor: AppColors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(_msgCtrl.text),
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

// ========== MAP SCREEN ==========
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buildings = [
      {
        'name': 'مبنى A - قاعات المحاضرات',
        'desc': 'القاعات A1-A12، الدور الأرضي والأول',
        'icon': '🏛️'
      },
      {
        'name': 'مبنى B - المعامل',
        'desc': 'معامل الكيمياء والفيزياء والأحياء',
        'icon': '🔬'
      },
      {
        'name': 'مبنى C - معامل الحاسب',
        'desc': 'معامل الحاسب الآلي، الدور الأول',
        'icon': '💻'
      },
      {
        'name': 'مبنى D - الاستوديوهات',
        'desc': 'ستوديوهات التصميم المعماري',
        'icon': '🎨'
      },
      {
        'name': 'مبنى الإدارة',
        'desc': 'شؤون الطلاب، العيادة الطبية، الأمن',
        'icon': '🏢'
      },
      {
        'name': 'المكتبة',
        'desc': 'مكتبة المعهد - الدور الثاني مبنى A',
        'icon': '📚'
      },
      {
        'name': 'الكافتيريا',
        'desc': 'الدور الأرضي المبنى الرئيسي',
        'icon': '☕'
      },
      {
        'name': 'ملاعب الرياضة',
        'desc': 'الملعب الخارجي وقاعة الألعاب',
        'icon': '⚽'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('خريطة المعهد 3D')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                ...List.generate(6,
                    (i) => Positioned(
                          left: 20.0 + (i % 3) * 80,
                          top: 20.0 + (i ~/ 3) * 80,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(0.15 + i * 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.white30)),
                            child: Center(
                                child: Text(
                                    buildings[i]['icon'] as String,
                                    style:
                                        const TextStyle(fontSize: 22))),
                          ),
                        )),
                const Positioned(
                  bottom: 12,
                  right: 16,
                  child: Text(
                    'خريطة تفاعلية ثلاثية الأبعاد\nاضغط على أي مبنى للتفاصيل',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 4)
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.my_location, color: Colors.white),
              label: const Text('تحديد موقعي الحالي',
                  style: TextStyle(color: Colors.white)),
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                      content:
                          Text('📍 أنت في: مبنى A - الدور الأرضي'),
                      backgroundColor: AppColors.green)),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: buildings.length,
              itemBuilder: (ctx, i) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ]),
                child: Row(
                  children: [
                    Text(buildings[i]['icon'] as String,
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(buildings[i]['name'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                                Text(buildings[i]['desc'] as String,
                            style: const TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 12)),
                      ],
                    )),
                    IconButton(
                      icon: const Icon(Icons.navigation_outlined,
                          color: AppColors.secondary),
                      onPressed: () =>
                          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                              content: Text(
                                  '🧭 جاري التوجيه إلى ${buildings[i]['name']}'),
                              backgroundColor: AppColors.secondary)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== PROFILE SCREEN ==========
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: AppBar(title: const Text('ملفي الشخصي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white30,
                      child: Text('م',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold))),
                  SizedBox(height: 12),
                  Text('مصطفى أحمد محمد',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text('طالب إدارة أعمال',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard('البيانات الأكاديمية', [
              {'label': 'كود الطالب', 'value': '••••••••'},
              {'label': 'المعدل التراكمي GPA', 'value': '3.4 / 4.0'},
              {'label': 'التخصص', 'value': 'إدارة أعمال'},
              {'label': 'المستوى الدراسي', 'value': 'الفرقة الرابعة'},
              {'label': 'حالة القيد', 'value': 'نشط ✅'},
            ]),
            const SizedBox(height: 12),
            _buildInfoCard('المسار الأكاديمي', [
              {'label': 'إجمالي الساعات المعتمدة', 'value': '98 ساعة'},
              {'label': 'الساعات المتبقية', 'value': '42 ساعة'},
              {'label': 'المواد المنتهية', 'value': '24 مادة'},
              {'label': 'المواد الحالية', 'value': '6 مواد'},
            ]),
            const SizedBox(height: 12),
            _buildInfoCard('التدريب', [
              {'label': 'تسجيل التدريب', 'value': 'مكتمل ✅'},
              {'label': 'انتهاء تدريب أ', 'value': 'يوليو 2024'},
              {'label': 'انتهاء تدريب ب', 'value': 'لم يبدأ بعد'},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Map<String, String>> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primary)),
          const Divider(height: 20),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['label']!,
                        style: const TextStyle(
                            color: AppColors.darkGrey, fontSize: 13)),
                    Text(item['value']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.primary)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ========== SCHEDULE SCREEN ==========
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
    final schedule = [
      {
        'day': 'الأحد',
        'subject': 'مبادئ الإدارة',
        'dr': 'د. أحمد محمود',
        'room': 'A2',
        'time': '9:00 - 11:00',
        'group': 'مجموعة 1'
      },
      {
        'day': 'الأحد',
        'subject': 'إدارة التسويق',
        'dr': 'أ.م.د. محمد رجب',
        'room': 'B3',
        'time': '11:00 - 1:00',
        'group': 'مجموعة 1'
      },
      {
        'day': 'الاثنين',
        'subject': 'اقتصاديات الأعمال',
        'dr': 'د. سمير علي',
        'room': 'A1',
        'time': '9:00 - 11:00',
        'group': 'مجموعة 2'
      },
      {
        'day': 'الثلاثاء',
        'subject': 'نظم المعلومات الإدارية',
        'dr': 'د. باسم قنديل',
        'room': 'C2',
        'time': '10:00 - 12:00',
        'group': 'مجموعة 1'
      },
      {
        'day': 'الأربعاء',
        'subject': 'إدارة الموارد البشرية',
        'dr': 'أ.م.د. سحر رمضان',
        'room': 'A5',
        'time': '9:00 - 1:00',
        'group': 'كل المجموعات'
      },
      {
        'day': 'الخميس',
        'subject': 'المحاسبة الإدارية',
        'dr': 'د. محمد السباعي',
        'room': 'B2',
        'time': '10:00 - 12:00',
        'group': 'مجموعة 1'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الجدول الدراسي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: AppColors.orange.withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.warning_amber,
                      color: AppColors.orange, size: 18),
                  SizedBox(width: 6),
                  Text('مواعيد قادمة',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange)),
                          ]),
                SizedBox(height: 8),
                Text('• تسليم مشروع الإدارة: 1 مايو 2026',
                    style: TextStyle(fontSize: 12)),
                Text('• كويز اقتصاديات: 28 أبريل 2026',
                    style: TextStyle(fontSize: 12)),
                Text('• امتحانات نهائية: يونيو 2026',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...days.map((day) {
            final dayL =
                schedule.where((s) => s['day'] == day).toList();
            if (dayL.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(day,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                ...dayL.map((l) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2))
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l['subject']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.accent
                                        .withOpacity(0.15),
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                child: Text(l['time']!,
                                    style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 11)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.person_outline,
                                size: 14, color: AppColors.darkGrey),
                            const SizedBox(width: 4),
                            Text(l['dr']!,
                                style: const TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 12)),
                                    ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.room_outlined,
                                size: 14, color: AppColors.darkGrey),
                            const SizedBox(width: 4),
                            Text(
                                'قاعة ${l['room']}  |  ${l['group']}',
                                style: const TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 12)),
                          ]),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
              ],
            );
          }),
        ]),
      ),
    );
  }
}

// ========== DIGITAL ID SCREEN ==========
class DigitalIDScreen extends StatelessWidget {
  const DigitalIDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الكارنيه الإلكتروني')),
      backgroundColor: AppColors.grey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF1565C0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8))
                    ]),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('HTI',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Text('المعهد التكنولوجي العالي',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Text('نشط',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white30,
                        child: Text('م',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold))),
                    const SizedBox(height: 12),
                    const Text('مصطفى أحمد محمد',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('إدارة أعمال - الفرقة الرابعة',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8),
                        itemCount: 64,
                        itemBuilder: (_, i) => Container(
                          margin: const EdgeInsets.all(1),
                          color: (i * 37 + i * 13) % 3 == 0
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('ID: ••••••••',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 2)),
                    const SizedBox(height: 4),
                    const Text('صالح حتى: يونيو 2026',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                    child: _usageCard('🏛️', 'دخول البوابات', 'QR Code')),
                const SizedBox(width: 12),
                Expanded(
                    child:
                        _usageCard('📚', 'استعارة الكتب', 'المكتبة')),
                const SizedBox(width: 12),
                Expanded(
                    child: _usageCard(
                        '📝', 'اللجان', 'إثبات الشخصية')),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usageCard(String emoji, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ]),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: AppColors.primary)),
        Text(sub,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.darkGrey, fontSize: 10)),
      ]),
    );
  }
}

// ========== SUPPORT CHAT SCREEN ==========
class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}
class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'admin',
      'text':
          'مرحباً! كيف يمكننا مساعدتك؟ اختر سؤالاً جاهزاً أو اكتب استفسارك.',
      'time': 'الآن'
    }
  ];

  final List<String> quickQ = [
    '1️⃣ أنا طالب في الفرقة الأخيرة وأرغب في الاستفسار عن إجراءات التخرج.',
    '2️⃣ أواجه مشكلة في موقع التسجيل ولا أستطيع إتمام العملية.',
    '3️⃣ أود تقديم شكوى بخصوص أحد الدكاترة بسبب مشكلة في التقييم.',
    '4️⃣ أرجو الإفادة بمواعيد الامتحانات أو أي تحديثات جديدة.',
    '5️⃣ لدي استفسار بخصوص المصروفات والإجراءات الإدارية.',
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text, 'time': 'الآن'});
      _msgCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add({
          'sender': 'admin',
          'text': 'تم استلام طلبكم وجاري مراجعته.',
          'time': 'الآن',
          'status': 'Submitted',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white30,
              child: Icon(Icons.support_agent,
                  size: 16, color: Colors.white)),
          SizedBox(width: 10),
          Text('التواصل مع الإدارة'),
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (ctx, i) {
              final msg = _messages[i];
              final isUser = msg['sender'] == 'user';
              return Align(
                alignment: isUser
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(ctx).size.width * 0.78),
                  decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.secondary
                          : AppColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser
                              ? Radius.zero
                              : const Radius.circular(16),
                          bottomRight: isUser
                              ? const Radius.circular(16)
                              : Radius.zero),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(msg['text'] as String,
                          style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 13,
                              height: 1.5)),
                      if (msg['status'] != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color:
                                  AppColors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                              '📋 الحالة: ${msg['status']}',
                              style: const TextStyle(
                                  color: AppColors.orange,
                                  fontSize: 11)),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: AppColors.grey,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: quickQ.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => _send(quickQ[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              AppColors.secondary.withOpacity(0.3))),
                  alignment: Alignment.center,
                  child: Text(
                      quickQ[i].length > 30
                          ? '${quickQ[i].substring(0, 30)}...'
                          : quickQ[i],
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.secondary)),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                decoration: InputDecoration(
                  hintText: 'اكتب استفسارك أو شكواك...',
                  hintStyle:
                      const TextStyle(color: AppColors.darkGrey),
                  filled: true,
                  fillColor: AppColors.grey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                onSubmitted: _send,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send,
                    color: Colors.white, size: 18),
                onPressed: () => _send(_msgCtrl.text),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ========== EVENTS SCREEN ==========
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': 'معرض الفنون التشكيلية',
        'date': 'السبت 2 مايو 2026',
        'location': 'صالة مبنى الإدارة',
        'icon': '🎨',
        'color': const Color(0xFF7B1FA2),
        'desc': 'معرض يضم أعمال فنية متنوعة: رسم، تصوير، نحت.'
      },
      {
        'title': 'الإفطار الجماعي السنوي',
        'date': 'السبت 7 مارس 2026',
        'location': 'القاعة الكبرى',
        'icon': '🌙',
        'color': const Color(0xFFF57F17),
        'desc': 'فعالية لتعزيز الروابط بين الطلاب والقيادات.'
      },
      {
        'title': 'مؤتمر علوم الحاسب الثالث',
        'date': 'الاثنين 15 مايو 2026',
        'location': 'قاعة المؤتمرات',
        'icon': '💻',
        'color': const Color(0xFF0277BD),
        'desc': 'المؤتمر العلمي الثالث لقسم علوم الحاسب.'
      },
      {
        'title': 'مسابقة فورمولا الطلابية',
        'date': 'الجمعة 10 يونيو 2026',
        'location': 'ملعب المعهد',
        'icon': '🏎️',
        'color': const Color(0xFFC62828),
        'desc': 'مسابقة السيارات الطلابية لقسم الميكانيكا.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الأحداث والفعاليات ✨')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (ctx, i) {
          final e = events[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: (e['color'] as Color).withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18))),
                child: Row(children: [
                  Text(e['icon'] as String,
                      style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['title'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: e['color'] as Color)),
                      Text(e['date'] as String,
                          style: const TextStyle(
                              color: AppColors.darkGrey, fontSize: 12)),
                    ],
                  )),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.darkGrey),
                      const SizedBox(width: 4),
                      Text(e['location'] as String,
                          style: const TextStyle(
                              color: AppColors.darkGrey, fontSize: 12)),
                    ]),
                    const SizedBox(height: 8),
                    Text(e['desc'] as String,
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: e['color'] as Color,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10))),
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text(
                                    '✅ تم حجز مقعدك في ${e['title']}'),
                                backgroundColor: AppColors.green)),
                        child: const Text('Book Your Spot 🎟️',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}

// ========== NEWS SCREEN ==========
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final news = [
      {
        'title': 'فتح باب الانسحاب من المقررات',
        'icon': '📢',
        'date': '23 أبريل 2026',
        'tag': 'عاجل',
        'tagColor': AppColors.red,
        'body': 'فتح باب الانسحاب للفصل الثاني 2025/2026 عبر الموقع الرسمي. '
            'يُرجى إتمام الإجراءات قبل نهاية الأسبوع.'
      },
      {
        'title': 'معرض الفنون التشكيلية',
        'icon': '🎨',
        'date': '20 أبريل 2026',
        'tag': 'فعالية',
        'tagColor': const Color(0xFF7B1FA2),
        'body': 'يُقام يوم السبت 2 مايو 2026 بصالة مبنى الإدارة، '
            'معرضاً للفنون يشمل أعمال الرسم والتصوير والنحت.'
      },
      {
        'title': 'الإفطار الجماعي السنوي',
        'icon': '🌙',
        'date': '7 مارس 2026',
        'tag': 'أخبار',
        'tagColor': AppColors.secondary,
        'body': 'نظّم المعهد إفطاره الجماعي السنوي لتعزيز الروابط '
            'بين الطلاب والقيادات الأكاديمية.'
      },
      {
        'title': 'المؤتمر العلمي الثالث لعلوم الحاسب',
        'icon': '🎓',
        'date': '15 أبريل 2026',
        'tag': 'أكاديمي',
        'tagColor': AppColors.green,
        'body': 'سيُعقد المؤتمر العلمي الثالث في مايو 2026 '
            'بمشاركة نخبة من الباحثين والأساتذة المتخصصين.'
      },
      {
        'title': 'اعتماد برنامج الهندسة الكهربية',
        'icon': '🏆',
        'date': '10 أبريل 2026',
        'tag': 'إنجاز',
        'tagColor': AppColors.orange,
        'body': 'حصل قسم الهندسة الكهربية على اعتماد رسمي جديد '
            'من نقابة المهندسين المصرية لشعبة الاتصالات.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('آخر الأخبار 🗞️')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: news.length,
        itemBuilder: (ctx, i) {
          final n = news[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(n['icon'] as String,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(n['title'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primary))),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color:
                            (n['tagColor'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(n['tag'] as String,
                        style: TextStyle(
                            color: n['tagColor'] as Color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ]),
                const SizedBox(height: 10),
                Text(n['body'] as String,
                    style: const TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 12,
                        height: 1.5)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(n['date'] as String,
                        style: const TextStyle(
                            color: AppColors.darkGrey, fontSize: 11)),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero),
                      child: const Text('اقرأ المزيد',
                          style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ========== EMERGENCY SCREEN ==========
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('🚨 الطوارئ'),
          backgroundColor: AppColors.red),
      backgroundColor: AppColors.grey,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.red.withOpacity(0.3))),
              child: const Row(children: [
                Icon(Icons.warning, color: AppColors.red, size: 20),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                  'في حالة الخطر الشديد، اضغط على القسم المناسب فوراً',
                  style:
                      TextStyle(color: AppColors.red, fontSize: 13),
                )),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('اختر نوع الطوارئ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
            const SizedBox(height: 16),
            Expanded(
              child: Column(children: [
                _emergCard(
                    context,
                    '🏥',
                    'العيادة الطبية',
                    'Medical Clinic',
                    'للحالات الطبية والإسعاف',
                    const Color(0xFFE53935),
                    'medical'),
                const SizedBox(height: 14),
                _emergCard(
                    context,
                    '🛡️',
                    'الأمن',
                    'Security',
                    'للبلاغات والتنبيهات الأمنية',
                    const Color(0xFF1565C0),
                    'security'),
                const SizedBox(height: 14),
                _emergCard(
                    context,
                    '📧',
                    'إرسال رسالة للإدارة',
                    'Message Admin',
                    'للتواصل الرسمي العاجل',
                    const Color(0xFF2E7D32),
                    'admin'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergCard(BuildContext ctx, String emoji, String title,
      String sub, String desc, Color color, String type) {
    return GestureDetector(
      onTap: () => Navigator.push(ctx,
          MaterialPageRoute(
              builder: (_) => EmergencyChatScreen(type: type))),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: color.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ]),
        child: Row(children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Text(emoji,
                    style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color)),
              Text(sub,
                  style: const TextStyle(
                      color: AppColors.darkGrey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.primary)),
            ],
          )),
          Icon(Icons.arrow_forward_ios, color: color, size: 18),
        ]),
      ),
    );
  }
}

// ========== EMERGENCY CHAT SCREEN ==========
class EmergencyChatScreen extends StatefulWidget {
  final String type;
  const EmergencyChatScreen({super.key, required this.type});
  @override
  State<EmergencyChatScreen> createState() =>
      _EmergencyChatScreenState();
}

class _EmergencyChatScreenState extends State<EmergencyChatScreen> {
  final TextEditingController _locCtrl = TextEditingController();
  bool _sent = false;
  String? _selected;

  List<String> get _questions {
    if (widget.type == 'medical')
      return [
        'هل توجد حالة طوارئ؟ (نعم، طالب في حالة حرجة)',
        'نوع الحالة: إغماء / ضيق تنفس',
        'طلب طبيب فوراً للموقع',
        'تحديد الموقع بدقة داخل المعهد',
        'طلب مساعدة طبية عاجلة',
      ];
    if (widget.type == 'security')
      return [
        'تنبيه أمني: يوجد خطر في الموقع',
        'التبليغ عن شخص يُشتبه بحمله سلاح',
        'التبليغ عن شخص غريب (تسلل)',
        'طلب تدخل أمني فوري وتحديد الموقع',
      ];
    return [
      'لدي حالة طارئة تتطلب تدخل إداري عاجل',
      'أحتاج مساعدة فورية من الإدارة',
      'طلب تواصل مع مسؤول أكاديمي',
    ];
  }

  String get _title {
    if (widget.type == 'medical') return '🏥 العيادة الطبية';
    if (widget.type == 'security') return '🛡️ الأمن';
    return '📧 الإدارة';
  }
  Color get _color {
    if (widget.type == 'medical') return AppColors.red;
    if (widget.type == 'security') return AppColors.secondary;
    return AppColors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title), backgroundColor: _color),
      body: _sent ? _successView() : _formView(),
    );
  }

  Widget _formView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: _color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: _color.withOpacity(0.3))),
            child: Text(
                'اختر نوع البلاغ أو حدد موقعك وتفاصيل الحالة',
                style: TextStyle(
                    color: _color, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 20),
          const Text('الأسئلة الجاهزة:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          const SizedBox(height: 12),
          ..._questions.map((q) => GestureDetector(
                onTap: () => setState(() => _selected = q),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: _selected == q
                          ? _color.withOpacity(0.1)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _selected == q
                              ? _color
                              : Colors.grey.shade200,
                          width: _selected == q ? 2 : 1)),
                  child: Row(children: [
                    Icon(
                        _selected == q
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _selected == q
                            ? _color
                            : AppColors.darkGrey,
                        size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(q,
                            style: TextStyle(
                                fontSize: 13,
                                color: _selected == q
                                    ? _color
                                    : AppColors.primary))),
                  ]),
                ),
              )),
          const SizedBox(height: 16),
          TextField(
            controller: _locCtrl,
            decoration: InputDecoration(
              labelText: 'تحديد موقعك (مبنى / قاعة / دور)',
              prefixIcon: const Icon(Icons.location_on,
                  color: AppColors.red),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: _color, width: 2)),
              filled: true,
              fillColor: AppColors.grey,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              onPressed: () => setState(() => _sent = true),
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('إرسال البلاغ الآن',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _successView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: _color.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: Icon(Icons.check_circle, color: _color, size: 60),
            ),
            const SizedBox(height: 20),
            Text('تم إرسال البلاغ!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _color)),
            const SizedBox(height: 12),
            const Text(
              'تم استلام بلاغك وجاري التواصل معك فوراً.\nيُرجى البقاء في مكانك.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.darkGrey, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(14)),
              child: const Column(children: [
                Row(children: [
                  Icon(Icons.access_time,
                      size: 16, color: AppColors.orange),
                  SizedBox(width: 6),
                  Text('وقت الاستجابة المتوقع: 3-5 دقائق',
                      style: TextStyle(fontSize: 13)),
                ]),
                SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.info_outline,
                      size: 16, color: AppColors.secondary),
                  SizedBox(width: 6),
                  Text('رقم البلاغ: #HTI-2026-0423',
                      style: TextStyle(fontSize: 13)),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('العودة للرئيسية',
                  style: TextStyle(color: AppColors.secondary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== DEPARTMENTS SCREEN ==========
class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = [
      {
        'name': 'الهندسة المعمارية',
        'icon': Icons.architecture,
        'color': const Color(0xFF7B1FA2),
        'code': 'arch'
      },
      {
        'name': 'الهندسة الكهربية',
        'icon': Icons.electric_bolt,
        'color': const Color(0xFFF57F17),
        'code': 'elec'
      },
      {
        'name': 'الهندسة المدنية',
        'icon': Icons.foundation,
        'color': const Color(0xFF1B5E20),
        'code': 'civil'
      },
      {
        'name': 'الهندسة الميكانيكية',
        'icon': Icons.settings,
        'color': const Color(0xFF0D47A1),
        'code': 'mech'
      },
      {
        'name': 'الهندسة الطبية',
        'icon': Icons.health_and_safety,
        'color': const Color(0xFFC62828),
        'code': 'bio'
      },
      {
        'name': 'الهندسة الكيميائية',
        'icon': Icons.science,
        'color': const Color(0xFF00695C),
        'code': 'chem'
      },
      {
        'name': 'إدارة الأعمال',
        'icon': Icons.business_center,
        'color': const Color(0xFF4E342E),
        'code': 'biz'
      },
      {
        'name': 'علوم الحاسب',
        'icon': Icons.computer,
        'color': const Color(0xFF0277BD),
        'code': 'cs'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الأقسام العلمية 🎓')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1),
        itemCount: deps.length,
        itemBuilder: (ctx, i) {
          final d = deps[i];
          return GestureDetector(
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => DepartmentDetailScreen(
                          name: d['name'] as String,
                          code: d['code'] as String,
                          color: d['color'] as Color,
                          icon: d['icon'] as IconData,
                        ))),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color:
                            (d['color'] as Color).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                        color: (d['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16)),
                    child: Icon(d['icon'] as IconData,
                        color: d['color'] as Color, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(d['name'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.primary)),
                  const SizedBox(height: 6),
                  Icon(Icons.arrow_forward_ios,
                      size: 12,
                      color:
                          (d['color'] as Color).withOpacity(0.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ========== DEPARTMENT DETAIL SCREEN ==========
class DepartmentDetailScreen extends StatelessWidget {
  final String name, code;
  final Color color;
  final IconData icon;
  const DepartmentDetailScreen(
      {super.key,
      required this.name,
      required this.code,
      required this.color,
      required this.icon});

  Map<String, dynamic> get _data {
    switch (code) {
      case 'arch':
        return {
          'about':
              'يسعى برنامج الهندسة المعمارية إلى إعداد خريجين متميزين '
                  'مبدعين على مستوى عالٍ من التأهيل العلمي والتدريب العملي، '
                  'يمتلكون القدرة على التصميم المبتكر وحل المشكلات والتفكير النقدي '
                  'مع مراعاة الأبعاد البيئية والثقافية والتكنولوجية المختلفة.',
          'goals': [
            'ربط الأسس النظرية بالمهارات التطبيقية',
            'تعزيز البحث العلمي والابتكار',
            'توفير بيئة تعليمية محفزة للتعلم الإبداعي',
            'دعم قيم المسؤولية المجتمعية'
          ],
          'jobs': [
            'مكاتب التصميم والاستشارات',
            'شركات المقاولات والتنفيذ',
            'الهيئات الحكومية والبلديات',
            'العمل الأكاديمي'
          ],
          'professors': [
            'أ.م.د. محمد رجب عبده - رئيس القسم',
            'أ.م.د. سحر عز العرب رمضان - أستاذ مساعد',
            'د.م. محمد نبيل عبد الصادق السباعي',
            'د.م. باسم محمد السيد قنديل'
          ],
        };
      case 'elec':
        return {
          'about':
              'تأسس قسم الهندسة الكهربية عام 1988م. يهدف إلى إعداد خريج '
                  'متميز قادر على الإبداع والابتكار وإكسابه المهارات لمواكبة '
                  'التطور التكنولوجي.',
          'goals': [
            'تطبيق مفاهيم الرياضيات والعلوم الهندسية',
            'التطوير المستمر للمقررات الدراسية',
            'اكتساب مهارة العمل بكفاءة',
            'تنمية قدرات أعضاء هيئة التدريس'
          ],
          'jobs': [
            'مهندس اتصالات',
            'مهندس إلكترونيات',
            'مهندس نظم شبكات',
            'مبرمج نظم الاتصالات',
            'مهندس الأنظمة المدمجة'
          ],
          'professors': [
            'رئيس قسم الهندسة الكهربية',
            'أعضاء هيئة التدريس المتخصصون'
          ],
        };
      case 'civil':
        return {
          'about':
              'قسم الهندسة المدنية تخصص يتعامل مع تصميم وإنشاء وصيانة '
                  'البيئة المادية، يشمل الطرق والجسور والسدود والمطارات '
                  'وأنظمة الصرف الصحي.',
          'goals': [
            'الهندسة الإنشائية وتحليل الهياكل',
            'إدارة مشاريع البناء',
            'هندسة التربة والأساسات',
            'الهيدروليكا والموارد المائية'
          ],
          'jobs': [
            'مديري مشاريع الإنشاء',
            'الشركات الاستشارية',
            'القطاع الحكومي والأشغال العامة',
            'تطوير العقارات'
          ],
          'professors': [
            'أعضاء هيئة التدريس المتخصصون في الهندسة المدنية'
          ],
        };
      case 'mech':
        return {
          'about':
              'قسم الهندسة الميكانيكية من أعرق التخصصات الهندسية، '
                  'يُعنى بتطبيق مبادئ الفيزياء والرياضيات لتصميم وتحليل '
                  'وتصنيع الأنظمة الميكانيكية والحرارية.',
          'goals': [
            'تصميم الآلات والأنظمة الميكانيكية',
            'هندسة المواد والتصنيع',
            'الهندسة الحرارية والطاقة',
            'التحكم والأنظمة الذكية'
          ],
          'jobs': [
            'الصناعات التحويلية والإنتاجية',
            'شركات الطاقة والبترول والغاز',
            'قطاع النقل والطيران والسكك الحديدية',
            'مؤسسات البحث والتطوير'
          ],
          'professors': [
            'نخبة من أعضاء هيئة التدريس ذوي الكفاءة العالية'
          ],
        };
      case 'bio':
        return {
          'about':
              'قسم الهندسة الطبية الحيوية يدمج بين مبادئ الهندسة والطب '
                  'والأحياء لتطوير حلول مبتكرة للرعاية الصحية.',
          'goals': [
            'تطوير الأجهزة الطبية',
            'الميكانيكا الحيوية',
            'التصوير الطبي الحيوي',
            'أجهزة الاستشعار والتشخيص'
          ],
          'jobs': [
            'صناعة الأجهزة الطبية',
            'البحث والتطوير',
            'المستشفيات ومؤسسات الرعاية الصحية',
            'الشؤون التنظيمية'
          ],
          'professors': [
            'أعضاء هيئة التدريس المتخصصون في الهندسة الطبية'
          ],
        };
      case 'chem':
        return {
          'about':
              'رسالة البرنامج: إعداد كوادر مؤهلة علمياً ومهنياً لمواكبة '
                  'متطلبات سوق العمل محلياً وإقليمياً وعالمياً من خلال بيئة '
                  'تكنولوجية وأداء تعليمي وبحثي متكامل.',
                  'goals': [
            'التطوير المستمر وفق المعايير الأكاديمية',
            'إعداد خريج قادر على التعلم الذاتي',
            'تفعيل المشاركة المجتمعية',
            'الاهتمام بالبحث العلمي'
          ],
          'jobs': [
            'صناعة البتروكيماويات',
            'صناعة الأدوية',
            'معالجة المياه والبيئة',
            'الصناعات الغذائية'
          ],
          'professors': [
            'مها حسن أحمد عبد الكريم - أستاذ دكتور',
            'سعاد عبد العزيز المتولى عوض - أستاذ مساعد'
          ],
        };
      case 'biz':
        return {
          'about':
              'قسم إدارة الأعمال التكنولوجية يهدف إلى إعداد كوادر متميزة '
                  'في الإدارة الحديثة والتقنية والمحاسبة والتسويق ونظم المعلومات.',
          'goals': [
            'المحاسبة والمراجعة المالية',
            'التسويق الحديث وبحوث السوق',
            'نظم معلومات الأعمال',
            'الاقتصاد وإدارة الأعمال'
          ],
          'jobs': [
            'محاسب ومراجع مالي',
            'مدير تسويق',
            'محلل نظم معلومات',
            'مستشار إداري'
          ],
          'professors': [
            'أعضاء هيئة التدريس المتخصصون في إدارة الأعمال'
          ],
        };
      case 'cs':
        return {
          'about':
              'قسم علوم الحاسب يهدف لتزويد الطلاب بالمعرفة والمهارات '
                  'لفهم تصميم الخوارزميات وبناء الأنظمة وتحليل البيانات، '
                  'مع التركيز على الابتكار والتطوير التكنولوجي.',
          'goals': [
            'برمجة الحاسوب وتطوير التطبيقات',
            'الخوارزميات وهياكل البيانات',
            'قواعد البيانات والبيانات الضخمة',
            'الذكاء الاصطناعي والتعلم الآلي'
          ],
          'jobs': [
            'شركات البرمجيات وتطوير الأنظمة',
            'تحليل البيانات والذكاء الاصطناعي',
            'إدارة الشبكات وأمن المعلومات',
            'تطوير تطبيقات الويب والموبايل'
          ],
          'professors': [
            'أ.د / يسرية أبو النجا - أستاذ',
            'أ.م.د / محمد أبو زيد شعلان - أستاذ مساعد',
            'د/ سارة أحمد سليمان فتيح - مدرس',
            'د/ مني محمد فؤاد الغندور - مدرس',
            'د/ شيماء عبد الله إبراهيم خليل - مدرس',
            'د/ رانيا رجب حسين - مدرس',
            'د/ بسنت مصطفى محمد الشوربجي - مدرس'
          ],
        };
      default:
        return {'about': '', 'goals': [], 'jobs': [], 'professors': []};
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(icon, color: Colors.white, size: 48),
                    const SizedBox(height: 10),
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _badge('أول معهد خاص بمصر'),
                    _badge('أساتذة متخصصين'),
                    _badge('معدات متطورة'),
                    _badge('معتمد من نقابة المهندسين'),
                  ]),
                  const SizedBox(height: 20),
                  _secTitle('عن البرنامج'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: color.withOpacity(0.15))),
                    child: Text(d['about'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: AppColors.primary)),
                  ),
                  const SizedBox(height: 20),
                  _secTitle('الأهداف ومجالات التركيز'),
                  const SizedBox(height: 10),
                  ...(d['goals'] as List<String>).map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: color, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(g,
                                    style: const TextStyle(
                                        fontSize: 13, height: 1.4))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  _secTitle('فرص العمل بعد التخرج'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (d['jobs'] as List<String>)
                        .map((j) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          color.withOpacity(0.3))),
                              child: Text(j,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w600)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _secTitle('أعضاء هيئة التدريس'),
                  const SizedBox(height: 10),
                  ...(d['professors'] as List<String>).map((p) =>
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2))
                            ]),
                        child: Row(children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  color.withOpacity(0.1),
                              child: Icon(Icons.person,
                                  color: color, size: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(p,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary))),
                        ]),
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14))),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DepartmentGroupScreen(
                                    departmentName: name,
                                    color: color,
                                  ))),
                      child: const Text(
                          'التالي ← بياناتي في القسم',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _secTitle(String t) => Text(t,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary));

  Widget _badge(String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3))),
        child: Text(text,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600)),
      );
}

// ========== DEPARTMENT GROUP SCREEN ==========
class DepartmentGroupScreen extends StatelessWidget {
  final String departmentName;
  final Color color;
  const DepartmentGroupScreen(
      {super.key,
      required this.departmentName,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('بياناتك في $departmentName'),
          backgroundColor: color),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بياناتك في القسم',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _row('الاسم', 'مصطفى أحمد محمد'),
                _row('الكود', '120221354'),
                _row('القسم', departmentName),
                _row('الفرقة', 'الرابعة'),
                _row('المجموعة', 'مجموعة 1'),
                _row('المعدل GPA', '3.0'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('جروبات المواد',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                const SizedBox(height: 12),
                _groupItem('مجموعة طلاب $departmentName',
                    Icons.group, color, context),
                _groupItem('مجموعة مواد الفرقة الرابعة',
                    Icons.book, color, context),
                _groupItem('مجموعة مشاريع التخرج',
                    Icons.assignment, color, context),
                _groupItem('مجموعة الإعلانات الرسمية',
                    Icons.announcement, color, context),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 12)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
      );

  Widget _groupItem(String name, IconData icon, Color color,
      BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 18)),
      title: Text(name, style: const TextStyle(fontSize: 13)),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8))),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('✅ تم الانضمام إلى $name'),
                backgroundColor: AppColors.green)),
        child: const Text('انضم',
            style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
