--menampilkan semua data produk
select * from production.product;

---menampilkan kolom spesifik
select name, productnumber, listprice
from production.product;

--alias kolom 
select Name AS [Nama Barang], Listprice AS 'Harga jual' from Production.Product; 

--Kalkulasi Sederhana
SELECT Name, ListPrice, (ListPrice * 1.1) AS HargaBaru
FROM Production.Product;

--Menggabungkan String Tampilkan nama produk digabung dengan nomor produk dalam satu kolom.
SELECT Name + ' (' + ProductNumber + ')' AS ProdukLengkap
FROM Production.Product;

-- FILTERISASI DATA DENGAN WHERE
-- Menampilkan Produk yang Berwarna red
select name , color, listprice from Production.Product where color = 'Red';

--Menampilkan data yang ListPricenya lebih dari 1000
SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice > 1000;

-- Kondisi Jamak (AND) Cari produk berwarna 'Black' DAN harganya di atas 500
SELECT Name, Color, ListPrice
FROM Production.Product
WHERE Color = 'Black' AND ListPrice > 500;

--Kondisi Jamak (OR & IN) Cari produk yang warnanya 'Red', 'Blue', atau 'Black'
SELECT Name, Color
FROM Production.Product
WHERE Color IN ('Red', 'Blue', 'Black');
-- Cara lain: WHERE Color = 'Red' OR Color = 'Blue' OR Color ='Black'

-- Filter Pola String (LIKE) Cari produk yang namanya mengandung kata 'Road'.
SELECT Name, ProductNumber
FROM Production.Product
WHERE Name LIKE '%Road%';

-- AGREGASI & PENGELOMPOKAN (GROUP BY) (Step 3) GROUP BY memampatkan banyak baris menjadi satu baris ringkasan berdasarkan kolom tertentu.
--Menghitung Total Baris (COUNT) Hitung berapa banyak total produk yang terdaftar.
SELECT COUNT(*) AS TotalProduk
FROM Production.Product;

-- Tampilkan daftar warna yang tersedia dan berapa jumlah produk untuk setiap warna.
SELECT Color, COUNT(*) AS JumlahProduk
FROM Production.Product
GROUP BY Color;

--Gunakan tabel Sales.SalesOrderDetail. Hitung total kuantitas barang (OrderQty) dan rata-rata harga satuan (UnitPrice) per ID Produk.
SELECT ProductID, SUM(OrderQty) AS TotalTerjual, AVG(UnitPrice) AS
RataRataHarga
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

--Di tabel Production.Product, kelompokkan berdasarkan Warna (Color) dan Ukuran (Size)
SELECT Color, Size, COUNT(*) AS Jumlah
FROM Production.Product
GROUP BY Color, Size;

-- Validasi Logika Grouping Cobalah query berikut (akan error) dan analisa penyebabnya
-- QUERY ERROR
SELECT Color, Name, COUNT(*)
FROM Production.Product
GROUP BY Color;

--Tampilkan warna produk yang memiliki jumlah produk lebih dari 20 item
SELECT Color, COUNT(*) AS Jumlah
FROM Production.Product
GROUP BY Color
HAVING COUNT(*) > 20;

--Kombinasi WHERE dan HAVING Tampilkan Warna yang jumlah produknya > 10, TAPI hanya untuk produk yang harganya > 500
SELECT Color, COUNT(*) AS Jumlah
FROM Production.Product
WHERE ListPrice > 500 -- Filter baris dulu (Step 2)
GROUP BY Color -- Kelompokkan sisa baris (Step 3)
HAVING COUNT(*) > 10; -- Filter hasil kelompok (Step 4)

--Filter Berdasarkan Total Penjualan Dari Sales.SalesOrderDetail, cari ProductID yang total kuantitas penjualannya (OrderQty) di atas 1000 unit
SELECT ProductID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(OrderQty) > 1000;

-- Filter Rata-Rata Cari ID Penawaran Spesial (SpecialOfferID) dari Sales.SalesOrderDetail yang rata-rata penjualan unitnya (OrderQty) kurang dari 2
SELECT SpecialOfferID, AVG(OrderQty) AS RataRataBeli
FROM Sales.SalesOrderDetail
GROUP BY SpecialOfferID
HAVING AVG(OrderQty) < 2;

--Perbedaan Logika Jelaskan kenapa query ini valid:
SELECT Color
FROM Production.Product
GROUP BY Color
HAVING MAX(ListPrice) > 3000;
--Analisa: Query ini menampilkan warna yang memiliki setidaknya satu barang
--mahal (di atas 3000). Meskipun MAX(ListPrice) tidak ditampilkan di SELECT, ia bisa
--digunakan di HAVING untuk memfilter grup

--Menghilangkan Duplikasi (DISTINCT) Tampilkan daftar semua job title unik dari tabel HumanResources.Employee (atau kolom Color dari Product)
SELECT DISTINCT JobTitle
FROM HumanResources.Employee;

--Mengurutkan Data (ORDER BY) Tampilkan produk diurutkan dari harga termahal ke termurah.
SELECT Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Mengambil Data Teratas (TOP) Tampilkan 5 produk termahal
SELECT TOP 5 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Pagination (OFFSET FETCH) Tampilkan produk termahal urutan ke-11 sampai ke-15 (Halaman 2 jika per halaman 10 data)
SELECT Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC
OFFSET 2 ROWS
FETCH NEXT 4 ROWS ONLY;

select * from Production.product;

--Kompleksitas Penuh (All in One) Tampilkan 3 Warna (Color) yang
--memiliki total nilai stok (ListPrice * jumlah barang) tertinggi, tapi hanya hitung
--produk yang harganya > 0
SELECT TOP 3 Color, SUM(ListPrice) AS TotalNilaiStok
FROM Production.Product
WHERE ListPrice > 0 -- Step 2: Filter sampah
GROUP BY Color -- Step 3: Kelompokkan
ORDER BY TotalNilaiStok DESC;-- Step 6: Urutkan