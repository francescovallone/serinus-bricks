import 'dart:convert';
import 'package:http/http.dart';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  context.logger.info('Parsing project name...');
  String name = context.vars['name'];
  context.vars['name'] = parseName(name);
  context.logger.success('Project name parsed to ${context.vars['name']}');
  context.logger.info('Fetching latest version of serinus package...');
  try{
    context.vars['serinus_version'] = await getSerinusVersion();
  }catch(e){
    context.logger.err('Failed to fetch latest version of serinus package');
    rethrow;
  }
  context.logger.success('Serinus latest version fetched correctly');
}

String parseName(String name) {
  if(name.contains(' ')){
    return name.split(' ').join('_');
  }
  if(name.contains('-')){
    return name.split('-').join('_');
  }
  return name.toLowerCase();
}

Future<String> getSerinusVersion() async {
  final client = Client();
  final res = await client.get(Uri.parse('https://pub.dev/api/packages/serinus'));
  if(res.statusCode != 200){
    throw Exception('Failed to fetch serinus package');
  }
  final body = res.body;
  final package = jsonDecode(body);
  final version = package['latest']['version'];
  return version;
}
