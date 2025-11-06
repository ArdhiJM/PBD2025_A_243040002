CREATE DATABASE JAMS_243040002;

USE JAMS_243040002;

--membuat table
CREATE TABLE Mahasiswa (
Nama VARCHAR (100),
Npm CHAR (9),
Alamat VARCHAR (100),
);


--mengubah table
--menambahkan table
ALTER TABLE Mahasiswa
ADD Kelas CHAR (8);


--Mengubah kolom alamat
ALTER TABLE Mahasiswa
ALTER COLUMN Alamat VARCHAR (50);


-- mengecek struktur tabel
EXEC sp_help 'Mahasiswa';


--membuat table
CREATE TABLE Dosen (
Nama VARCHAR (100) NOT NULL,
Nip CHAR (9) UNIQUE,
Alamat VARCHAR (100),
Prodi VARCHAR (100)
);

EXEC sp_help 'Dosen';


--menghapus kolom
ALTER TABLE Dosen
DROP COLUMN ALamat;


--menambahkan constraint pada kolom
ALTER TABLE Mahasiswa
ADD CONSTRAINT UQ_Npm_Mahasiswa UNIQUE (Npm);

--Menambahkan kolom nilai di tabel mahasiswa
ALTER TABLE Mahasiswa
ADD Nilai INT;

--menambahkan constraint default 
ALTER TABLE Mahasiswa
ADD CONSTRAINT DF_Nilai_Mahasiswa DEFAULT 100 FOR Nilai;

EXEC sp_help 'Mahasiswa'



CREATE DATABASE Toko_pedia;

USE Toko_pedia;


CREATE TABLE Pelanggan (
PelangganID INT IDENTITY(1,1) PRIMARY KEY,
NamaPelanggan VARCHAR(100) NOT NULL,
Email VARCHAR(100),
Telepon VARCHAR(20),
Alamat VARCHAR(255)
);

CREATE TABLE PesananHeader (
PesananID INT IDENTITY(1,1) PRIMARY KEY,

TanggalPesanan DATETIME2 NOT NULL,

--ini adalah kolom foreign key
PelangganID INT NOT NULL,

StatusPesanan VARCHAR(10) NOT NULL, 
     
 -- Mendefinisikan constraint FOREIGN KEY (out-of-line) 
CONSTRAINT FK_Pesanan_Pelanggan
FOREIGN KEY (PelangganID)  
REFERENCES Pelanggan(PelangganID),


 -- Mendefinisikan constraint CHECK 
CONSTRAINT CHK_StatusPesanan
CHECK (StatusPesanan IN ('Baru', 'Proses', 'Selesai')) 
);



EXEC sp_help 'Pelanggan';

EXEC sp_help 'PesananHeader';
