/*import 'package:flutter/material.dart';

class MyTable extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {

    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(80),
        1: FixedColumnWidth(40),
        2: FixedColumnWidth(40),
        3: FixedColumnWidth(60),
        4: FixedColumnWidth(80),
      },
      children: <TableRow>[
        TableRow( // Header row
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: <Widget>[
            Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Nos', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Kg', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Rate', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
          ]
        ),
        
        TableRow( // Row 1
          children: <Widget>[ 
            Text('1 Jan 2023'),
            Text('5'),
            Text('2.5'),
            Text('10'),
            Text('25'),
          ]  
        ),

        TableRow( // Last row
          children: <Widget>[
            MergeableMaterial(
              child: TableCell(
                child: Center(
                  child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)) 
                )
              )
            ),
            TableCell(), // Empty cell
          ]
        )
      ],
    );
  }
}*/
/*
DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Date',
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Nos'),
                    ),
                    DataColumn(label: Text('Kg')),
                    DataColumn(label: Text('Rate')),
                    DataColumn(label: Text('Amount'))
                  ],
                  rows: List.generate(
                    getEntries.length + 1,
                    (index) {
                      if (index < getEntries.length) {
                        return DataRow(cells: [
                          DataCell(Text(getEntries[index]["Date"])),
                          DataCell(Text(getEntries[index]["Nos"])),
                          DataCell(Text(getEntries[index]["Weight"])),
                          DataCell(Text(getEntries[index]["Rate"])),
                          DataCell(Text(getEntries[index]["Total"])),
                        ]);
                      } else {
                        return DataRow(cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text("$total"))
                        ]);
                      }
                    },
                  )),*/

            /*       */