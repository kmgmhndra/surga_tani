import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:surgatani/models/pencatatan_tanaman_pangan_model.dart';
import 'package:surgatani/models/pencatatan_hortikultura_model.dart';
import 'package:surgatani/models/pencatatan_peternakan_model.dart';
import 'package:surgatani/models/pencatatan_perkebunan_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  // --- FUNGSI PDF TANAMAN PANGAN ---
  static Future<void> generateTanamanPanganPdf(
      PencatatanTanamanPangan data) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    // 1. Buat Halaman Laporan Utama
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildPdfTheme(),
        header: (context) => _buildPdfHeader(
            context, 'DATA PEMANTAUAN HARGA KOMODITI PERTANIAN'),
        build: (pw.Context context) {
          return [
            _buildInfoSection(
                subsektor: 'Tanaman Pangan',
                data: data,
                font: font,
                boldFont: boldFont),
            pw.SizedBox(height: 16),
            _buildTanamanPanganTable(data, font, boldFont),
            pw.SizedBox(height: 30),
            _buildSignature(data, font, boldFont),
          ];
        },
        footer: (context) => _buildPdfFooter(context),
      ),
    );

    // 2. Jika ada foto, tambahkan halaman baru KHUSUS untuk lampiran
    if (data.imagePaths != null && data.imagePaths!.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: _buildPdfTheme(),
          header: (context) => _buildPdfHeader(
              context, 'LAMPIRAN DOKUMENTASI FOTO',
              isAttachment: true),
          build: (pw.Context context) {
            return [_buildDocumentationGrid(data.imagePaths!)];
          },
          footer: (context) => _buildPdfFooter(context),
        ),
      );
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  // --- FUNGSI PDF HORTIKULTURA ---
  static Future<void> generateHortikulturaPdf(
      PencatatanHortikultura data) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildPdfTheme(),
        header: (context) => _buildPdfHeader(
            context, 'DATA PEMANTAUAN HARGA KOMODITI PERTANIAN'),
        build: (pw.Context context) {
          return [
            _buildInfoSection(
                subsektor: 'Hortikultura',
                data: data,
                font: font,
                boldFont: boldFont),
            pw.SizedBox(height: 16),
            _buildHortikulturaTable(data, font, boldFont),
            pw.SizedBox(height: 30),
            _buildSignature(data, font, boldFont),
          ];
        },
        footer: (context) => _buildPdfFooter(context),
      ),
    );

    if (data.imagePaths != null && data.imagePaths!.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: _buildPdfTheme(),
          header: (context) => _buildPdfHeader(
              context, 'LAMPIRAN DOKUMENTASI FOTO',
              isAttachment: true),
          build: (pw.Context context) {
            return [_buildDocumentationGrid(data.imagePaths!)];
          },
          footer: (context) => _buildPdfFooter(context),
        ),
      );
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  // --- FUNGSI PDF PETERNAKAN ---
  static Future<void> generatePeternakanPdf(PencatatanPeternakan data) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildPdfTheme(),
        header: (context) => _buildPdfHeader(
            context, 'DATA PEMANTAUAN HARGA KOMODITI PERTANIAN'),
        build: (pw.Context context) {
          return [
            _buildInfoSection(
                subsektor: 'Peternakan',
                data: data,
                font: font,
                boldFont: boldFont),
            pw.SizedBox(height: 16),
            _buildPeternakanTable(data, font, boldFont),
            pw.SizedBox(height: 30),
            _buildSignature(data, font, boldFont),
          ];
        },
        footer: (context) => _buildPdfFooter(context),
      ),
    );

    if (data.imagePaths != null && data.imagePaths!.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: _buildPdfTheme(),
          header: (context) => _buildPdfHeader(
              context, 'LAMPIRAN DOKUMENTASI FOTO',
              isAttachment: true),
          build: (pw.Context context) {
            return [_buildDocumentationGrid(data.imagePaths!)];
          },
          footer: (context) => _buildPdfFooter(context),
        ),
      );
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  // --- FUNGSI PDF PERKEBUNAN ---
  static Future<void> generatePerkebunanPdf(PencatatanPerkebunan data) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildPdfTheme(),
        header: (context) => _buildPdfHeader(
            context, 'DATA PEMANTAUAN HARGA KOMODITI PERTANIAN'),
        build: (pw.Context context) {
          return [
            _buildInfoSection(
                subsektor: 'Perkebunan',
                data: data,
                font: font,
                boldFont: boldFont),
            pw.SizedBox(height: 16),
            _buildPerkebunanTable(data, font, boldFont),
            pw.SizedBox(height: 30),
            _buildSignature(data, font, boldFont),
          ];
        },
        footer: (context) => _buildPdfFooter(context),
      ),
    );

    if (data.imagePaths != null && data.imagePaths!.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: _buildPdfTheme(),
          header: (context) => _buildPdfHeader(
              context, 'LAMPIRAN DOKUMENTASI FOTO',
              isAttachment: true),
          build: (pw.Context context) {
            return [_buildDocumentationGrid(data.imagePaths!)];
          },
          footer: (context) => _buildPdfFooter(context),
        ),
      );
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  // --- WIDGET HELPER UMUM ---
  static pw.PageTheme _buildPdfTheme() {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      // Margin dikurangi untuk mengoptimalkan ruang
      margin: const pw.EdgeInsets.fromLTRB(20, 20, 20, 20),
    );
  }

  static pw.Widget _buildPdfHeader(pw.Context context, String title,
      {bool isAttachment = false}) {
    if (context.pageNumber == 1 || isAttachment) {
      return pw.Column(children: [
        pw.Center(
          child: pw.Text(
            title.toUpperCase(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1),
        pw.SizedBox(height: 8),
      ]);
    }
    return pw.Container();
  }

  static pw.Widget _buildInfoSection({
    required String subsektor,
    required dynamic data,
    required pw.Font font,
    required pw.Font boldFont,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _infoRow('Subsektor', subsektor, font),
        _infoRow('Nama Instansi', data.namaInstansi, font),
        _infoRow('Nama Petugas', data.namaPetugas, font),
        _infoRow('Jabatan', data.jabatan, font),
        _infoRow('Lokasi Pasar', data.lokasi, font),
        _infoRow('Nama Pedagang', data.namaPedagang, font),
      ],
    );
  }

  static pw.Widget _infoRow(String title, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(children: [
        pw.SizedBox(
            width: 100,
            child:
                pw.Text(title, style: pw.TextStyle(font: font, fontSize: 10))),
        pw.Text(':  ', style: pw.TextStyle(font: font, fontSize: 10)),
        pw.Expanded(
            child:
                pw.Text(value, style: pw.TextStyle(font: font, fontSize: 10))),
      ]),
    );
  }

  static pw.Widget _buildSignature(
      dynamic data, pw.Font font, pw.Font boldFont) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 180,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
                '${data.lokasi}, ${DateFormat('d MMMM yyyy', 'id_ID').format(data.tanggal)}',
                style: pw.TextStyle(font: font, fontSize: 9)),
            pw.SizedBox(height: 4),
            pw.Text('Petugas Pencatat,',
                style: pw.TextStyle(font: font, fontSize: 9)),
            pw.SizedBox(height: 50),
            pw.Container(
              width: 160,
              decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 0.5))),
              child: pw.Text(data.namaPetugas,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: boldFont, fontSize: 9)),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildDocumentationGrid(List<String> imagePaths) {
    final List<pw.Widget> imageWidgets = [];

    // Batasi maksimal 6 gambar per halaman untuk mencegah overflow
    final limitedPaths = imagePaths.take(6).toList();

    for (String path in limitedPaths) {
      try {
        final imageBytes = File(path).readAsBytesSync();
        final image = pw.MemoryImage(imageBytes);
        imageWidgets.add(
          pw.Container(
            width: 250,
            height: 180,
            margin: const pw.EdgeInsets.all(8),
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400, width: 1)),
            child: pw.Image(image, fit: pw.BoxFit.contain),
          ),
        );
      } catch (e) {
        // Skip gambar yang error
        continue;
      }
    }

    return pw.Wrap(
      alignment: pw.WrapAlignment.center,
      spacing: 10,
      runSpacing: 15,
      children: imageWidgets,
    );
  }

  static pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8.0),
      child: pw.Text('Halaman ${context.pageNumber} dari ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
    );
  }

  // --- TABEL-TABEL SPESIFIK ---

  static pw.Widget _buildTanamanPanganTable(
      PencatatanTanamanPangan data, pw.Font font, pw.Font boldFont) {
    const headers = [
      'No',
      'Jenis Komoditi',
      'Harga Eceran/kg',
      'Harga Grosir/25kg',
      'Keterangan'
    ];
    final tableData = data.daftarKomoditi.asMap().entries.map((entry) {
      return [
        (entry.key + 1).toString(),
        entry.value.nama,
        'Rp ${NumberFormat('#,##0', 'id_ID').format(entry.value.hargaEceran ?? 0)}',
        'Rp ${NumberFormat('#,##0', 'id_ID').format(entry.value.hargaGrosir ?? 0)}',
        entry.value.keterangan ?? '-',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: tableData,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle:
          pw.TextStyle(font: boldFont, fontSize: 9, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
      cellStyle: pw.TextStyle(font: font, fontSize: 8),
      cellPadding: const pw.EdgeInsets.all(4),
      cellAlignments: {
        0: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FlexColumnWidth(2.8),
        2: const pw.FixedColumnWidth(80),
        3: const pw.FixedColumnWidth(90),
        4: const pw.FlexColumnWidth(2.2),
      },
    );
  }

  static pw.Widget _buildHortikulturaTable(
      PencatatanHortikultura data, pw.Font font, pw.Font boldFont) {
    const headers = ['No', 'Jenis Komoditi', 'Harga per Kg', 'Keterangan'];
    final tableData = data.daftarKomoditi.asMap().entries.map((entry) {
      return [
        (entry.key + 1).toString(),
        entry.value.nama,
        'Rp ${NumberFormat('#,##0', 'id_ID').format(entry.value.hargaPerKg ?? 0)}',
        entry.value.keterangan ?? '-',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: tableData,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle:
          pw.TextStyle(font: boldFont, fontSize: 9, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
      cellStyle: pw.TextStyle(font: font, fontSize: 8),
      cellPadding: const pw.EdgeInsets.all(4),
      cellAlignments: {
        0: pw.Alignment.center,
        2: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FlexColumnWidth(3.5),
        2: const pw.FlexColumnWidth(1.8),
        3: const pw.FlexColumnWidth(2.7),
      },
    );
  }

  static pw.Widget _buildPerkebunanTable(
      PencatatanPerkebunan data, pw.Font font, pw.Font boldFont) {
    const headers = ['No', 'Jenis Komoditi', 'Harga', 'Keterangan'];
    final tableData = data.daftarKomoditi.asMap().entries.map((entry) {
      return [
        (entry.key + 1).toString(),
        entry.value.nama,
        'Rp ${NumberFormat('#,##0', 'id_ID').format(entry.value.hargaPerKg ?? 0)}',
        entry.value.keterangan ?? '-',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: tableData,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle:
          pw.TextStyle(font: boldFont, fontSize: 9, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
      cellStyle: pw.TextStyle(font: font, fontSize: 8),
      cellPadding: const pw.EdgeInsets.all(4),
      cellAlignments: {
        0: pw.Alignment.center,
        2: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FlexColumnWidth(3.5),
        2: const pw.FlexColumnWidth(1.8),
        3: const pw.FlexColumnWidth(2.7),
      },
    );
  }

  static pw.Widget _buildPeternakanTable(
      PencatatanPeternakan data, pw.Font font, pw.Font boldFont) {
    final List<pw.TableRow> rows = [];

    // Header
    rows.add(pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
        children: ['No', 'Jenis Komoditi', 'Harga', 'Keterangan']
            .map((header) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(header,
                      style: pw.TextStyle(
                          font: boldFont, color: PdfColors.white, fontSize: 9),
                      textAlign: pw.TextAlign.center),
                ))
            .toList()));

    // Body
    for (var i = 0; i < data.daftarKomoditi.length; i++) {
      final item = data.daftarKomoditi[i];
      rows.add(pw.TableRow(children: [
        pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text((i + 1).toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: font, fontSize: 8))),
        pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(item.nama,
                style: pw.TextStyle(font: boldFont, fontSize: 8))),
        pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(
              item.subItems.isEmpty
                  ? 'Rp ${NumberFormat('#,##0', 'id_ID').format(item.hargaUtama ?? 0)}'
                  : '',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(font: font, fontSize: 8),
            )),
        pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(item.keterangan ?? '',
                style: pw.TextStyle(font: font, fontSize: 8))),
      ]));

      // Sub-items
      if (item.subItems.isNotEmpty) {
        for (var subItem in item.subItems) {
          rows.add(pw.TableRow(children: [
            pw.Text(''), // Kolom No kosong
            pw.Padding(
                padding: const pw.EdgeInsets.only(
                    left: 16, top: 2, bottom: 2, right: 4),
                child: pw.Text('- ${subItem.nama}',
                    style: pw.TextStyle(font: font, fontSize: 8))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  'Rp ${NumberFormat('#,##0', 'id_ID').format(subItem.harga ?? 0)}',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(font: font, fontSize: 8),
                )),
            pw.Text(''), // Kolom Keterangan kosong
          ]));
        }
      }
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FlexColumnWidth(3.5),
        2: const pw.FlexColumnWidth(1.8),
        3: const pw.FlexColumnWidth(2.7),
      },
      children: rows,
    );
  }
}
