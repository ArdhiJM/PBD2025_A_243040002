use KampusDB;

-- VIEW 
--MENAMPILKAN DAFTAR RUANGAN
CREATE OR ALTER VIEW vw_ruangan
AS
SELECT 
	KodeRuangan,
	Gedung,
	Kapasitas
FROM Ruangan;

SELECT * FROM vw_ruangan;


--VIEW JUMLAH MAHASISWA PER PRODI
CREATE OR ALTER VIEW vw_JumlahMahasiswaPerProdi
AS 
SELECT
	Prodi,
	COUNT (*) AS JumlahMahasiswa
FROM Mahasiswa
GROUP BY Prodi;

SELECT * FROM vw_JumlahMahasiswaPerProdi;


--VIEW MENAMPILKAN MAHASISWA DAN SEMESTER YANG DIAMBIL
CREATE OR ALTER VIEW vw_Mahasiswa_KRS
AS
SELECT
	m.NamaMahasiswa,
	K.Semester
FROM Mahasiswa m
JOIN KRS k on m.MahasiswaID = k.MahasiswaID;

SELECT * FROM vw_Mahasiswa_KRS;


--STORE PROCEDURE
--MENAMPILKAN SEMUA MAHASISWA
CREATE OR ALTER PROCEDURE sp_LihatMahasiswa
AS
BEGIN
	SELECT * FROM Mahasiswa;
END;

--MEMANGGIL PROCEDURE
EXEC sp_LihatMahasiswa;


--SP MENAMBAHKAN MAHASISWA BARU
CREATE OR ALTER PROCEDURE sp_TambahMahasiswa
	--VARIABEL" YANG DIBUTUHKAN
	@Nama VARCHAR(100),
	@Prodi VARCHAR(50),
	@Angkatan INT
AS
BEGIN
	INSERT INTO Mahasiswa (NamaMahasiswa, Prodi, Angkatan)
	VALUES (@Nama, @Prodi, @Angkatan);
END;

--CARA PENULISAN PEMANGGILAN SP NYA
EXEC sp_TambahMahasiswa
'Nobita', 'Informatika', '2005';

EXEC sp_TambahMahasiswa
	@Nama = 'Suneo',
	@Angkatan = '2023',
	@Prodi = 'Teknik Informatika';

--CEK APAKAH SUDAH TERTAMBAH ATAU BELUM
SELECT * FROM Mahasiswa;


--TRIGGER
--TRIGGER CEGAH NILAI KOSONG
CREATE OR ALTER TRIGGER trg_CekNilai
ON Nilai --dilakukan di tabel nilai
AFTER INSERT --Dilakukan setelah insert
AS
BEGIN
	IF EXISTS (
		SELECT * FROM inserted
		WHERE NilaiAkhir IS NULL
	)
	BEGIN
	--PESAN : 'Nilai Tidak Boleh kosong'
	--LEVEL ERROR : 16 (error karena input user)
	--STATE : 1 ( penanda error di massage)
	RAISERROR ('Nilai Tidak Boleh kosong',16, 1)
	ROLLBACK;
	END
END;


--TEST TRIGGER
INSERT INTO Nilai(MahasiswaID, NilaiAkhir)
VALUES (5, 90);


--UDF
--FUNGSI KONVERSI NILAI
CREATE OR ALTER FUNCTION fn_IndeksNilai(@Nilai INT)
RETURNS CHAR(1)
AS
BEGIN 
	RETURN
	CASE 
		WHEN @Nilai >= 85 THEN 'A'
		WHEN @Nilai >= 758 THEN 'B'
		WHEN @Nilai >= 55 THEN 'C'
		WHEN @Nilai >= 40 THEN 'D'
		ELSE 'E'
	END
END;

SELECT dbo.fn_IndeksNilai(30);

--FUNGSI CEK LULUS ATAU TIDAK 
CREATE OR ALTER FUNCTION fn_StatusLulus(@Nilai CHAR(2))
RETURNS VARCHAR(20)
AS
BEGIN
	RETURN
	CASE
		WHEN @nilai IN ('A','B','C') THEN 'Lulus'
		ELSE 'Tidak Lulus'
	END
END;

SELECT dbo.fn_StatusLulus('D');
