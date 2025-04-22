import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import 'package:fluent_picacg/utils/api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            child: Text('获取推荐'),
            onPressed: () async {
              final response = await apiService.getCollections();
              debugPrint('网络请求结果: ${response.data}');
            },
          ),
          Button(
            child: Text('查看详情'),
            onPressed: () {
              GoRouter.of(context).pushNamed('homepage.details');
            },
          ),
        ],
      ),
    );
  }
}
