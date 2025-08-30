import 'package:booking_stadium/auth/register_service.dart';
import 'package:booking_stadium/firebase/firebase_service.dart';
import 'package:booking_stadium/main.dart';
import 'package:booking_stadium/models/user.dart';
import 'package:booking_stadium/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _phone = '';
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    bool retval = false;
    UserModel? cuurentUser;
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    String phone = _phoneController.text.trim();
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    String fullPhoneNumber = '+20$phone';
    print(" [debug] fullPhoneNumber $fullPhoneNumber");
    bool codeSent = await RegisterService.sendOTP(fullPhoneNumber);
    setState(() => _isLoading = false);
    if (codeSent) {
      String? otp = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          String code = '';
          bool isVerifying = false;
          String? errorText;
          return StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('أدخل رمز التحقق'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'رمز التحقق',
                          errorText: errorText,
                        ),
                        onChanged: (v) => code = v,
                      ),
                      if (isVerifying)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed:
                          isVerifying
                              ? null
                              : () async {
                                setState(() => isVerifying = true);
                                bool verified = await RegisterService.verifyOTP(
                                  code,
                                );

                                setState(() => isVerifying = false);
                                if (verified) {
                                  cuurentUser =
                                      await RegisterService.getCurrentUserModel();
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).updateUser(cuurentUser);
                                  print(
                                    "cuurentUser phone after login ${cuurentUser!.phone}",
                                  );
                                  Navigator.of(context).pop(code);
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 600,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => FadeTransition(
                                            opacity: animation,
                                            child: const MainNavShell(),
                                          ),
                                    ),
                                  );
                                } else {
                                  setState(
                                    () => errorText = 'رمز التحقق غير صحيح',
                                  );
                                }
                              },
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
          );
        },
      );
      if (otp != null) {
        // Registration complete, navigate to main app or show success
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم التحقق بنجاح!')));
        // TODO: Save user info to Firestore if needed
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فشل إرسال رمز التحقق')));
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder:
            (context, animation, secondaryAnimation) => FadeTransition(
              opacity: animation,
              child: const RegisterScreen(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'auth_icon',
                        child: Material(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.lock,
                            size: 72,
                            color: Colors.teal[400],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('phone'),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                          hintText: '1xxxxxxxxx',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'أدخل رقم هاتف صحيح';
                          }
                          return null;
                        },
                        onSaved: (value) => _phone = value ?? '',
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 28),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    key: const ValueKey('login_btn'),
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal[600],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text(
                                      'دخول',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _goToRegister,
                        child: const Text(
                          'ليس لديك حساب؟ سجل الآن',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _phone = '';

  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    UserModel? cuurentUser;
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    String phone = _phoneController.text.trim();
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    String fullPhoneNumber = '+20$phone';
    bool codeSent = await RegisterService.sendOTP(fullPhoneNumber);
    setState(() => _isLoading = false);
    if (codeSent) {
      String? otp = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          String code = '';
          bool isVerifying = false;
          String? errorText;
          return StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('أدخل رمز التحقق'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'رمز التحقق',
                          errorText: errorText,
                        ),
                        onChanged: (v) => code = v,
                      ),
                      if (isVerifying)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed:
                          isVerifying
                              ? null
                              : () async {
                                setState(() => isVerifying = true);
                                bool verified = await RegisterService.verifyOTP(
                                  code,
                                );
                                setState(() => isVerifying = false);
                                if (verified) {
                                  print(" [debug] verified");
                                  RegisterService.addingNewUser(
                                    _username,
                                    _phone,
                                  );
                                  cuurentUser =
                                      await RegisterService.getCurrentUserModel();
                                  print(
                                    "current user auth_screen $cuurentUser",
                                  );
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).updateUser(cuurentUser);
                                  Navigator.of(context).pop(code);
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 600,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => FadeTransition(
                                            opacity: animation,
                                            child: const OnboardingScreen(),
                                          ),
                                    ),
                                  );
                                } else {
                                  setState(
                                    () => errorText = 'رمز التحقق غير صحيح',
                                  );
                                }
                              },
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
          );
        },
      );
      if (otp != null) {
        // Registration complete, navigate to main app or show success
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم التحقق بنجاح!')));
        // TODO: Save user info to Firestore if needed
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('فشل إرسال رمز التحقق')));
    }
  }

  void _goToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.97),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'auth_icon',
                        child: Material(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.person_add,
                            size: 72,
                            color: Colors.teal[400],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        key: const ValueKey('username'),
                        decoration: InputDecoration(
                          labelText: 'اسم المستخدم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'أدخل اسم المستخدم';
                          }
                          return null;
                        },
                        onSaved: (value) => _username = value ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('phone'),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                          hintText: '1xxxxxxxxx',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'أدخل رقم هاتف صحيح';
                          }
                          return null;
                        },
                        onSaved: (value) => _phone = value ?? '',
                      ),
                      const SizedBox(height: 16),

                      // const SizedBox(height: 16),
                      const SizedBox(height: 28),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    key: const ValueKey('register_btn'),
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal[600],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text(
                                      'تسجيل',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _goToLogin,
                        child: const Text(
                          'لديك حساب؟ تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
