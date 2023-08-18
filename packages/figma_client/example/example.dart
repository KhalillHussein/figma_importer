import 'package:figma_client/figma_client.dart';

void main() async {
  const token = 'some_token';

  final client = FigmaClient(token);
  // ignore: avoid_print
  await client.getFile('some_file_key').then((res) => print(res.version));
}
