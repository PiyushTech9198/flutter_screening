import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_bloc.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadUsers();
  }

  void _loadUsers() {
    context.read<UserBloc>().add(const GetUsersEvent(1));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<UserBloc>().add(FetchMoreUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('User List')),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading && (state is UserInitial)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount:
                  state.users.length + ((state.hasReachedMax ?? false) ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == state.users.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = state.users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  title: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(user.avatar),
                        ),
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.black54),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailPage(userId: user.id),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  tileColor: Colors.white,
                );
              },
            );
          } else if (state is UserError) {
            return Center(
                child: Text('Failed to load users: ${state.message}'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
