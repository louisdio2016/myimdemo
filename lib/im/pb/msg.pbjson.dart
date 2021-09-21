///
//  Generated code. Do not modify.
//  source: msg.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use msgDescriptor instead')
const Msg$json = const {
  '1': 'Msg',
  '2': const [
    const {'1': 'head', '3': 1, '4': 1, '5': 11, '6': '.Head', '10': 'head'},
    const {'1': 'body', '3': 2, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `Msg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgDescriptor = $convert.base64Decode('CgNNc2cSGQoEaGVhZBgBIAEoCzIFLkhlYWRSBGhlYWQSEgoEYm9keRgCIAEoCVIEYm9keQ==');
@$core.Deprecated('Use headDescriptor instead')
const Head$json = const {
  '1': 'Head',
  '2': const [
    const {'1': 'msgId', '3': 1, '4': 1, '5': 9, '10': 'msgId'},
    const {'1': 'msgType', '3': 2, '4': 1, '5': 5, '10': 'msgType'},
    const {'1': 'msgContentType', '3': 3, '4': 1, '5': 5, '10': 'msgContentType'},
    const {'1': 'fromId', '3': 4, '4': 1, '5': 9, '10': 'fromId'},
    const {'1': 'toId', '3': 5, '4': 1, '5': 9, '10': 'toId'},
    const {'1': 'timestamp', '3': 6, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'statusReport', '3': 7, '4': 1, '5': 5, '10': 'statusReport'},
    const {'1': 'extend', '3': 8, '4': 1, '5': 9, '10': 'extend'},
  ],
};

/// Descriptor for `Head`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List headDescriptor = $convert.base64Decode('CgRIZWFkEhQKBW1zZ0lkGAEgASgJUgVtc2dJZBIYCgdtc2dUeXBlGAIgASgFUgdtc2dUeXBlEiYKDm1zZ0NvbnRlbnRUeXBlGAMgASgFUg5tc2dDb250ZW50VHlwZRIWCgZmcm9tSWQYBCABKAlSBmZyb21JZBISCgR0b0lkGAUgASgJUgR0b0lkEhwKCXRpbWVzdGFtcBgGIAEoA1IJdGltZXN0YW1wEiIKDHN0YXR1c1JlcG9ydBgHIAEoBVIMc3RhdHVzUmVwb3J0EhYKBmV4dGVuZBgIIAEoCVIGZXh0ZW5k');
