class ApiPath {
  // static const String domain = 'http://localhost:3000/api/';
  static const String domain = 'http://192.168.60.101:3000/api/';
  // static const String domain = 'http://192.168.1.53:3000/api/';
  // static const String domain = 'https://backend-doantotnghiep-1.onrender.com/api';
  static const String domainImage = 'https://tht.nanoweb.vn/';
  static const String domainVideo = 'https://tht.nanoweb.vn/';
  static const String key = 'key_nanoweb_v2_2021_real';
  static const String startApp = '/api/home/start';

  //auth 
  static const String login = '/users/login';
  static const String register = '/users/reg';
  static const String logout = '/users/logout';
  static const String sendEmail = '/check/sendOtp';
  static const String sendOtp = '/check/checkOTP';
  static const String reserPassword = '/check/reset-password';
  static const String changPassword = '/users/change-password';
  static const String editInformation = '/users/edit/';
  static const String deleteOtp = '/users/deleteOTP/';

  //product
  static const String shoesAdd = '/products/add';
  static const String shoesDetail = '/shoes/';
  static const String shoesList = '/shoes/list';
  static const String shoesTopSelling = '/shoes/top-selling';
  static const String shoesEdit = '/products/edit/';
  static const String shoesDelete = '/products/delete';
  static const String shoesSearch = '/products/list';

  // cart
  static const String cartAdd = '/carts/add';
  static const String cartList = '/carts/list';
  static const String cartUpdate = '/carts/update';
  static const String cartDelete = '/carts/delete';

  //category
  static const String flashSale = '/flash-sale';
  static const String prdFlashSale = '/flash-sale/product/';
  static const String brandList = '/brand/list';
  static const String brandAdd = '/brand/add';
  static const String brandEdit = '/brand/edit';
  static const String brandDelete = '/brand/delete';

  //news and banner
  // static const String news = '/news';
  static const String news = '/news';
  static const String banner = '/banner/list';

  //location
  static const provinces = '/address/province';
  static const district = '/address/district?province_id=';
  static const ward = '/address/ward?district_id=';
  static const gps = '/positioning-gps';


  //deeplinks
  static const deepLinksAndroid =
      "https://api.vietqr.io/v2/android-app-deeplinks";

  static const deepLinksIos = "https://api.vietqr.io/v2/ios-app-deeplinks";
}
