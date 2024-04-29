import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webspark_test/screens/index.dart';
import 'package:webspark_test/utils/index.dart';

class HomeScreen extends Screen {
  const HomeScreen({super.key, required super.nextScreen});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
  @override
  String title() => "Home screen";

  @override
  Screen? previous() => null;
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _uriInputControler = TextEditingController();
  
  Uri? _currentUri;

  @override
  void initState() {
    super.initState();
    _loadCurrentUri();
    _uriInputControler.text = _currentUri?.toString()??'';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        const Text("Set valid API base URL in order to continue"),
        TextField(
          decoration: const InputDecoration(
            labelText: "Enter URL",
            icon: Icon(
              Icons.compare_arrows_rounded,
              size: 24.0,
            ), 
          ),
          controller: _uriInputControler,
          keyboardType: TextInputType.number,
        ),
        // const SizedBox(height: 32),
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[300], // Background color
                foregroundColor: Colors.black, // Text color
                side: const BorderSide(
                  color: Colors.blue, // Border color
                  width: 2.0, // Border width
                ),
                fixedSize: const Size(double.maxFinite, 60)
              ),
              onPressed: () => _processUri(_uriInputControler.text),
              child: const Text('Start counting process'),
            ),
          ]
        ))
      ]),
    );
  }
  
  void _processUri(String text) {
    Uri? newUri = Uri.tryParse(text);

    if (newUri != null && newUri.isAbsolute) {
      _saveUri(newUri);

      widget.nextScreen(ProcessScreen(
        nextScreen: widget.nextScreen,
        uri: newUri,
      ));

    } else {
      dialog(context, 'Error', 'Invalid URL "$text"');
      newUri = null;
    }

    setState(() {
      _currentUri = newUri; 
    });
  }

  Future<void> _saveUri(Uri uri) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString("current_url", uri.toString());
  }

  Future<void> _loadCurrentUri() async {
    final SharedPreferences prefs = await _prefs;

    String? uriString = prefs.getString("current_url");
    if (uriString != null) {
      setState(() {
        _currentUri = Uri.tryParse(uriString);
        _uriInputControler.text = _currentUri.toString();
      });
    }
  }
}