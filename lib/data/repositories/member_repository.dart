import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/member_model.dart';

class MemberRepository {
  Future<Member> getMember(int id) async {
    final String response = await rootBundle.loadString('assets/list_members.json');
    final List<dynamic> data = json.decode(response);
    final member = data.firstWhere((member) => member['idPersona'] == id);
    return Member.fromJson(member);
  }
}