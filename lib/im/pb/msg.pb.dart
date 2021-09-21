///
//  Generated code. Do not modify.
//  source: msg.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Msg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Msg', createEmptyInstance: create)
    ..aOM<Head>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'head', subBuilder: Head.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'body')
    ..hasRequiredFields = false
  ;

  Msg._() : super();
  factory Msg({
    Head? head,
    $core.String? body,
  }) {
    final _result = create();
    if (head != null) {
      _result.head = head;
    }
    if (body != null) {
      _result.body = body;
    }
    return _result;
  }
  factory Msg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Msg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Msg clone() => Msg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Msg copyWith(void Function(Msg) updates) => super.copyWith((message) => updates(message as Msg)) as Msg; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Msg create() => Msg._();
  Msg createEmptyInstance() => create();
  static $pb.PbList<Msg> createRepeated() => $pb.PbList<Msg>();
  @$core.pragma('dart2js:noInline')
  static Msg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Msg>(create);
  static Msg? _defaultInstance;

  @$pb.TagNumber(1)
  Head get head => $_getN(0);
  @$pb.TagNumber(1)
  set head(Head v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearHead() => clearField(1);
  @$pb.TagNumber(1)
  Head ensureHead() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get body => $_getSZ(1);
  @$pb.TagNumber(2)
  set body($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => clearField(2);
}

class Head extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Head', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgId', protoName: 'msgId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgType', $pb.PbFieldType.O3, protoName: 'msgType')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgContentType', $pb.PbFieldType.O3, protoName: 'msgContentType')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fromId', protoName: 'fromId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'toId', protoName: 'toId')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'statusReport', $pb.PbFieldType.O3, protoName: 'statusReport')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extend')
    ..hasRequiredFields = false
  ;

  Head._() : super();
  factory Head({
    $core.String? msgId,
    $core.int? msgType,
    $core.int? msgContentType,
    $core.String? fromId,
    $core.String? toId,
    $fixnum.Int64? timestamp,
    $core.int? statusReport,
    $core.String? extend,
  }) {
    final _result = create();
    if (msgId != null) {
      _result.msgId = msgId;
    }
    if (msgType != null) {
      _result.msgType = msgType;
    }
    if (msgContentType != null) {
      _result.msgContentType = msgContentType;
    }
    if (fromId != null) {
      _result.fromId = fromId;
    }
    if (toId != null) {
      _result.toId = toId;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (statusReport != null) {
      _result.statusReport = statusReport;
    }
    if (extend != null) {
      _result.extend = extend;
    }
    return _result;
  }
  factory Head.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Head.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Head clone() => Head()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Head copyWith(void Function(Head) updates) => super.copyWith((message) => updates(message as Head)) as Head; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Head create() => Head._();
  Head createEmptyInstance() => create();
  static $pb.PbList<Head> createRepeated() => $pb.PbList<Head>();
  @$core.pragma('dart2js:noInline')
  static Head getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Head>(create);
  static Head? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msgId => $_getSZ(0);
  @$pb.TagNumber(1)
  set msgId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsgId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get msgType => $_getIZ(1);
  @$pb.TagNumber(2)
  set msgType($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsgType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsgType() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get msgContentType => $_getIZ(2);
  @$pb.TagNumber(3)
  set msgContentType($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMsgContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsgContentType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get fromId => $_getSZ(3);
  @$pb.TagNumber(4)
  set fromId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFromId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get toId => $_getSZ(4);
  @$pb.TagNumber(5)
  set toId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasToId() => $_has(4);
  @$pb.TagNumber(5)
  void clearToId() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get statusReport => $_getIZ(6);
  @$pb.TagNumber(7)
  set statusReport($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStatusReport() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatusReport() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get extend => $_getSZ(7);
  @$pb.TagNumber(8)
  set extend($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasExtend() => $_has(7);
  @$pb.TagNumber(8)
  void clearExtend() => clearField(8);
}

