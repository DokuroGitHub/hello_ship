import 'package:colorize/colorize.dart';
import 'package:flutter/material.dart';

const _min = 1;
const _max = 699;
final _pattern = RegExp('.{$_min,$_max}'); // '.{1,800}'

class Print {
  void all(Object? object) {
    _pattern
        .allMatches(object.toString())
        .forEach((match) => debugPrint((match.group(0) ?? '')));
  }

  void styles([Object? object = 'styles', List<Styles> styles = const []]) {
    var colorized = Colorize(object.toString());
    for (var element in styles) {
      colorized.apply(element);
    }
    all(colorized);
  }

  void red([Object? object = 'red']) {
    var colorized = Colorize(object.toString()).red();
    all(colorized);
  }

  void blue([Object? object = 'blue']) {
    var colorized = Colorize(object.toString()).blue();
    all(colorized);
  }

  void yellow([Object? object = 'yellow']) {
    var colorized = Colorize(object.toString()).yellow();
    all(colorized);
  }

  void green([Object? object = 'green']) {
    var colorized = Colorize(object.toString()).green();
    all(colorized);
  }

  void bgBlue([Object? object = 'bgBlue']) {
    var colorized = Colorize(object.toString()).bgBlue();
    all(colorized);
  }

  void bgGreen([Object? object = 'bgGreen']) {
    var colorized = Colorize(object.toString()).bgGreen();
    all(colorized);
  }

  void cyan([Object? object = 'cyan']) {
    var colorized = Colorize(object.toString()).cyan();
    all(colorized);
  }

  void bgCyan([Object? object = 'bgCyan']) {
    var colorized = Colorize(object.toString()).bgCyan();
    all(colorized);
  }
}

final print = Print();
