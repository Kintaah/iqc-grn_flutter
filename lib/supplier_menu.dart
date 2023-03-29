import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iqc_grn_final_project/add_supplier.dart';
import 'package:iqc_grn_final_project/update_supplier.dart';
import 'dart:convert';

import 'constant.dart';

class SupplierMenu extends StatefulWidget {
  @override
  _SupplierMenuState createState() => _SupplierMenuState();
}

class _SupplierMenuState extends State<SupplierMenu> {
  TextEditingController searchController = TextEditingController();

  List data = [];

  Future<String> getData() async {
    var uri =
        Uri.http(Constants().ip, 'iqcgrn-flutter/read.php', {'q': 'http'});
    var response = await http.get(uri);
    setState(() {
      data = json.decode(response.body);
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplier Menu"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "Search", prefixIcon: Icon(Icons.search)),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (searchController.text.isNotEmpty) {
                    if (!data[index]['code']
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) &&
                        !data[index]['name']
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()) &&
                        !data[index]['status']
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase())) {
                      return SizedBox();
                    }
                  }
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text(data[index]['name']),
                      subtitle: Text(
                          "${data[index]['status']} ${data[index]['class']}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateData(
                              code: data[index]['code'],
                              name: data[index]['name'],
                              status: data[index]['status'],
                              class1: data[index]['class'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSupplierScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
