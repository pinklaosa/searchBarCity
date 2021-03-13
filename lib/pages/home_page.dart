import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchbarexample/cityApi.dart';

CityFromApi cityFromApi;
var cities = new List(77);

class HomePage extends StatefulWidget {
  final List<String> list = List.generate(10, (index) => "Text $index");

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String apiUrl =
      'https://opend.data.go.th/govspending/bbgfmisprovince?api-key=kMAmZXGRGdgtTRPKb0aCCsgIeuNBO6Mj';

  @override
  void initState() {
    super.initState();
    print('init state');
    getData();
  }

  Future<void> getData() async {
    print('get data');
    var response = await http.get(apiUrl);
    print(response.body);
    setState(() {
      cityFromApi = cityFromApiFromJson(response.body);
    });
    for (var i = 0; i < 77; i++) {
      cities[i] = cityFromApi.result[i].provName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
            icon: Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: Text('City'),
        toolbarHeight: 80,
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  // ตรงนี้จะเป็นส่วนที่เวลากดจังหวัดอะไร แล้วให้ทำงานตามจังหวัดนั้น
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List suggestionList = cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]),
          ),
          leading: query.isEmpty ? Icon(Icons.location_city) : SizedBox(),
          onTap: () {
            selectedResult = suggestionList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
