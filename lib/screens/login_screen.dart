import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await LanguageService.getLanguage();
    setState(() {
      _language = lang;
    });
  }

  Future<void> _toggleLanguage() async {
    final newLang = _language == 'en' ? 'ar' : 'en';
    await LanguageService.setLanguage(newLang);
    setState(() {
      _language = newLang;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success;
      if (_isLogin) {
        success = await AuthService.login(
          _usernameController.text,
          _passwordController.text,
        );
      } else {
        success = await AuthService.signup(
          _usernameController.text,
          _passwordController.text,
        );
      }

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_language == 'ar'
                ? 'اسم المستخدم أو كلمة المرور غير صحيحة'
                : 'Invalid username or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _language == 'ar';
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.landscape,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _language == 'ar' ? 'مستكشف مصر' : 'Egypt Explorer',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Language Toggle
                    TextButton.icon(
                      onPressed: _toggleLanguage,
                      icon: const Icon(Icons.language),
                      label: Text(_language == 'ar' ? 'English' : 'العربية'),
                    ),
                    const SizedBox(height: 24),
                    // Username Field
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: _language == 'ar' ? 'اسم المستخدم' : 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _language == 'ar'
                              ? 'يرجى إدخال اسم المستخدم'
                              : 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: _language == 'ar' ? 'كلمة المرور' : 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _language == 'ar'
                              ? 'يرجى إدخال كلمة المرور'
                              : 'Please enter password';
                        }
                        if (value.length < 3) {
                          return _language == 'ar'
                              ? 'كلمة المرور يجب أن تكون 3 أحرف على الأقل'
                              : 'Password must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isLogin
                                    ? (_language == 'ar' ? 'تسجيل الدخول' : 'Login')
                                    : (_language == 'ar' ? 'إنشاء حساب' : 'Sign Up'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Toggle Login/Signup
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? (_language == 'ar'
                                ? 'ليس لديك حساب؟ إنشاء حساب'
                                : 'Don\'t have an account? Sign Up')
                            : (_language == 'ar'
                                ? 'لديك حساب؟ تسجيل الدخول'
                                : 'Have an account? Login'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Demo credentials hint
                    Text(
                      _language == 'ar'
                          ? 'للاختبار: admin/admin123 أو user/user123'
                          : 'For testing: admin/admin123 or user/user123',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

