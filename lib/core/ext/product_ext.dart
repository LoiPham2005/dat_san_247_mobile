// import 'package:snakeup_app/features/product/data/models/product_model.dart';

// extension ShoesMediaExtension on Shoes {
//   /// Trả về URL ảnh đầu tiên trong danh sách media (nếu có)
//   String? get firstImageUrl {
//     return media?.firstWhere(
//       (m) => m.type == 'image',
//       orElse: () => Media(url: '', type: 'image'),
//     ).url;
//   }

//   /// Trả về danh sách tất cả ảnh (loại 'image')
//   List<Media> get allImages {
//     return media?.where((m) => m.type == 'image').toList() ?? [];
//   }

//   /// Trả về danh sách tất cả video (loại 'video')
//   List<Media> get allVideos {
//     return media?.where((m) => m.type == 'video').toList() ?? [];
//   }
// }
