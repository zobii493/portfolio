import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

Future<void> openLink(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

void downloadCV() {
  const url = 'assets/cv/zohaib_hassan_cv.pdf';
  html.AnchorElement(href: url)
    ..setAttribute('download', 'Zohaib_Hassan_CV.pdf')
    ..click();
}