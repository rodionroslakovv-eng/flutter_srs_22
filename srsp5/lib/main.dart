import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rodion Register Form',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationPage(),
    );
  }
}

// ======================= RegistrationPage =======================

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController(text: 'Rodion');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // FocusNodes
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirmPass = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  // ---------------- Validators ----------------

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Only digits are allowed';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w.+-]+@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != _passController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ---------------- Submit ----------------

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form is not valid! Please review and correct.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text.trim());
    await prefs.setString('phone', _phoneController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('story', _storyController.text.trim());

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserInfoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Full Name
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(context, _nameFocus, _phoneFocus),
              validator: _validateName,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Rodion',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _nameController.clear(),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(context, _phoneFocus, _emailFocus),
              validator: _validatePhone,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                helperText: 'Phone format: (XXX)XXX-XXXX',
                prefixIcon: const Icon(Icons.call),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _phoneController.clear(),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Email
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(context, _emailFocus, _storyFocus),
              validator: _validateEmail,
              decoration: const InputDecoration(
                labelText: 'Email Address *',
                hintText: 'rodion@example.com',
                icon: Icon(Icons.mail),
              ),
            ),
            const SizedBox(height: 20),

            // Life Story
            TextFormField(
              controller: _storyController,
              focusNode: _storyFocus,
              maxLines: 3,
              textInputAction: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(context, _storyFocus, _passFocus),
              decoration: const InputDecoration(
                labelText: 'Life Story',
                hintText: 'Tell us about yourself, Rodion',
                helperText: 'Keep it short, this is just a demo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Password
            TextFormField(
              controller: _passController,
              focusNode: _passFocus,
              obscureText: _hidePass,
              maxLength: 8,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(context, _passFocus, _confirmPassFocus),
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'Enter the password',
                icon: const Icon(Icons.security),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePass ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Confirm Password
            TextFormField(
              controller: _confirmPassController,
              focusNode: _confirmPassFocus,
              obscureText: _hideConfirmPass,
              maxLength: 8,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitForm(),
              validator: _validateConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                hintText: 'Confirm the password',
                icon: const Icon(Icons.border_color),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideConfirmPass ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _hideConfirmPass = !_hideConfirmPass),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Submit
            SizedBox(
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Submit Form',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= UserInfoPage =======================

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<Map<String, String>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _loadUserData();
  }

  Future<Map<String, String>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'phone': prefs.getString('phone') ?? '',
      'email': prefs.getString('email') ?? '',
      'story': prefs.getString('story') ?? '',
    };
  }

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('phone');
    await prefs.remove('email');
    await prefs.remove('story');
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading data'));
          }

          final data = snapshot.data!;
          final story = data['story']!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: Text(
                        data['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(story.isEmpty ? 'No life story' : story),
                    ),
                    ListTile(
                      leading: const Icon(Icons.call, color: Colors.black),
                      title: Text(data['phone']!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.mail, color: Colors.black),
                      title: Text(data['email']!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _clearData,
                  child: const Text('Clear data and go back'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}