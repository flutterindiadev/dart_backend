import 'package:dart_backend_client/dart_backend_client.dart';
import 'package:dart_backend_flutter/accountpage.dart';
import 'package:dart_backend_flutter/signInpage.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.

late SessionManager sessionManager;
late Client client;

Future<void> initializeServerpodClient() async {
  // The android emulator does not have access to the localhost of the machine.
  // const ipAddress = '10.0.2.2'; // Android emulator ip for the host

  // On a real device replace the ipAddress with the IP address of your computer.
  const ipAddress = 'localhost';

  // Sets up a singleton client object that can be used to talk to the server from
  // anywhere in our app. The client is generated from your server code.
  // The client is set up to connect to a Serverpod running on a local server on
  // the default port. You will need to modify this to connect to staging or
  // production servers.
  client = Client(
    'http://$ipAddress:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  // The session manager keeps track of the signed-in state of the user. You
  // can query it to see if the user is currently signed in and get information
  // about the user.
  sessionManager = SessionManager(
    caller: client.modules.auth,
  );

  await sessionManager.initialize();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeServerpodClient();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // Make sure that we rebuild the page if signed in status changes.
    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
      ),
      body:
          sessionManager.isSignedIn ? const AccountPage() : const SignInPage(),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   // These fields hold the last result or error message that we've received from
//   // the server or null if no result exists yet.
//   String? _resultMessage;
//   String? _errorMessage;

//   final _textEditingController = TextEditingController();

//   // Calls the `hello` method of the `example` endpoint. Will set either the
//   // `_resultMessage` or `_errorMessage` field, depending on if the call
//   // is successful.
//   void _callHello() async {
//     try {
//       final result =
//           await client.userEndpoints.test(_textEditingController.text);
//       setState(() {
//         _resultMessage = result;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = '$e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: TextField(
//                 controller: _textEditingController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter your name',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: ElevatedButton(
//                 onPressed: _callHello,
//                 child: const Text('Send to Server'),
//               ),
//             ),
//             SignInWithGoogleButton(
//               caller: client.modules.auth,
//               serverClientId:
//                   "79289485514-q0hv7hchuh1l07bcp14grghtmok842i8.apps.googleusercontent.com",
//               redirectUri: Uri.parse('http://localhost:8082/googlesignin'),
//             ),
//             _ResultDisplay(
//               resultMessage: _resultMessage,
//               errorMessage: _errorMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // _ResultDisplays shows the result of the call. Either the returned result from
// // the `example.hello` endpoint method or an error message.
// class _ResultDisplay extends StatelessWidget {
//   final String? resultMessage;
//   final String? errorMessage;

//   const _ResultDisplay({
//     this.resultMessage,
//     this.errorMessage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     String text;
//     Color backgroundColor;
//     if (errorMessage != null) {
//       backgroundColor = Colors.red[300]!;
//       text = errorMessage!;
//     } else if (resultMessage != null) {
//       backgroundColor = Colors.green[300]!;
//       text = resultMessage!;
//     } else {
//       backgroundColor = Colors.grey[300]!;
//       text = 'No server response yet.';
//     }

//     return Container(
//       height: 50,
//       color: backgroundColor,
//       child: Center(
//         child: Text(text),
//       ),
//     );
//   }
// }
