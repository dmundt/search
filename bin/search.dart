// Copyright (c) 2012, Daniel Schubert.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// --path "d:/p4/omega/Baugruppen/VPU3400/Software/branches/unified-refactoring/apps/rtools/"
// --path "d:/test/"

//const _PARSE_FILE_REGEX = const RegExp(r'(\.h|\.cpp)$');
//const _PARSE_COMMENT_REGEX = const RegExp(r'\w*\s*//\s*[a-z]+');

library comments;

import 'package:args/args.dart';
import 'dart:io';

Future<List<String>> _filterLine(lines, pattern) {
  var completer = new Completer<List<String>>();
  var number = 0;
  var result = <String>[];
  var line;
  while ((line = lines.readLine()) != null) {
    ++number;
    if (line.contains(pattern)) {
      result.add("${number}: $line");
    }
  }
  completer.complete(result);
  return completer.future;
}

void _proccesLines(name, lines, pattern) {
  _filterLine(lines, pattern).then((comments) {
    if (comments.length > 0) {
      print("File: $name");
      for (final x in comments) {
        print(x);
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

void _processFiles(String rootDir, RegExp file, RegExp pattern) {
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
