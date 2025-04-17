import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
