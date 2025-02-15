import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.camera, color: Colors.black), 
              ),
              title: const Text(
                'app.name',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    //number of hours / max number of hours in this day
                    value: 6 / 8,
                    backgroundColor: Colors.grey.shade800,//Color.fromARGB(0, 66, 66, 66), 
                    valueColor:const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 23, 139, 241)),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '6hrs',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            );
  }
}