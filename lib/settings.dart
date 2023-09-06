class Settings {
  static String templateFilePath =
      "assets/template_t.zip"; //No dot in file name only for extention
  static String archiveFileName =
      templateFilePath.split("/").last.split(".").first;
  static String selfFolderName = "template_t";

  static List<String> allowedReplaceExtentions = [
    "dart",
    "json",
    "gradle",
    "xml",
    "kt",
    "yaml",
    "xcconfig",
    "plist",
    "pbxproj",
    "txt"
  ];
  static List<String> ignoreContentReplacement = ["demo.json"];

  ///This will be served as File Replacement not content
  static const List<String> imageExt = [
    "JPEG",
    "PNG",
    "GIF",
    "WebP",
    "BMP",
    "WBMP"
  ]; //UPPER CASE

  static String generatedFileName = "appGen";
//Add any field here
  static List fields = [
    {
      "fieldName": "App name",
      "fieldPattern": "className",
      "type": "text",
      "keyboard": "number",
      "hint": "My app",
      "maxDot": 3,
      "validator": {
        // "required",
        // "noSpace",
      }
    },
    {
      "fieldName": "Package name",
      "fieldPattern": "packageName",
      "hint": "com.example.wrteam",
      "info": "Please set data like given in hint",
      "type": "text",
      "validator": {
        // "required",
        "noSpace",
        // "packageValidator",
      }
    },
    {
      "fieldName": "App Version",
      "fieldPattern": "appVersion",
      "type": "text",
      "hint": "1.0.0+1",
      "maxDot": 3,
      "validator": {
        // "required",
        "noSpace",
        // "noChars",
      }
    },
    {
      "fieldName": "Host URL",
      "fieldPattern": "hostURL",
      "type": "text",
      "hint": "https://example.com",
      "validator": {
        // "required",
        "noSpace",
        // "url",
      },
    },
    {
      "fieldName": "Deep link prefix",
      "fieldPattern": "deepLinkPrefix",
      "type": "text",
      "hint": "example.page.link",
      "validator": {
        // "required",
        "noSpace",
      }
    },
    {
      "fieldName": "Google Place API key",
      "fieldPattern": "googlePlaceAPIKey",
      "type": "text",
      "hint": "**********",
      "validator": {
        // "required",
        "noSpace",
      }
    },
    {
      "fieldName": "Android Google Map API Key",
      "fieldPattern": "andgoogleMapApiKey",
      "type": "text",
      "hint": "**********",
      "validator": {
        // "required",
        "noSpace",
      }
    },
    {
      "fieldName": "IOS Google Map API Key",
      "fieldPattern": "iosgoogleMapApiKey",
      "type": "text",
      "hint": "**********",
      "validator": {
        // "required",
        "noSpace",
      }
    },
    {
      "fieldName": "App icon AA",
      "fieldPattern": "icLauncerHDPI",
      "fileName": "demo.png",
      "type": "image",
      // 'required':true
    },
    [
      {
        "group": "row",
        "name": "Theme colors",
      },
      {
        "fieldName": "TeritoryColor",
        "fieldPattern": "teritoryColor",
        "initVal": "0xFF087C7C",
        "type": "color",
        "validator": {
          "required",
        }
      },
      {
        "fieldName": "Primary Color",
        "fieldPattern": "primaryColor",
        "initVal": "0xFFFAFAFA",
        "type": "color",
        "validator": {
          "required",
        }
      },
      {
        "fieldName": "Secondary Color",
        "fieldPattern": "secondaryColor",
        "initVal": "0xFFFFFFFF",
        "type": "color",
        "validator": {
          "required",
        }
      },
      {
        "fieldName": "Primary Color Dark",
        "fieldPattern": "primaryColorDark",
        "initVal": "0xff3B424C",
        "type": "color",
        "validator": {
          "required",
        }
      },
      {
        "fieldName": "Secondary Color Dark",
        "fieldPattern": "secondaryColorDark",
        "initVal": "0xff282F39",
        "type": "color",
        "validator": {
          "required",
        }
      },
      {
        "fieldName": "Teritory Color Dark",
        "fieldPattern": "teritoryColorDark",
        "initVal": "0xff53ADAE",
        "type": "color",
        "validator": {
          "required",
        }
      },
    ],
    {
      "fieldName": "Google Services JSON",
      "fieldPattern": "icLauncerXHDPI",
      "fileName": "demo.json",
      "type": "file",
    }
  ];
}
