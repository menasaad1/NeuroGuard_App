import 'package:flutter/material.dart';
import '../state/app_state.dart';

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
  final TextEditingController emailC =
      TextEditingController(text: 'sara@example.com');
  final TextEditingController passC =
      TextEditingController(text: 'password123');
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    
    try {
      final ok = await AppState.instance.signIn(emailC.text.trim(), passC.text);
      setState(() {
        _loading = false;
      });
      if (!ok) {
        setState(() {
          _error = 'Login failed. Please check your credentials and try again.';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Login failed: ${e.toString()}';
      });
    }
  }

  Future<void> _showForgotPassword() async {
    final emailController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isNotEmpty) {
                try {
                  // TODO: Implement password reset using Firebase Auth Service
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent! Check your inbox.'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroGuard — Login'),
        actions: [
          IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Sign in', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          TextField(
              controller: emailC,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email))),
          const SizedBox(height: 8),
          TextField(
              controller: passC,
              decoration: const InputDecoration(
                  labelText: 'Password', prefixIcon: Icon(Icons.lock)),
              obscureText: true),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton.icon(
            onPressed: _loading ? null : _login,
            icon: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.login),
            label: const Text('Login'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _showForgotPassword,
            child: const Text('Forgot Password?'),
          ),
          TextButton(
              onPressed: widget.onSwitch,
              child: const Text('Don\'t have an account? Sign up')),
          const SizedBox(height: 8),
          const Text('Quick demo accounts',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            ElevatedButton(
                onPressed: () {
                  AppState.instance.currentUser.value =
                      Map<String, dynamic>.from(
                          AppState.instance.users['pt_sara']!);
                },
                child: const Text('Patient (Sara)')),
            ElevatedButton(
                onPressed: () {
                  AppState.instance.currentUser.value =
                      Map<String, dynamic>.from(
                          AppState.instance.users['cg_mona']!);
                },
                child: const Text('Caregiver (Mona)')),
            ElevatedButton(
                onPressed: () {
                  AppState.instance.currentUser.value =
                      Map<String, dynamic>.from(
                          AppState.instance.users['cl_ali']!);
                },
                child: const Text('Clinician (Dr. Ali)')),
            ElevatedButton(
                onPressed: () {
                  AppState.instance.currentUser.value =
                      Map<String, dynamic>.from(
                          AppState.instance.users['ad_admin']!);
                },
                child: const Text('Admin')),
          ])
        ]),
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
  String role = 'patient';
  bool _loading = false;
  String? _error;

  Future<void> _signup() async {
    final name = nameC.text.trim();
    final email = emailC.text.trim();
    final pass = passC.text;
    
    if (name.isEmpty || !email.contains('@') || pass.length < 6) {
      setState(() {
        _error = 'Please provide valid details and password (minimum 6 characters)';
      });
      return;
    }
    
    setState(() {
      _loading = true;
      _error = null;
    });
    
    try {
      await AppState.instance.signUp(name, email, pass, role);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Sign up failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        actions: [
          IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 8),
          TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: role,
            items: const [
              DropdownMenuItem(value: 'patient', child: Text('Patient')),
              DropdownMenuItem(value: 'caregiver', child: Text('Caregiver')),
              DropdownMenuItem(value: 'clinician', child: Text('Clinician')),
              DropdownMenuItem(value: 'admin', child: Text('Admin')),
            ],
            onChanged: (v) => setState(() => role = v ?? 'patient'),
            decoration: const InputDecoration(labelText: 'Role'),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Role Detection:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Admin: @neuroguard.com, @hospital.admin\n'
                  '• Clinician: dr.@, @clinic., @hospital., @medical.\n'
                  '• Caregiver: caregiver@, nurse@, @care., @support.\n'
                  '• Patient: All other emails',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton.icon(
              onPressed: _loading ? null : _signup,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.person_add),
              label: const Text('Sign up')),
          TextButton(
              onPressed: widget.onSwitch,
              child: const Text('Have an account? Login')),
        ]),
      ),
    );
  }
}
