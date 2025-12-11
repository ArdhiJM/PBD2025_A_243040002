use KampusDB;

--Subquery
--Menampilkan dosen yang mengajar di matakuliah Basis Data
select NamaDosen
from Dosen
Where DosenID = ( 
	Select DosenID
	From MataKuliah
	Where NamaMK = 'Basis Data'
);

--Menampilkan mahasiswa yang memiliki nilai A
select NamaMahasiswa
from Mahasiswa
where MahasiswaID in (
	Select MahasiswaID
	From Nilai
	where NilaiAkhir = 'A'
);


--Menampilkan Daftar prodi yang mahasiswanya >= 2
select Prodi, TotalMhs
from ( 
	select Prodi, count(*) as TotalMhs
	from Mahasiswa
	group by Prodi
)as HitungMhs
	where totalmhs > 2;
	

--Menampilkan mata kuliah (NamaMk) yang diajar oleh dosen dari prodi informatika
select NamaMk
from MataKuliah
where DosenID in (
	select DosenID
	from Dosen
	Where Prodi = 'Informatika'
);


--CTE
--CTE untuk daftar mahasiswa informatika
with MhsIF as (
	select * 
	from Mahasiswa
	where Prodi = 'Informatika'
)
Select NamaMahasiswa, Angkatan
From MhsIF;


--CTE untuk menghitung jumlah mahasiswa per prodi
with JumlahPerProdi as (
	select Prodi, Count(*) as TotalMahasiswa
	from Mahasiswa
	group by Prodi
)
select * from JumlahPerProdi;


--SET OPERATOR
--UNION : Menggabungkan daftar nama dosen dan nama mahasiswa 
select NamaDosen as Nama
from Dosen
Union 
select NamaMahasiswa
from Mahasiswa;


--Union ALL : Menggabungkan ruangan yang kapasitasnya >40 dan <40
select KodeRuangan, Kapasitas
from Ruangan
where Kapasitas > 40
union all
select KodeRuangan, Kapasitas
from Ruangan
where Kapasitas < 40;


--INTERSECT : Mahasiswa yang ada ditabel KRS dan Tabel Nilai
select MahasiswaID
from KRS
intersect 
select MahasiswaID
from Nilai


--EXCEPT : Mahasiswa yang terdapat di tabel KRS rapi belum memiliki nilai
select MahasiswaID
from KRS
except
select MahasiswaID
from Nilai


--ROLLUP : ROLLUP jumlah mahasiswa per prodi dan total keseluruhan 
select Prodi, count(*) AS TotalMahasiswa 
From Mahasiswa
Group by rollup(Prodi);

--CUBE : Jumlah mahasiswa berdasarkan prodi dan angkatan
select Prodi, Angkatan, count(*) as TotalMahasiswa
from Mahasiswa
group by cube ( Prodi, Angkatan);


--GROUPING SETS
--Total mahasiswa berdasarkan prodi, angkatan, dan total keseluruhan 
select Prodi, Angkatan, count(*) AS TotalMahasiswa
from Mahasiswa
group by grouping sets(
	(Prodi), --Subtotal Prodi
	(Angkatan), --Subtotal per angkatan
	() --Grend total / total mahasiswanya
);


--WINDOW FUNCTION
--Menampilkan Nama Mahasiswa + total Mahasiswa di prodi yang sama
select 
	NamaMahasiswa,
	Prodi,
	count(*) over (partition by prodi) as totalMahasiswaPerProdi
from Mahasiswa;



