// Copyright (c) 2012, Daniel Schubert.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library search;

import 'dart:io';
import 'package:args/args.dart';

final _LINE_NUMBER_INTENDATION = 4;
final _SPACE_CHAR = ' ';

String _pad(number, maxDigits) {
  var digits = number.toString().replaceAll('.', '').length;
  var leading = '';
  for (int i = 0; i < (maxDigits - digits); i++) {
    leading = '$_SPACE_CHAR$leading';
  }
  return '$leading${number.toString()}';
}

Future<List<String>> _filterLine(lines, pattern) {
  var completer = new Completer<List<String>>();
  var number = 1;
  var result = <String>[];
  var line;
  while ((line = lines.readLine()) != null) {
    if (line.contains(pattern)) {
      result.add("${_pad(number, _LINE_NUMBER_INTENDATION)}: $line");
    }
    number++;
  }
  completer.complete(result);
  return completer.future;
}

String _formatMatches(count) =>
    "$count ${(count == 1) ? 'match' : 'matches'}";

void _proccesLines(name, lines, pattern) {
  _filterLine(lines, pattern).then((lines) {
    if (lines.length > 0) {
      print("File: $name (${_formatMatches(lines.length)})");
      for (final line in lines) {
        print(line);
      }
      print("");
    }
  });
}

void _processFile(name, file, pattern) {
  if (name.contains(file)) {
    var stream = new File(name).openInputStream();
    var lines = new StringInputStream(stream);
    lines.onLine = () {
      _proccesLines(name, lines, pattern);
    };
    lines.onClosed = () {
      stream.close();
    };
  }
}

void _processFiles(rootDir, file, pattern) {
  var path = new Path.fromNative(rootDir);
  var dir = new Directory.fromPath(path.directoryPath);
  var lister = dir.list(recursive:true);
  lister.onFile = (name) {
    _processFile(name, file, pattern);
  };
}

ArgParser get _pubArgParser {
  var parser = new ArgParser();
  parser.addFlag('help', abbr: 'h', negatable: false,
    help: 'Prints this usage information');
  parser.addOption('file', abbr: 'f',
      help: 'Sets the regular expression for file names to match');
  parser.addOption('path', abbr: 'p',
    help: 'Sets the current path to parse for invalid comments');
  parser.addOption('regex', abbr: 'r',
      help: 'Sets the regular expression for lines in each file to match');
  return parser;
}

void main() {
  var globalOptions;
  try {
    globalOptions = _pubArgParser.parse(new Options().arguments);
  } on FormatException catch (e) {
    return;
  }
  if (globalOptions['path'] != null) {
    // By default match every line.
    var pattern = new RegExp('');
    if (globalOptions['regex'] != null) {
      pattern = new RegExp(globalOptions['regex']);
    }
    // By default match every file.
    var file =  new RegExp('');
    if (globalOptions['file'] != null) {
      file = new RegExp(globalOptions['file']);
    }
    _processFiles(globalOptions['path'], file, pattern);
    return;
  } else {
    print('Missing path argument.');
  }
}
