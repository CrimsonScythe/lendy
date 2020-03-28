import 'dart:async';
import 'dart:io';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Please enter a valid email address.');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5) {
      sink.add(password);
    } else {
      sink.addError('Password is too short.');
    }
  });

  final validatePasswordRetype = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5) {
      sink.add(password);
    } else {
      sink.addError('Password is too short.');
    }
  });

  final validateTitle =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (title.length > 0) {
      sink.add(title);
    } else {
      sink.addError('Title cannot be empty');
    }

    // for error:
  });

  final validateDes =
      StreamTransformer<String, String>.fromHandlers(handleData: (des, sink) {
    //TODO: handle the case where there is a new line

    if (des.length > 0) {
      sink.add(des);
    } else {
      sink.addError('Description cannot be empty');
    }

    //for error:
  });

  final validatePic =
      StreamTransformer<File, File>.fromHandlers(handleData: (des, sink) {
    if (!des.existsSync()) {
      sink.addError('Error reading file');
    } else {
      sink.add(des);
    }
    //for error:
  });

  final validatePicList =
      StreamTransformer<List<File>, List<File>>.fromHandlers(
          handleData: (des, sink) {
    if (des == null || des.length == 0) {
      sink.addError('Please attach a picture');
    } else {
      sink.add(des);
    }
  });

  final validateDrop =
      StreamTransformer<String, String>.fromHandlers(handleData: (drop, sink) {
    sink.add(drop);
  });

  final validateDaily =
  StreamTransformer<String, String>.fromHandlers(handleData: (val, sink) {
    if (true) {
      sink.add(val);
    } else {
      sink.addError('Title cannot be empty');
    }
//    var mod = val;
//    var reg = new RegExp(r'[0-9]');
//    if (reg.hasMatch(val)) {
//      int num = int.parse(mod.replaceAll(new RegExp(r"[A-Z]|[,.]|[\s]"), ''));
//      if (num <= 99) {
//        print('all good');
//        sink.add(val);
//      } else {
//        sink.addError('Title cannot be empty');
//      }
//    }

  });

  final validateWeekly =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (true) {
      sink.add(title);
    } else {
      sink.addError('Title cannot be empty');
    }
  });

  final validateMonthly =
      StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (true) {
      sink.add(title);
    } else {
      sink.addError('Title cannot be empty');
    }
  });

  final validateDeposit =
  StreamTransformer<String, String>.fromHandlers(handleData: (title, sink) {
    if (true) {
      sink.add(title);
    } else {
      sink.addError('Title cannot be empty');
    }
  });
}
