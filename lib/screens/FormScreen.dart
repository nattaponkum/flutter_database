import 'package:flutter/material.dart';
import 'package:flutter_database/models/TransactionItem.dart';
import 'package:flutter_database/providers/TransactionProvider.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Input"),
        
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text("ชื่อรายการ")),
              autofocus: true,
              validator: (str) {
                if(str!.isEmpty){
                  return "กรุณาใส่ชื่อรายการ";
                }
                return null;
              },
              controller: titleController,
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text("จำนวนเงิน")),
              keyboardType: TextInputType.number,
              validator: (value) {
                try{
                  if(value!.isNotEmpty){
                    if(double.parse(value) >= 0){
                      return null;
                    }
                  }throw();
                }catch(e){
                  return "กรุณาใส่จำนวนเงิน";
                }
              },
              controller: amountController,
            ),
            TextButton(
              onPressed: (){
                if(formKey.currentState!.validate()){


                  //สร้าง ข้อมูล สำหรับ provider
                  TransactionItem transaction = TransactionItem(title: titleController.text, amount: double.parse(amountController.text), date: DateTime.now().toIso8601String());
                  print("${transaction.title} ${transaction.amount} ${transaction.date}");

                  //ส่งข้อมูลให้ provider
                  var provider = Provider.of<TransactionProvider>(context, listen: false);
                  provider.addTransaction(transaction);

                  Navigator.pop(context);
                }
              }, 
              child: Text("เพิ่มข้อมูล", style: TextStyle(color: const Color.fromARGB(255, 245, 10, 10)),),
              
            )
          ],
        ),
      ),
      );
  }
}