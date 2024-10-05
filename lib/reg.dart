import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:machine_text/userlist.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isloading = false;

  Future<void> _register() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isloading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://reqres.in/api/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isloading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registered successfully! Token: ${data['token']}')),
        );
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['error']}')),
        );
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Register',style: TextStyle(
          fontSize: 20,fontWeight: FontWeight.bold
        ),),centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Name',
                hintText: 'enter your name'
              ),
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'email',
                hintText: 'enter your email',
              ),
              validator: (value){
                if(value == null || value.isEmpty || !value.contains('@')){
                  return "enter email correctly";
                }
                return null;
              },
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
                hintText: 'enter the password'
              ),
              validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password contain 8 characters';
                  }
                  return null;
                },
            ),
            _isloading ? CircularProgressIndicator(): ElevatedButton(onPressed: () {
              _register();
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserList(),));
            }, child: Text('Submit'))
        
          ],
        ),
      ),
    );
  }
}

