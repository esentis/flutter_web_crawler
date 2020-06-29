import 'package:http/http.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

Future<List<String>> getLinks(website) async{
  List<String> scrappedLinks = [];

  // Creating a new connection
  var client = Client();
  Response response = await client.get(website);
  // Html parser
  var document = parse(response.body);
  // Getting all 'a' tags.
  document.getElementsByTagName('a').forEach((Element link) {
    String fixedLink = "";
    if (link.attributes['href'] != null &&
        link.attributes['href'] != "#" &&
        !link.attributes['href'].startsWith('java') &&
        !link.attributes['href'].startsWith('{{')) {
      // If the link is relative, we add the domain for a full link.
      if (!link.attributes['href'].startsWith('http')) {
        String fixedLink =
        StringUtils.addCharAtPosition(link.attributes['href'], website, 0);
        scrappedLinks.add(fixedLink);
      } else {
        scrappedLinks.add(link.attributes['href']);
      }
    }
  });
  // Setting to SET to get unique links
  var uniqueLinks = scrappedLinks.toSet().toList();
  return uniqueLinks;
}

void getDivs(document, website) {
  List<String> scrappedLinks = [];
  document.getElementById('div').forEach((Element link) {
    String fixedLink = "";
    print(link.attributes);
    if (link.attributes['href'] != null &&
        link.attributes['href'] != "#" &&
        !link.attributes['href'].startsWith('java') &&
        !link.attributes['href'].startsWith('{{')) {
      if (!link.attributes['href'].startsWith('http')) {
//                  print("The link before fixing : ${link.attributes['href']}");
        String fixedLink =
        StringUtils.addCharAtPosition(link.attributes['href'], website, 0);
//                  print ("The link after fix : $fixedLink");
//                  print(fixedLink);
        scrappedLinks.add(fixedLink);
      } else {
//                  print (link.attributes['href']);
        scrappedLinks.add(link.attributes['href']);
      }
//                linkMap.add({
//                  'title': link.text,
//                  'href': link.attributes['href'],
//                });
    }
  });
  // Setting to SET to get unique links
  var uniqueLinks = scrappedLinks.toSet().toList();
  uniqueLinks.forEach((link) {
    print(link);
  });
  print(uniqueLinks.length);
}
