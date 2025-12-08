USE KampusDB;

--CROSS JOIN
--Menampilkan semua kombinasi Mahasiswa dan Mata Kuliah
SELECT M.NamaMahasiswa, MK.NamaMK
FROM Mahasiswa AS M
CROSS JOIN MataKuliah AS MK;

--Menampilkan semua kombinasi dosen dan ruangan
SELECT NamaDosen FROM Dosen
SELECT KodeRuangan FROM Ruangan;

SELECT D.NamaDosen, R.KodeRuangan
FROM Dosen D
CROSS JOIN Ruangan R;

--LEFT JOIN
-- Menampilkan semua mahasiswa, termasuk yang belum mengambil KRS
SELECT M.NamaMahasiswa, K.MataKuliahID
FROM Mahasiswa M
LEFT JOIN KRS K ON M.MahasiswaID = K.MahasiswaID;

--Menampilkan semua matakuliah, termasuk yang belum mempunyai jadwal
SELECT MK.NamaMK, J.Hari
FROM MataKuliah MK
LEFT JOIN JadwalKuliah J ON MK.MataKuliahID = J.MataKuliahID;

--RIGHT JOIN
--Menampilkam semiua jadwal,walaupun tidak ada mata kuliah
SELECT MK.NamaMK, J.Hari
FROM MataKuliah MK
RIGHT JOIN JadwalKuliah J ON MK.MataKuliahID = J.MataKuliahID;

--menampilkan semua ruangan, apakahb dipakai atau tidak
SELECT R.KodeRuangan, J.Hari
FROM JadwalKuliah J
RIGHT JOIN Ruangan R ON J.RuanganID = R.RuanganID;

--INNER JOIN 
--menampilkan gabungan tabel mahasiswa+mata kuliah melalui tabel KRS
SELECT M.NamaMahasiswa, MK.NamaMK
FROM KRS K
INNER JOIN Mahasiswa M ON K.MahasiswaID = M.MahasiswaID
INNER JOIN MataKuliah MK ON K.MataKuliahID = MK.MataKuliahID;

--Menampilkan MataKuliah dan dosen pengampunya
SELECT MK.NamaMK, D.NamaDosen
FROM MataKuliah MK
JOIN Dosen D ON MK.DosenID = D.DosenID;

--Menampilkan Jadwal lengkap MK + Dosen + Ruangann
SELECT MK.NamaMK, D.NamaDosen, R.KodeRuangan,  J.Hari
FROM JadwalKuliah J
INNER JOIN MataKuliah MK ON J.MataKuliahID = MK.MataKuliahID
INNER JOIN Dosen D ON J.DosenID = D.DosenID
INNER Join Ruangan R ON J.RuanganID = R.RuanganID;

--Menampilkan nama mahasiswa namma Mata kuliah dan nilai akhir
SELECT M.NamaMahasiswa, MK.NamaMK, N.NilaiAkhir
FROM Nilai N
INNER JOIN Mahasiswa M ON N.MahasiswaID = M.MahasiswaID
INNER JOIN MataKuliah MK On N.MataKuliahID = MK.MataKuliahID;

--Menmapilkan dosen dan mata kuliah yang diajar
SELECT D.NamaDosen, MK.NamaMK
FROM Dosen D
INNER JOIN MataKuliah MK ON D.DosenID = MK.DosenID;


--SELF JOIN 
--Mencari pasangan mahasiswa dari prodi yang sama 
SELECT A.NamaMahasiswa AS Mahasiswa1,
       B.NamaMahasiswa AS Mahasiswa2,
       A.Prodi
 FROM Mahasiswa A
 INNER JOIN Mahasiswa B ON A.Prodi = B.Prodi
 WHERE A.MahasiswaID < B.MahasiswaID; --agar tidak ada  pasangan yang sama 

 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --1.Tampilkan nama mahasiswa (NamaMahasiswa) beserta prodi-nya (Prodi) dari tabel Mahasiswa,tetapi hanya mahasiswa yang memiliki nilai di tabel Nilai.

 SELECT M.NamaMahasiswa, M.Prodi
FROM  Mahasiswa AS M
INNER JOIN Nilai AS N ON M.MahasiswaID = N.MahasiswaID;

--2.Tampilkan nama dosen(NamaDosen) dan ruangan(KodeRuangan) tempat dosen tersebut mengajar

SELECT  D.NamaDosen, R.KodeRuangan
FROM Dosen AS D
INNER JOIN  MataKuliah AS MK ON D.DosenID = MK.DosenID  -- 1. Dosen mengajar Mata Kuliah apa
INNER JOIN  JadwalKuliah AS J ON MK.MataKuliahID = J.MataKuliahID -- 2. Mata Kuliah tersebut ada di jadwal
INNER JOIN  Ruangan AS R ON J.RuanganID = R.RuanganID -- 3. Jadwal tersebut di Ruangan mana
GROUP BY D.NamaDosen, R.KodeRuangan;

--3. Tampilkan daftar mahasiswa (NamaMahasiswa) yang mengambil suatu mata kuliah(NamaMK) beserta nama mata kuliah dan dosen pengampu-nya(NamaDosen)

SELECT  M.NamaMahasiswa,  MK.NamaMK,  D.NamaDosen
FROM  KRS AS K
INNER JOIN   Mahasiswa AS M ON K.MahasiswaID = M.MahasiswaID -- 1. Gabungkan KRS dengan Mahasiswa
INNER JOIN   MataKuliah AS MK ON K.MataKuliahID = MK.MataKuliahID -- 2. Gabungkan KRS dengan Mata Kuliah
INNER JOIN   Dosen AS D ON MK.DosenID = D.DosenID; -- 3. Gabungkan Mata Kuliah dengan Dosen pengampu

--4. Tampilkan jadwal kuliah berisi nama mata kuliah(NamaMK), nama dosen(NamaDosen), dan hari kuliah(Hari) tetapi tidak perlu menampilkan ruangan.

SELECT   MK.NamaMK,   D.NamaDosen,   J.Hari
FROM  JadwalKuliah AS J
INNER JOIN  MataKuliah AS MK ON J.MataKuliahID = MK.MataKuliahID -- 1. Gabungkan Jadwal dengan Mata Kuliah
INNER JOIN  Dosen AS D ON J.DosenID = D.DosenID; -- 2. Gabungkan Jadwal dengan Dosen

--5. Tampilkan nilai mahasiswa(NilaiAkhir) lengkap dengan nama mahasiswa(NamaMahasiswa) nama mata kuliah (NamaMK) , nama dosen pengampu(NamaDosen) dan nilai akhirnya(NilaiAkhir)

SELECT M.NamaMahasiswa, MK.NamaMK, D.NamaDosen, N.NilaiAkhir
FROM Nilai AS N
INNER JOIN Mahasiswa AS M ON N.MahasiswaID = M.MahasiswaID      -- 1. Gabungkan Nilai dengan Mahasiswa
INNER JOIN MataKuliah AS MK ON N.MataKuliahID = MK.MataKuliahID  -- 2. Gabungkan Nilai dengan Mata Kuliah
INNER JOIN Dosen AS D ON MK.DosenID = D.DosenID;                -- 3. Gabungkan Mata Kuliah dengan Dosen pengampu