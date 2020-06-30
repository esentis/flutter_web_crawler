import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart';
import 'crawler.dart';

Future<List<String>> futureLinks;
String website = '';
String helperMessage = "Specify target url and start sniffing !";
bool _loading = false;

class UserInterface extends StatefulWidget {
  @override
  _UserInterfaceState createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Target url',
                            prefix: Text("https://"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onChanged: (value) {
                            print(value);
                            String fixedLink = StringUtils.addCharAtPosition(
                                value, 'https://', 0);

                            website = fixedLink;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Creating a new connection
                          _loading = true;
                          setState(() {});
                          var client = Client();

                          try {
                            Response response = await client.get(website);
                            print(response.statusCode);
                            futureLinks = getLinks(website, response);
                            print(futureLinks);
                            _loading = false;
                            setState(() {});
                          }catch (e){
                            print(e.toString());
                            helperMessage=e.toString();
                            _loading = false;
                            setState(() {});
                          }

                        },
                        child: Material(
                          elevation: 15,
                          shadowColor: _loading == true ? Colors.red : Colors.lightGreen[900],
                          color: Colors.transparent,
                          child: Icon(
                            FontAwesome5.spider,
                            color:
                                _loading == true ? Colors.red : Colors.lightGreen[900],
                            size: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: futureLinks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.only(right: 20, top: 30),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ListTile(
                                leading: Text(
                                  "URL",
                                  style:
                                      GoogleFonts.comfortaa(color: Colors.red),
                                ),
                                title: Text(snapshot.data[index]),
                                subtitle: FlutterLinkPreview(
                                  url: snapshot.data[index],
                                ),
                              );
                            }),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          helperMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.play(fontSize: 20),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
