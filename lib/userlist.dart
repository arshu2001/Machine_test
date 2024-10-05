import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
 
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  
  List<dynamic> _user = [];
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    _fetchUser();
  }  
  Future<void> _fetchUser()async{
    final responce = await http.get(Uri.parse('https://reqres.in/api/users?page=1'));

    if(responce.statusCode == 200){
      final data = json.decode(responce.body);
      log(responce.body);
      setState(() {
        _user = data['data'];
        _isloading = false;
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch')),
      );
      setState(() {
        _isloading = false;
      });
    }
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('User List',style: TextStyle(
          fontSize: 20,fontWeight: FontWeight.bold
        ),),centerTitle: true,
      ),
      body:_isloading ? const Center(
        child: CircularProgressIndicator())
        : ListView.builder(
        itemCount: _user.length,
        itemBuilder: (context, index) {
        final user = _user[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user['avatar'] != null 
            ? NetworkImage(user['avatar'])
            :AssetImage('assets/images/default_avatar.png')
          ),
          title: Text('${user['first_name']} ${user['last_name']}'),
          // title: Text('${user['first_name']}'),
          subtitle: Text(user['email']?? 'no email available'),
          
        );
      },),
    );
  }
}