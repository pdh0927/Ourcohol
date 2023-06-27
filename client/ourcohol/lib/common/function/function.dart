String getBaseURl(String fullUrl) {
  // Uri.parse를 사용하여 URL을 파싱
  Uri uri = Uri.parse(fullUrl);

  // Uri의 scheme, authority, path를 사용하여 기본 URL 부분만 재구성
  String baseUrl = "${uri.scheme}://${uri.authority}${uri.path}";

  return baseUrl;
}
