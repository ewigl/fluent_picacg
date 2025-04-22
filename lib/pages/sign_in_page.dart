import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import 'package:fluent_picacg/utils/api_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await ApiService().signIn(username: username, password: password);

      if (!mounted) return;

      displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text('登录成功！'),
            severity: InfoBarSeverity.success,
          );
        },
      );

      context.go('/homepage');
    } catch (e) {
      if (!mounted) return;

      displayInfoBar(
        context,
        builder: (context, close) {
          return InfoBar(
            title: Text(e.toString()),
            severity: InfoBarSeverity.error,
            action: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: close,
            ),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(title: Text('登录')),
      content: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormBox(
                  controller: _usernameController,
                  placeholder: '用户名',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? '请输入用户名' : null,
                ),
                SizedBox(height: 16),
                PasswordFormBox(
                  revealMode: PasswordRevealMode.peekAlways,
                  controller: _passwordController,
                  placeholder: '密码',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? '请输入密码' : null,
                  onFieldSubmitted: (_) => _signIn(),
                ),
                SizedBox(height: 16),
                _isLoading
                    ? ProgressRing()
                    : FilledButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: const Text('登录'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
