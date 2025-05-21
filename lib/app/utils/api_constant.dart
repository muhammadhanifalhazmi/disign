abstract class API {
  API._();


  // static const BASE_URL = "http://127.0.0.1:8000/api/";
  static const BASE_URL = "http://192.168.1.3:8000/api/";
  // static const BASE_URL = "https://api.irfams.my.id/api/";

  static const TEST = "${BASE_URL}test";
  static const REGISTER_USER = "${BASE_URL}register";
  static const LOGIN = "${BASE_URL}login";
  static const LOGOUT = "${BASE_URL}logout";
  static const USER_DETAILS = "${BASE_URL}user/";
  static const CSR = "${BASE_URL}csr";
  static const DEVICES = "${BASE_URL}user/devices";
  static const REGISTER_DEVICE = "${BASE_URL}device";
  static const IS_CERT_VALID = "${BASE_URL}isvalid";
  static const REQUEST_REVOKE = "${BASE_URL}revoke";
  static const PIN_AUTH = "${BASE_URL}auth";
}