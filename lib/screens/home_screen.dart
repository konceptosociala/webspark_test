import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webspark_test/db/keystorage.dart';
import 'package:webspark_test/screens/index.dart';
import 'package:webspark_test/utils/index.dart';
import 'package:webspark_test/widgets/index.dart';

class HomeScreen extends Screen {
  const HomeScreen({
    super.key, 
    required super.nextScreen, 
  });

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
        BottomButton(
          label: 'Start counting process', 
          onPressed: () => _processUri(_uriInputControler.text),
        ),
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

    String uriString = prefs.getString(KeyStorage.currentUrl)??KeyStorage.currentUrlDefault;
    if (uriString != '') {
      setState(() {
        _currentUri = Uri.tryParse(uriString);
        _uriInputControler.text = _currentUri.toString();
      });
    }
  }
}