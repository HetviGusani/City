import 'package:city/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  CollectionReference addUser = FirebaseFirestore.instance.collection('User');

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = '';
  String name = '';
  String password = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create Account'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your email';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a password';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          name = _nameController.text.trim();
                          email = _emailController.text.trim();
                          password = _passwordController.text.trim();
                        });

                        await _registerUser();   // ✅ wait for completion
                        _clearText();            // ✅ clear after saving
                      }
                    },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _handleSignIn(context);
                },
                child: Text("Login With Gmail"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      setState(() => _isLoading = true);

      // 🔐 Create user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 📦 Save extra data in Firestore (NO password)
      await addUser.doc(userCredential.user!.uid).set({
        'Name': name,
        'Email': email,
        'UID': userCredential.user!.uid,
      });

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Account Created")));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);

      String message = '';

      if (e.code == 'email-already-in-use') {
        message = 'Email already exists';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else {
        message = e.message ?? 'Error occurred';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
    }
  }

  _clearText() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 🔐 Firebase login
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      // 📦 Store in Firestore
      await addUser.doc(user!.uid).set({
        'Name': user.displayName,
        'Email': user.email,
        'UID': user.uid,
        'Photo': user.photoURL,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Google Login Success")));

    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }
}
