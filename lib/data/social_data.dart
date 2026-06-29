import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialItem {
  final FaIconData icon;
  final String label;
  final Color color;
  final String url;

  const SocialItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.url,
  });
}

const kSocials = [
  SocialItem(
    icon: FontAwesomeIcons.github,
    label: 'GitHub',
    color: Color(0xFF6e5494),
    url: 'https://github.com/zobii493',
  ),
  SocialItem(
    icon: FontAwesomeIcons.linkedin,
    label: 'LinkedIn',
    color: Color(0xFF0A66C2),
    url: 'https://linkedin.com/in/zohaibhassan3',
  ),
  SocialItem(
    icon: FontAwesomeIcons.envelope,
    label: 'Email',
    color: Color(0xFF00C853),
    url: 'mailto:zobii493@gmail.com',
  ),
  SocialItem(
    icon: FontAwesomeIcons.whatsapp,
    label: 'WhatsApp',
    color: Color(0xFF25D366),
    url: 'https://wa.me/923419466773',
  ),
];