String instagramUrlParser(String value) {
  return value.split('/')[4];
}

String instagramProfileParser(String value) {
  return value.split('/')[3].split('?')[0];
}
