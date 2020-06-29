import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'crawler.dart';

Future<List<String>> futureLinks;
String website = '';

class UserInterface extends StatefulWidget {
  @override
  _UserInterfaceState createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Target url',
                    prefix: Text("http://")
                ),
                onChanged: (value) {
                  print(value);
                  String fixedLink = StringUtils.addCharAtPosition(value, 'http://', 0);

                  website = fixedLink;
                },
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(

                padding: EdgeInsets.all(15),
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                onPressed: () async {
                  futureLinks = getLinks(website);
                  setState(() {});
                },
                child: Icon(Icons.find_in_page),
              ),
              SizedBox(height: 30,),
              FutureBuilder(
                future: futureLinks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(right: 20, top: 30),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return ListTile(
                              leading: Text(
                                "URL",
                                style: GoogleFonts.comfortaa(color: Colors.red),
                              ),
                              title: Text(snapshot.data[index]),
                            );
                          }),
                    );
                  } else {
                    return Text("Specify target url and start sniffing !",style: GoogleFonts.play(
                        fontSize: 14
                    ),);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
