import 'package:flutter/material.dart';
import 'package:todo_demo/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = '';
  bool isSignIn = true;

  Future<void> signIn() async {
    final result = await AuthService().signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (result != null) {
      setState(() {
        error = result;
      });
    }
  }

  Future<void> signUp() async {
    final result = await AuthService().signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (result != null) {
      setState(() {
        error = result;
      });
    }
  }

  void toggleMode() {
    setState(() {
      isSignIn = !isSignIn;
      error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSignIn ? 'Sign In' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),

              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).nextFocus(), // Move to next field
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            isSignIn
                ? ElevatedButton(
                    onPressed: signIn,
                    child: const Text('Sign In'),
                  )
                : ElevatedButton(
                    onPressed: signUp,
                    child: const Text('Sign Up'),
                  ),
            TextButton(
              onPressed: toggleMode,
              child: Text(
                isSignIn
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Sign In",
              ),
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
