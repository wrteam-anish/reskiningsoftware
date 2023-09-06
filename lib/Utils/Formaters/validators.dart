class Validators {
  static Map<String, String? Function(dynamic value)> _checkValidator() {
    return {
      "required": required_,
      "noDot": noDot,
      "noSpace": noSpace,
      "noChars": noChars,
      "packageValidator": packageNameChecker,
      "url": url
    };
  }

  static List getValidator(Set validatorSet) {
    List list = [];
    _checkValidator().entries.forEach((element) {
      if (validatorSet.contains(element.key)) {
        list.add(element.value);
      }
    });
    return list;
  }

  static String? packageNameChecker(value) {
    RegExp pattern =
        RegExp(r"^([A-Za-z]{1}[A-Za-z\d_]*\.)+[A-Za-z][A-Za-z\d_]*$");

    bool hasMatch = pattern.hasMatch(value);
    if (hasMatch) {
      return null;
    } else {
      return "Please enter valid package name";
    }
  }

  static String? url(value) {
    RegExp pattern = RegExp(
        r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)");

    bool valid = pattern.hasMatch(value);
    if (valid) {
      return null;
    } else {
      return "Please enter valid URL";
    }
  }

  static String? required_(value) {
    if (value.isEmpty) {
      return "Please fill this field";
    } else {
      return null;
    }
  }

  static String? noChars(value) {
    String alphab = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    for (var i = 0; i < value.length;) {
      if (alphab.contains(value[i].toString().toUpperCase())) {
        return "Charectors are not valid";
      } else {
        return null;
      }
    }
    return null;
  }

  static String? startWith(value) {
    return null;
  }

  static String? noDot(value) {
    return value.contains(".") ? "Period is not valid" : null;
  }

  static String? noSpace(value) {
    if (value.contains(" ")) {
      return "Space is not valid";
    } else {
      return null;
    }
  }
}
