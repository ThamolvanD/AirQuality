import 'package:flutter/material.dart';

class Week3 extends StatelessWidget {
  const Week3({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Student Profile"),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/profile.jpg', 
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "ธมลวรรณ ดีเสมอ", // ชื่อ-นามสกุล
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "640710138", // รหัสนักศึกษา
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                const Text(
                  "วิทยาการคอมพิวเตอร์", // สาขาวิชา
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                const Text(
                  "“เรียนรู้สิ่งใหม่ทุกวัน เพื่อพัฒนาตัวเอง!”", // คำโปรย
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}