import 'package:booking_stadium/main.dart';
import 'package:booking_stadium/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfimationScreen extends StatefulWidget {
  const ConfimationScreen({super.key});

  @override
  State<ConfimationScreen> createState() => _ConfimationScreenState();
}

class _ConfimationScreenState extends State<ConfimationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _hashValue = '';

  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _hashValueController = TextEditingController();

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
    _hashValueController.dispose();
    super.dispose();
  }

  void _confirm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      // Simulate a network call or any async operation
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });
      String confirmation_code = _hashValueController.text.trim();

      UserProvider userProvider = context.read<UserProvider>();
      String docId = userProvider.currentUser?.id ?? '';
      print(' [debug] docId: $docId, code: $confirmation_code');
      if (docId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ: معرف المستخدم غير موجود')),
        );
        return;
      } else if (confirmation_code == docId) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تفعيل الحساب بنجاح!')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('رمز التفعيل غير صحيح')));
        return;
      }

      // Navigate to another screen or perform other actions
    }
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
                        tag: 'confirm_icon',
                        child: Material(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.confirmation_number_outlined,
                            size: 72,
                            color: Colors.teal[400],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'تفعيل الحساب',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('hash'),
                        controller: _hashValueController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'رمز التفعيل',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.confirmation_number),
                          hintText: 'Efrh********************hBg1',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 28) {
                            return 'أدخل رمز تفعيل  صحيح';
                          }
                          return null;
                        },
                        onSaved: (value) => _hashValue = value ?? '',
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
                                    onPressed: _confirm,
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
                                      'تفعيل',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
