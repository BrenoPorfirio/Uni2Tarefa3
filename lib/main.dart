import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

enum TableStatus { idle, loading, ready, error }

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier(
      {'status': TableStatus.idle, 'dataObjects': [], 'columnNames': []});

  void carregar(index) async {
    final funcoes = [
      carregarCafes,
      carregarCervejas,
      carregarNacoes,
      carregarApps
    ];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'columnNames': [],
    };

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      funcoes[index]();
    } else {
      print("Sem conexão com a internet!");
    }
  }

  void carregarApps() {
    var appsUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/app/random_app',
        queryParameters: {'size': '5'});
    http.read(appsUri).then((jsonString) {
      var appsJson = jsonDecode(jsonString);
      var properyNames = ["app_name", "app_version", "app_author"];
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': appsJson,
        'columnNames': properyNames,
      };
    });
  }

  void carregarCafes() async {
    var coffesUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/coffee/random_coffee',
        queryParameters: {'size': '5'});
    await http.read(coffesUri).then((jsonString) {
      var coffeesJson = jsonDecode(jsonString);
      var propertyNames = ["blend_name", "origin", "variety"];
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': coffeesJson,
        'columnNames': propertyNames,
      };
    });
  }

  void carregarNacoes() {
    var nationsUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/nation/random_nation',
        queryParameters: {'size': '5'});
    http.read(nationsUri).then((jsonString) {
      var nationsJson = jsonDecode(jsonString);
      var propertyNames = ["nationality", "language", "capital"];
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': nationsJson,
        'columnNames': propertyNames,
      };
    });
  }

  void carregarCervejas() {
    var beersUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/beer/random_beer',
        queryParameters: {'size': '5'});
    http.read(beersUri).then((jsonString) {
      var beersJson = jsonDecode(jsonString);
      var propertyNames = ["name", "style", "ibu"];
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': beersJson,
        'columnNames': propertyNames,
      };
    });
  }
}

final dataService = DataService();

void main() {
  runApp(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              'data:image/jpeg;base64,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',
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "Programação Assíncrona",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            switch (value['status']) {
              case TableStatus.idle:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF898IUjVuyp-DEeSjy7C-9CXvGyiRn2BkOw&usqp=CAU',
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Melhores cervejas, cafés e nações prontinhas para você!',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Toque em um dos botões abaixo para desfrutar dos dados.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              case TableStatus.loading:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case TableStatus.ready:
                return DataTableWidget(
                  jsonObjects: value['dataObjects'],
                  columnNames: value['columnNames'],
                );
              case TableStatus.error:
                return Text("Lascou");
            }
            return Text("...");
          },
        ),
        bottomNavigationBar:
            NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        _itemSelectedCallback(index);
      },
      currentIndex: state.value,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.green,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas",
          icon: Icon(Icons.local_drink_outlined),
        ),
        BottomNavigationBarItem(
          label: "Nações",
          icon: Icon(Icons.flag_outlined),
        ),
        BottomNavigationBarItem(
          label: "Apps",
          icon: Icon(Icons.apps_outlined),
        ),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;

  DataTableWidget({
    this.jsonObjects = const [],
    this.columnNames = const ["Nome", "Estilo", "IBU"],
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columnNames
          .map(
            (name) => DataColumn(
              label: Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          )
          .toList(),
      rows: jsonObjects
          .map(
            (obj) => DataRow(
              cells: columnNames
                  .map(
                    (propName) => DataCell(
                      Text(obj[propName]),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
