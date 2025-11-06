--membuat database--
CREATE DATABASE Toko_Retail_DB;

USE Toko_Retail_DB;
GO

--buat table kategori
CREATE TABLE KategoriProduk (
	kategoriID INT IDENTITY(1,1) PRIMARY KEY,
	NamaKategori VARCHAR(100) NOT NULL UNIQUE
);
GO

EXEC sp_help 'KategoriProduk';

--buat table produk--
CREATE TABLE Produk (
	ProdukID INT IDENTITY(1001,1) PRIMARY KEY,
	SKU VARCHAR(20) NOT NULL UNIQUE,
	NamaProduk VARCHAR(150) NOT NULL,
	Harga DECIMAL(10, 2) NOT NULL,
	Stok INT NOT NULL,
	KategoriID INT NULL,  --boleh NULL jika belum dikategorikan
	
	CONSTRAINT CHK_HargaPositif CHECK (Harga >= 0 ),
	CONSTRAINT CHK_StokPositif CHECK (Stok >= 0 ),
	CONSTRAINT FK_Produk_Kategori
		FOREIGN KEY (KategoriID)
		REFERENCES KategoriProduk(KategoriID)
 );

 EXEC sp_help 'Produk';

 /* 3. Buat tabel Pelanggan */ 
CREATE TABLE Pelanggan ( 
    PelangganID INT IDENTITY(1,1) PRIMARY KEY, 
    NamaDepan VARCHAR(50) NOT NULL, 
    NamaBelakang VARCHAR(50) NULL, 
    Email VARCHAR(100) NOT NULL UNIQUE, 
    NoTelepon VARCHAR(20) NULL,
	TanggalDaftar DATE DEFAULT GETDATE() 
);

/* 4. Buat tabel Pesanan Header */ 
CREATE TABLE PesananHeader ( 
    PesananID INT IDENTITY(50001, 1) PRIMARY KEY, 
    PelangganID INT NOT NULL, 
    TanggalPesanan DATETIME2 DEFAULT GETDATE(), 
    StatusPesanan VARCHAR(20) NOT NULL, 
     
    CONSTRAINT CHK_StatusPesanan CHECK (StatusPesanan IN ('Baru', 'Proses', 
'Selesai', 'Batal')), 
    CONSTRAINT FK_Pesanan_Pelanggan  
        FOREIGN KEY (PelangganID)  
        REFERENCES Pelanggan(PelangganID) 
        -- ON DELETE NO ACTION (Default) 
); 
GO 
 
/* 5. Buat tabel Pesanan Detail */ 
CREATE TABLE PesananDetail ( 
    PesananDetailID INT IDENTITY(1,1) PRIMARY KEY, 
    PesananID INT NOT NULL, 
    ProdukID INT NOT NULL, 
    Jumlah INT NOT NULL, 
    HargaSatuan DECIMAL(10, 2) NOT NULL, -- Harga saat barang itu dibeli 
 
    CONSTRAINT CHK_JumlahPositif CHECK (Jumlah > 0), 
    CONSTRAINT FK_Detail_Header 
        FOREIGN KEY (PesananID)  
        REFERENCES PesananHeader(PesananID) 
        ON DELETE CASCADE,  -- Jika Header dihapus, detail ikut terhapus 
     
    CONSTRAINT FK_Detail_Produk 
        FOREIGN KEY (ProdukID)  
        REFERENCES Produk(ProdukID) 
); 
GO


PRINT 'Database Toko_Retail_DB dan semua tabel berhasil dibuat';



 /*Memasukkan data Pelanggan */ -- Sintaks eksplisit (Best Practice) 
INSERT INTO Pelanggan (NamaDepan, NamaBelakang, Email, NoTelepon)
VALUES 
('Erik','Adia','erik.adia@email.com','08123456789'),
('Shaka','Juts','shaka.juts@email.com',NULL);

EXEC sp_help 'Pelanggan';


/* 2. Memasukkan data Kategori (Multi-row) */ 
INSERT INTO KategoriProduk (NamaKategori)
VAlUES
('Elektronik'),
('Pakaian'),
('Buku');


EXEC sp_help 'KategoriProduk';

/* 3. Verifikasi Data */ 
PRINT 'Data Pelanggan:';
SELECT * FROM Pelanggan;

PRINT 'Data Kategori:';
SELECT * FROM KategoriProduk;

/* Masukkan data Produk yang merujuk ke KategoriID */
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES
('ELEC-001','Laptop Asus TUF', 12000000.00, 50, 1),
('PAK-001','kaos Polos Hitam', 75000.00, 200, 2),
('BUK-001', 'Dasar-Dasar SQL', 120000.00, 100, 3);

UPDATE Produk
SET NamaProduk= 'Kaos Polos Hitam'
WHERE  KategoriID = 2;


/* Verifikasi Data */ 
PRINT 'Data Produk:'; 
SELECT P.*, K.NamaKategori 
FROM Produk AS P 
JOIN KategoriProduk AS K ON P.KategoriID = K.KategoriID; 


/* Cek data SEBELUM di-update */ 
SELECT * FROM Pelanggan WHERE PelangganID = 2;

BEGIN TRANSACTION; --Mulai zona aman

UPDATE Pelanggan
SET NoTelepon = '082233445566'
WHERE PelangganID = 2;

SELECT * FROM Pelanggan WHERE PelangganID = 2;

-- Jika sudah yakin, jadikan permanen 
COMMIT TRANSACTION;

SELECT * FROM Pelanggan WHERE PelangganID = 2;