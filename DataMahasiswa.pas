program DataMahasiswa;
uses crt, sysutils;

type
  TDataMahasiswa = record
    NIM: string;
    Nama: string;
    Nilai: real;
  end;

var
  fileMahasiswa: file of TDataMahasiswa;
  mahasiswa: TDataMahasiswa;

// Prosedur untuk menambah data mahasiswa
procedure TambahData();
var
  tempMahasiswa: TDataMahasiswa;
begin
  clrscr;
  assign(fileMahasiswa, 'data_mahasiswa.dat');
  if not FileExists('data_mahasiswa.dat') then
    rewrite(fileMahasiswa)
  else
    reset(fileMahasiswa);

  seek(fileMahasiswa, filesize(fileMahasiswa)); // Mulai dari akhir file
  writeln('--- Tambah Data Mahasiswa ---');
  write('Masukkan NIM: ');
  readln(tempMahasiswa.NIM);
  write('Masukkan Nama: ');
  readln(tempMahasiswa.Nama);
  write('Masukkan Nilai: ');
  readln(tempMahasiswa.Nilai);

  write(fileMahasiswa, tempMahasiswa); // Menyimpan data ke file
  close(fileMahasiswa);
  writeln('Data berhasil ditambahkan.');
  readln;
end;

// Fungsi rekursif untuk mencari data mahasiswa
function CariData(NIM: string; var posisi: integer): boolean;
var
  tempMahasiswa: TDataMahasiswa;
begin
  assign(fileMahasiswa, 'data_mahasiswa.dat');
  reset(fileMahasiswa);
  if (posisi >= filesize(fileMahasiswa)) then
  begin
    close(fileMahasiswa);
    CariData := false;
  end
  else
  begin
    seek(fileMahasiswa, posisi);
    read(fileMahasiswa, tempMahasiswa);
    if tempMahasiswa.NIM = NIM then
    begin
      writeln('Data ditemukan:');
      writeln('NIM: ', tempMahasiswa.NIM);
      writeln('Nama: ', tempMahasiswa.Nama);
      writeln('Nilai: ', tempMahasiswa.Nilai:0:2);
      close(fileMahasiswa);
      CariData := true;
    end
    else
    begin
      posisi := posisi + 1;
      CariData := CariData(NIM, posisi); // Rekursif untuk pencarian
    end;
  end;
end;

// Prosedur untuk mengedit data mahasiswa
procedure EditData();
var
  NIM: string;
  posisi: integer;
  found: boolean;
  tempMahasiswa: TDataMahasiswa;
begin
  clrscr;
  write('Masukkan NIM yang akan diedit: ');
  readln(NIM);
  posisi := 0;
  found := CariData(NIM, posisi);
  
  if found then
  begin
    assign(fileMahasiswa, 'data_mahasiswa.dat');
    reset(fileMahasiswa);
    seek(fileMahasiswa, posisi);
    read(fileMahasiswa, tempMahasiswa);
    writeln('--- Edit Data Mahasiswa ---');
    write('Masukkan Nama baru: ');
    readln(tempMahasiswa.Nama);
    write('Masukkan Nilai baru: ');
    readln(tempMahasiswa.Nilai);
    seek(fileMahasiswa, posisi);
    write(fileMahasiswa, tempMahasiswa); // Mengganti data lama
    close(fileMahasiswa);
    writeln('Data berhasil diperbarui.');
  end
  else
    writeln('Data dengan NIM tersebut tidak ditemukan.');
  
  readln;
end;

// Prosedur untuk menampilkan semua data mahasiswa
procedure TampilkanSemuaData();
var
  tempMahasiswa: TDataMahasiswa;
begin
  clrscr;
  assign(fileMahasiswa, 'data_mahasiswa.dat');
  reset(fileMahasiswa);
  
  writeln('--- Data Mahasiswa ---');
  while not eof(fileMahasiswa) do
  begin
    read(fileMahasiswa, tempMahasiswa);
    writeln('NIM: ', tempMahasiswa.NIM);
    writeln('Nama: ', tempMahasiswa.Nama);
    writeln('Nilai: ', tempMahasiswa.Nilai:0:2);
    writeln('----------------------');
  end;
  
  close(fileMahasiswa);
  readln;
end;

// Menu Utama
procedure MenuUtama();
var
  pilihan: char;
  nim: string;  // Deklarasi nim di sini
  posisi: integer;
begin
  repeat
    clrscr;
    writeln('=== Menu Utama ===');
    writeln('1. Tambah Data Mahasiswa');
    writeln('2. Cari Data Mahasiswa');
    writeln('3. Edit Data Mahasiswa');
    writeln('4. Tampilkan Semua Data');
    writeln('5. Keluar');
    writeln('Pilih menu (1/2/3/4/5): ');
    readln(pilihan);
    
    case pilihan of
      '1': TambahData();
      '2': 
        begin
          clrscr;
          write('Masukkan NIM yang ingin dicari: ');
          readln(nim);  // Baca nilai nim
          posisi := 0;  // Inisialisasi posisi
          if not CariData(nim, posisi) then
            writeln('Data tidak ditemukan.');
          readln;
        end;
      '3': EditData();
      '4': TampilkanSemuaData();
      '5': writeln('Keluar dari program...');
    else
      writeln('Pilihan tidak valid, coba lagi.');
    end;
    
  until pilihan = '5';
end;

begin
  MenuUtama();
end.
