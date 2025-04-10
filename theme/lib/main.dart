import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Tắt debug paint size
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _selectedColor = Colors.white; // Màu sắc được chọn
  Color _selectingColor = Colors.white; // Màu sắc văn bản được chọn
  String _selectedButton = ""; // Biến để lưu trạng thái của nút được chọn

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Tải màu sắc đã lưu từ SharedPreferences
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('selectedColor') ?? Colors.white.value;
    String button = prefs.getString('selectedButton') ?? "";
    setState(() {
      _selectedColor = Color(colorValue);
      _selectingColor = Color(colorValue); // Cập nhật màu sắc văn bản
      _selectedButton = button;
    });
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', _selectedColor.value);
    await prefs.setString('selectedButton', _selectedButton);
  }

  void _applyTheme() {
    _selectedColor = _selectingColor; // Cập nhật màu sắc được chọn
    _saveTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: _selectedColor,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            _selectedColor == Colors.white
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Setting',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blue[400],
                          ),
                        ),
                        Text(
                          'Choosing the right theme sets the tone and personality of your app',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Setting',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        Text(
                          'Choosing the right theme sets the tone and personality of your app',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectingColor =
                          Colors.blue.shade400; // Màu sắc được chọn
                      _selectedButton =
                          "blue"; // Cập nhật trạng thái nút được chọn
                    });
                    _saveTheme();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade400,
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(
                        color:
                            _selectedButton == "blue"
                                ? Colors.black
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(80, 50),
                    ), // Đặt kích thước tối thiểu (width x height)
                  ),
                  child: null,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectingColor = Color(0xFFD346B7); // Màu sắc được chọn
                      _selectedButton =
                          "pink"; // Cập nhật trạng thái nút được chọn
                    });
                    _saveTheme();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFD346B7),
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(
                        color:
                            _selectedButton == "pink"
                                ? Colors.black
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(80, 50),
                    ), // Đặt kích thước tối thiểu (width x height)
                  ),
                  child: null,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectingColor = Color(0xFFF323032); // Chọn màu đen
                      _selectedButton =
                          "black"; // Cập nhật trạng thái nút được chọn
                    });
                    _saveTheme();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFF323032),
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(
                        color:
                            _selectedButton == "black"
                                ? Colors.black
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(80, 50),
                    ), // Đặt kích thước tối thiểu (width x height)
                  ),
                  child: null,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _applyTheme,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(150, 50),
                ), // Đặt kích thước tối thiểu (width x height)
              ),
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
