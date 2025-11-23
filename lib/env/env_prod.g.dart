// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_prod.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.prod
final class _EnvProd {
  static const String apiBaseUrl = 'https://api.yourapp.com';

  static const String wsUrl = 'wss://ws.yourapp.com';

  static const bool enableLogging = false;

  static const bool enableDebugTools = false;

  static const bool enableAnalytics = true;

  static const int connectTimeout = 30;

  static const int receiveTimeout = 30;

  static const List<int> _enviedkeygoogleMapsApiKey = <int>[
    2446736171,
    1507965160,
    2519211623,
    3766450101,
    84976578,
    2825142956,
    491771506,
    1278036009,
    2356596447,
    1810532517,
    3500708155,
    2518035878,
    2853708147,
    4099359168,
    1457496056,
    1108712134,
    1340137862,
    2587747198,
    1280371132,
  ];

  static const List<int> _envieddatagoogleMapsApiKey = <int>[
    2446736234,
    1507965089,
    2519211549,
    3766450132,
    84976529,
    2825142997,
    491771426,
    1278036059,
    2356596400,
    1810532545,
    3500708196,
    2518035949,
    2853708054,
    4099359161,
    1457495975,
    1108712078,
    1340137955,
    2587747084,
    1280371161,
  ];

  static final String googleMapsApiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddatagoogleMapsApiKey.length,
      (int i) => i,
      growable: false,
    ).map(
      (int i) => _envieddatagoogleMapsApiKey[i] ^ _enviedkeygoogleMapsApiKey[i],
    ),
  );

  static const List<int> _enviedkeystripePublicKey = <int>[
    24414173,
    367522423,
    1911595224,
    734629119,
    3083221119,
    2136011174,
    4080595632,
    715635261,
    2021036556,
    3613854896,
    1396619711,
    173699271,
    4251086835,
    109001336,
    1357717527,
    300024045,
  ];

  static const List<int> _envieddatastripePublicKey = <int>[
    24414125,
    367522332,
    1911595143,
    734629011,
    3083221014,
    2136011216,
    4080595669,
    715635298,
    2021036668,
    3613854914,
    1396619728,
    173699235,
    4251086764,
    109001235,
    1357717618,
    300023956,
  ];

  static final String stripePublicKey = String.fromCharCodes(
    List<int>.generate(
      _envieddatastripePublicKey.length,
      (int i) => i,
      growable: false,
    ).map(
      (int i) => _envieddatastripePublicKey[i] ^ _enviedkeystripePublicKey[i],
    ),
  );
}
