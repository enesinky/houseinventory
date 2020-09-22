import 'package:flutter/cupertino.dart';

class Path {

  final String pattern;
  final Widget Function(BuildContext, String) builder;

  const Path(this.pattern, this.builder);
}