import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import 'package:fluent_picacg/utils/dio_network_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final networkService = DioNetworkService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            child: Text('网络请求'),
            onPressed: () async {
              try {
                final response = await networkService.get('collections');
                debugPrint('Response: ${response.data}');
              } catch (e) {
                debugPrint('Error: $e');
              }
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
