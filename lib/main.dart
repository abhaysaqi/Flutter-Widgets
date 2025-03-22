import 'package:flutter/material.dart';
import 'package:my_flutter_widgets/Widgets/appbar/common_appbar.dart';
import 'package:my_flutter_widgets/Widgets/buttons/custom_button.dart';
import 'package:my_flutter_widgets/Widgets/custom_textfields/custom_textfield.dart';
import 'package:my_flutter_widgets/Widgets/divider/custom_divider.dart';
import 'package:my_flutter_widgets/Widgets/navigation_between_signin_singup.dart';
import 'package:my_flutter_widgets/Widgets/terms_and_conditions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "title"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CustomTextField(),
            CustomButton(),
            TermsAndConditions(),
            CustomDividerWithText(),
            CustomSignInSignUpText(
              haveAccountOrNotText: "Already have an account? ",
              signinOrSingupText: "Sign up",
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
