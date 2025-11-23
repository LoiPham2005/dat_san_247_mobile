// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_dev.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env.dev
final class _EnvDev {
  static const String apiBaseUrl = 'https://dev-api.yourapp.com';

  static const String wsUrl = 'wss://ws-dev.yourapp.com';

  static const bool enableLogging = true;

  static const bool enableDebugTools = true;

  static const bool enableAnalytics = false;

  static const int connectTimeout = 60;

  static const int receiveTimeout = 60;

  static const List<int> _enviedkeygoogleMapsApiKey = <int>[
    2803580310,
    3791547223,
    3863889490,
    23292989,
    966666803,
    2504839116,
    3178374635,
    1148752631,
    4055255363,
    2857704383,
    3410772824,
    2272651009,
    2455462412,
    322128919,
    2163709554,
    870205615,
    3346758527,
    3081957696,
  ];

  static const List<int> _envieddatagoogleMapsApiKey = <int>[
    2803580375,
    3791547166,
    3863889448,
    23293020,
    966666848,
    2504839093,
    3178374575,
    1148752530,
    4055255349,
    2857704416,
    3410772755,
    2272651108,
    2455462517,
    322128968,
    2163709498,
    870205642,
    3346758413,
    3081957669,
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
    1349541284,
    2951919556,
    2204683193,
    214541583,
    1040552225,
    2048348603,
    2011970234,
    1607694358,
    2969765025,
    721602771,
    1376817006,
    3186373793,
    1080590875,
    472329762,
    2339352653,
  ];

  static const List<int> _envieddatastripePublicKey = <int>[
    1349541332,
    2951919535,
    2204683238,
    214541691,
    1040552260,
    2048348616,
    2011970254,
    1607694409,
    2969765061,
    721602742,
    1376816920,
    3186373886,
    1080590960,
    472329799,
    2339352628,
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
