import 'package:drag_drop_puzzle/utils/icon_downloader.dart';

void main() async {
  print('Starting icon download...');
  await IconDownloader.downloadIcons();
  print('Icon download completed!');
} 