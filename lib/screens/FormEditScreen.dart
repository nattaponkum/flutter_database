import 'package:flutter/material.dart';
import 'package:flutter_database/models/TransactionItem.dart';
import 'package:flutter_database/providers/TransactionProvider.dart';
import 'package:provider/provider.dart';

class FormEditScreen extends StatefulWidget {
  final TransactionItem data;
  const FormEditScreen({super.key, required this.data});

  @override
  State<FormEditScreen> createState() => _FormEditScreenState();
}

class _FormEditScreenState extends State<FormEditScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState(){
    super.initState();
    titleController.text = widget.data.title.toString();
    amountController.text = widget.data.amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Edit Item"),
        
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
                  TransactionItem transaction = TransactionItem(id: widget.data.id, title: titleController.text, amount: double.parse(amountController.text), date: DateTime.now().toIso8601String());
                  print("${transaction.title} ${transaction.amount} ${transaction.date}");

                  //ส่งข้อมูลให้ provider
                  var provider = Provider.of<TransactionProvider>(context, listen: false);
                  provider.updateTransaction(transaction);

                  Navigator.pop(context);
                }
              }, 
              child: Text("แก้ไขข้อมูล", style: TextStyle(color: const Color.fromARGB(255, 245, 10, 10)),),
              
            )
          ],
        ),
      ),
      );
  }
}