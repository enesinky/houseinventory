import 'package:flutter/cupertino.dart';

class Path {

  final String pattern;
  final Widget Function(BuildContext, List) builder;

  const Path(this.pattern, this.builder);
}