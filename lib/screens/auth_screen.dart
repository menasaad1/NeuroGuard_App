import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../services/user_management_service.dart';
import '../services/language_service.dart';
import '../utils/text_utils.dart';
import 'language_settings_screen.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const AuthScreen({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;

  void _toggle() => setState(() => _showLogin = !_showLogin);

  @override
  Widget build(BuildContext context) {
    return _showLogin
        ? LoginWidget(onSwitch: _toggle, onToggleTheme: widget.onToggleTheme)
        : SignupWidget(onSwitch: _toggle, onToggleTheme: widget.onToggleTheme);
  }
}

class LoginWidget extends StatefulWidget {
  final VoidCallback onSwitch;
  final VoidCallback onToggleTheme;
  const LoginWidget(
      {Key? key, required this.onSwitch, required this.onToggleTheme})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _loading = true;
      _error = null;
    });
    
    try {
      final ok = await AppState.instance.signIn(emailC.text.trim(), passC.text);
      if (!ok) {
        setState(() {
          _error = 'فشل في تسجيل الدخول - تحقق من البريد الإلكتروني وكلمة المرور';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageService().isArabic ? 'NeuroGuard - تسجيل الدخول' : 'NeuroGuard - Login',
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LanguageSettingsScreen(),
                ),
              );
            },
            tooltip: LanguageService().isArabic ? 'تغيير اللغة' : 'Change Language',
          ),
          IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and title
              const SizedBox(height: 20),
              Icon(
                Icons.health_and_safety,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'مرحباً بك في NeuroGuard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'نظام مراقبة الصحة العصبية الذكي',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Email field
              TextFormField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Password field
              TextFormField(
                controller: passC,
                obscureText: _obscurePassword,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Error message
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Login button
              ElevatedButton(
                onPressed: _loading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'تسجيل الدخول',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 16),
              
              // Switch to sign up
              TextButton(
                onPressed: widget.onSwitch,
                child: const Text('ليس لديك حساب؟ سجل الآن'),
              ),
              const SizedBox(height: 24),
              
              // Demo accounts section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'حسابات تجريبية للاختبار',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildDemoButton(
                          'مريض (سارة)',
                          () {
                            AppState.instance.currentUser.value =
                                Map<String, dynamic>.from(
                                    AppState.instance.users['pt_sara']!);
                          },
                          Colors.green,
                        ),
                        _buildDemoButton(
                          'مقدم رعاية (منى)',
                          () {
                            AppState.instance.currentUser.value =
                                Map<String, dynamic>.from(
                                    AppState.instance.users['cg_mona']!);
                          },
                          Colors.orange,
                        ),
                        _buildDemoButton(
                          'طبيب (د. علي)',
                          () {
                            AppState.instance.currentUser.value =
                                Map<String, dynamic>.from(
                                    AppState.instance.users['cl_ali']!);
                          },
                          Colors.blue,
                        ),
                        _buildDemoButton(
                          'مدير',
                          () {
                            AppState.instance.currentUser.value =
                                Map<String, dynamic>.from(
                                    AppState.instance.users['ad_admin']!);
                          },
                          Colors.purple,
                        ),
                      ],
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

  Widget _buildDemoButton(String text, VoidCallback onPressed, Color color) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 80,
        maxWidth: 150,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class SignupWidget extends StatefulWidget {
  final VoidCallback onSwitch;
  final VoidCallback onToggleTheme;
  const SignupWidget(
      {Key? key, required this.onSwitch, required this.onToggleTheme})
      : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String role = UserManagementService.rolePatient;
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _error;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text;
    
    setState(() {
      _loading = true;
      _error = null;
    });
    
    try {
      await AppState.instance.signUp(name, email, pass, role);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroGuard - إنشاء حساب'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and title
              const SizedBox(height: 20),
              Icon(
                Icons.person_add_alt_1,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'إنشاء حساب جديد',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'انضم إلى نظام NeuroGuard للرعاية الصحية الذكية',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Name field
              TextFormField(
                controller: nameC,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextUtils.getSafeTextStyle(),
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: const Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال الاسم الكامل';
                  }
                  if (value.trim().length < 2) {
                    return 'الاسم يجب أن يكون حرفين على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email field
              TextFormField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Password field
              TextFormField(
                controller: passC,
                obscureText: _obscurePassword,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Confirm password field
              TextFormField(
                controller: confirmPassC,
                obscureText: _obscureConfirmPassword,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى تأكيد كلمة المرور';
                  }
                  if (value != passC.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Role selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نوع الحساب',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: UserManagementService.availableRoles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getRoleIcon(role),
                                  color: _getRoleColor(role),
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        UserManagementService.getRoleDisplayName(role),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        UserManagementService.getRoleDescription(role),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => role = v ?? UserManagementService.rolePatient),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Error message
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Sign up button
              ElevatedButton(
                onPressed: _loading ? null : _signup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'إنشاء الحساب',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 16),
              
              // Switch to login
              TextButton(
                onPressed: widget.onSwitch,
                child: const Text('لديك حساب بالفعل؟ سجل دخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case UserManagementService.rolePatient:
        return Icons.person;
      case UserManagementService.roleCaregiver:
        return Icons.family_restroom;
      case UserManagementService.roleClinician:
        return Icons.medical_services;
      case UserManagementService.roleAdmin:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case UserManagementService.rolePatient:
        return Colors.green;
      case UserManagementService.roleCaregiver:
        return Colors.orange;
      case UserManagementService.roleClinician:
        return Colors.blue;
      case UserManagementService.roleAdmin:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
