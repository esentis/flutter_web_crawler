import 'package:basic_utils/basic_utils.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:logger/logger.dart';

var logger = Logger();

Future<List<String>> getLinks(website, response) async {
  // ignore: omit_local_variable_types
  List<String> scrappedLinks = [];

  // Html parser
  var document = parse(response.body);
  // Getting all 'a' tags.
  document.getElementsByTagName('a').forEach((Element link) {
    if (link.attributes['href'] != null &&
        link.attributes['href'] != '#' &&
        !link.attributes['href'].startsWith('java') &&
        !link.attributes['href'].startsWith('{{')) {
      // If the link is relative, we add the domain for a full link.
      if (!link.attributes['href'].startsWith('http')) {
        var fixedLink =
            StringUtils.addCharAtPosition(link.attributes['href'], website, 0);
        scrappedLinks.add(fixedLink);
      } else {
        scrappedLinks.add(link.attributes['href']);
      }
    }
  });

  // Setting to SET to get unique links
  var uniqueLinks = scrappedLinks.toSet().toList();
  // getImgs(document, website);
  return uniqueLinks;
}

/// Gets all elements with IMG tag.
Future<List<String>> getImgs(website, response) async {
  // ignore: omit_local_variable_types
  List<String> images = [];

  var document = parse(response.body);
  document.getElementsByTagName('img').forEach((Element photo) {
    images.add(photo.attributes['src']);
  });
  // Setting to SET to get unique images
  var uniqueImages = images.toSet().toList();
  uniqueImages.forEach((image) {
    logger.d(image);
  });
  return images;
}

/// Gets all elements with H2 tag.
Future<List<String>> getH2s(website, response) async {
  // ignore: omit_local_variable_types
  List<String> h2s = [];
  var document = parse(response.body);
  document.getElementsByTagName('h2').forEach((Element h2) {
    h2s.add(h2.innerHtml);
  });
  // Setting to SET to get unique images
  var uniqueImages = h2s.toSet().toList();
  if (uniqueImages.isEmpty) {
    logger.i('No IMG tags found');
  } else {
    uniqueImages.forEach((h2) {
      logger.d(h2);
    });
  }
  return h2s;
}
