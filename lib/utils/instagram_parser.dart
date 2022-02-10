String instagramUrlParser(String url) {
  final urlSplit = url.split("/");
  final length = urlSplit.length;

  final last = urlSplit[length - 1];

  if (last == "" || last[0] == "?") return urlSplit[length - 2];

  return urlSplit[length - 1];
}
