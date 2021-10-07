class InstagramParser {
  static String postUrl(String value) {
    return value.split('/')[4];
  }

  static String profileUrl(String value) {
    return value.split('/')[3].split('?')[0];
  }
}
