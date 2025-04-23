import 'package:drag_drop_puzzle/utils/image_downloader.dart';

void main() async {
  print('Starting image download...');
  await ImageDownloader.downloadImages();
  print('Image download completed!');
} 