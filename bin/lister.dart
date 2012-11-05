
library lister;

import 'dart:io';
import 'package:args/args.dart';

class Lister {
  process() {
//    var path = new Path.fromNative(new Options().script).directoryPath;
    var path = new Path.fromNative(r'C:\Users\schuberd\Documents\GitHub\search\bin');
    var dir = new Directory.fromPath(path);
    var lister = dir.list(recursive: false);
    lister.onFile = (name) {
      if (name.endsWith('.dart')) {
        print('File: $name');
      }
    };
  }
}

main() {
  var lister = new Lister();
  lister.process();
}
