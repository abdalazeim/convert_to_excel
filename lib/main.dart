// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row;

// Local import
import 'helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'helper/save_file_web.dart' as helper;

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Students> students = <Students>[];
  late  StudentsDataGridSource studentsDataGridSource;


  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    super.initState();
    students = getStudentsData();
    studentsDataGridSource = StudentsDataGridSource(studentsData: students);
  }

  Future<void> exportDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Students Flutter DataGrid Export')),
        body: Column(children: <Widget>[
          Container(
              margin: const EdgeInsets.all(12.0),
              child: Row(children: <Widget>[
                SizedBox(
                    height: 40.0,
                    width: 150.0,
                    child: MaterialButton(
                        color: Colors.blue,
                        child: const Center(
                            child: Text('Export to Excel',
                                style: TextStyle(color: Colors.white))),
                        onPressed: exportDataGridToExcel))
              ])),
          Expanded(
              child: SfDataGrid(
                  key: _key,
                  source: studentsDataGridSource,
                  columns: <GridColumn>[
                GridColumn(
                    columnName: 'ID',
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text('ID'))),
                GridColumn(
                    columnName: 'Name',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Name'))),
                GridColumn(
                    columnName: 'birthdate',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('birthdate',
                            overflow: TextOverflow.ellipsis))),
                GridColumn(
                    columnName: 'personalId',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('personalId')))
              ]))
        ]));
  }

  List<Students> getStudentsData() {
    return <Students>[

      Students(10001, 'abd', 'Project Lead', 20000),
      Students(10002, 'ss', 'Manager', 30000),
      Students(10003, 'ss', 'Developer', 15000),
      Students(10004, 'Misschael', 'Designer', 15000),
      Students(10005, 'ss', 'Developer', 15000),
      Students(10006, 'sss', 'Developer', 15000),
      Students(10007, 'Bajjjlnc', 'Developer', 15000),
      Students(10008, 'hhh', 'Developer', 15000),
      Students(10009, 'Gakkkble', 'Developer', 15000),
      Students(10010, 'Grikkkmes', 'Developer', 15000)
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the Students which will be rendered in datagrid.
class Students {
  /// Creates the Students class with required details.
  Students(this.id, this.name, this.birthdate, this.personalId);

  /// Id of an Students.
  final int id;

  /// Name of an Students.
  final String name;

  /// Designation of an Students.
  final String birthdate;

  /// Salary of an Students.
  final int personalId;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the Students data to the datagrid widget.
class StudentsDataGridSource extends DataGridSource {
  /// Creates the Students data source class with required details.
  StudentsDataGridSource({required List<Students> studentsData}) {
    _studentsData = studentsData
        .map<DataGridRow>((Students dataGridRow) =>
            DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'ID', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'birthdate', value: dataGridRow.birthdate),
              DataGridCell<int>(
                  columnName: 'personalId', value: dataGridRow.personalId),
            ]))
        .toList();
  }

  List<DataGridRow> _studentsData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _studentsData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(cell.value.toString()),
      );
    }).toList());
  }
}
