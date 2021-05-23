import 'package:contacts_service/contacts_service.dart';
import 'package:dominos2/API/OrderDetails.dart';
import 'package:dominos2/API/getData.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  final Contact contact;
  final String phone;
  ShowData(this.contact, this.phone);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  late Future<OrderDetails> ftr;
  late OrderDetails data;
  @override
  void initState() {
    ftr = getData();
    super.initState();
  }

  getData() async {
    this.data = await API.getData(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text("Error"),
              ),
            );
          }
          try {
            final name = data.dbData.linkedEmails.first;
            return Container(
              width: 50,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text('4545' + name),
                  SizedBox(height: 50),
                ],
              ),
            );
          } catch (e) {
            return Container(
              width: 50,
              child: Center(
                child: Text("Error: " + e.toString()),
              ),
            );
          }
        }
        return Container(
          width: 50,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 50),
              LinearProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading Data'),
              SizedBox(height: 50),
            ],
          ),
        );
      },
      future: ftr,
    );
  }
}
