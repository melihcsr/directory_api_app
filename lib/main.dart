import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remote_api/model/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Personel Listesi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final url = Uri.parse("https://reqres.in/api/users");
  int counter = 0;
  late var personalResult;

  Future callPerson() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var result = personFromJson(response.body);
        print(result.data![0].firstName);

        setState(() {
          counter = result.data!.length;
          personalResult = result;
        });
        return result;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(personalResult.data[index].firstName),
          subtitle: Text(personalResult.data[index].email),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(personalResult.data[index].avatar),
          ),
        ),
        itemCount: counter,
      )),
    );
  }
}
