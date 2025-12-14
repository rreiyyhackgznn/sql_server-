-- ReportingStructure tablosunu oluþtur
CREATE TABLE ReportingStructure (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT
);

-- Verileri ekle
INSERT INTO ReportingStructure (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'Alice Smith', NULL),  -- Alice Smith en üstte, kimseye rapor vermiyor
(2, 'Bob Johnson', 1),     -- Bob Johnson, Alice Smith'e rapor veriyor
(3, 'Carol White', 1),     -- Carol White, Alice Smith'e rapor veriyor
(4, 'David Brown', 2),     -- David Brown, Bob Johnson'a rapor veriyor
(5, 'Eve Davis', 2),       -- Eve Davis, Bob Johnson'a rapor veriyor
(6, 'Frank Miller', 3);    -- Frank Miller, Carol White'a rapor veriyor

-- Tabloyu kontrol et
SELECT * FROM ReportingStructure;

-- JOIN ile raporlama yapýsýný göster
SELECT b.EmployeeName AS [Reportee], A.EmployeeName AS [Manager]
FROM ReportingStructure A 
INNER JOIN ReportingStructure B ON A.EmployeeID = B.ManagerID

UNION ALL

SELECT EmployeeName, NULL AS [Manager] 
FROM ReportingStructure
WHERE ManagerID IS NULL;

-- EmployeeRecords tablosunu oluþtur (duplicate kayýtlarla)
CREATE TABLE EmployeeRecords (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    ManagerID INT
);

-- Verileri ekle (duplicate kayýtlarla)
INSERT INTO EmployeeRecords (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'Alice Smith', NULL),
(2, 'Bob Johnson', 1),
(3, 'Carol White', 1),
(4, 'David Brown', 2),
(5, 'Eve Davis', 2),
(6, 'Frank Miller', 3),
(2, 'Bob Johnson', 1),  -- Duplicate kayýt
(4, 'David Brown', 2);  -- Duplicate kayýt

-- Tabloyu kontrol et
SELECT * FROM EmployeeRecords 
ORDER BY EmployeeID, EmployeeName, ManagerID;

-- Backup tablosu oluþtur
SELECT * INTO emprecords_bkp FROM EmployeeRecords;

-- Backup tablosunu kontrol et
SELECT * FROM emprecords_bkp;

-- CTE ile duplicate temizleme ve hiyerarþik yapý oluþturma
WITH 
-- 1. CTE: Duplicate kayýtlarý numaralandýr
TemizKayitlar AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        ManagerID,
        ROW_NUMBER() OVER (
            PARTITION BY EmployeeID, EmployeeName, ManagerID 
            ORDER BY EmployeeID
        ) AS Sira
    FROM EmployeeRecords
),
-- 2. CTE: Benzersiz kayýtlarý filtrele
FiltreliKayitlar AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        ManagerID
    FROM TemizKayitlar
    WHERE Sira = 1
),
-- 3. CTE: Hiyerarþik yapý oluþtur (Recursive CTE)
Hiyerarsi AS (
    -- Anchor: En üst seviye yöneticiler (ManagerID NULL olanlar)
    SELECT 
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS Seviye,
        CAST(EmployeeName AS VARCHAR(500)) AS Yol
    FROM FiltreliKayitlar 
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive: Alt seviye çalýþanlar
    SELECT 
        f.EmployeeID,
        f.EmployeeName,
        f.ManagerID,
        h.Seviye + 1,
        CAST(h.Yol + ' -> ' + f.EmployeeName AS VARCHAR(500))
    FROM FiltreliKayitlar f
    INNER JOIN Hiyerarsi h ON f.ManagerID = h.EmployeeID
)
-- Final sorgu: Tüm hiyerarþiyi göster
SELECT 
    EmployeeName AS [Çalýþan Adý],
    Seviye AS [Yönetim Seviyesi],
    Yol AS [Organizasyon Yolu]
FROM Hiyerarsi
ORDER BY Seviye, EmployeeName;

-- Sadece duplicate temizleme için CTE
WITH DuplicateCTE AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        ManagerID,
        ROW_NUMBER() OVER (
            PARTITION BY EmployeeID, EmployeeName, ManagerID 
            ORDER BY EmployeeID
        ) AS Sira
    FROM EmployeeRecords
)
SELECT 
    EmployeeID,
    EmployeeName, 
    ManagerID
FROM DuplicateCTE
WHERE Sira = 1
ORDER BY EmployeeID;

-- Sadece hiyerarþik yapý için CTE (orijinal ReportingStructure tablosuyla)
WITH HiyerarsiCTE AS (
    -- Anchor: Kök seviye
    SELECT 
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS Seviye,
        CAST(EmployeeName AS VARCHAR(500)) AS Yol
    FROM ReportingStructure 
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive: Alt seviyeler
    SELECT 
        r.EmployeeID,
        r.EmployeeName,
        r.ManagerID,
        h.Seviye + 1,
        CAST(h.Yol + ' -> ' + r.EmployeeName AS VARCHAR(500))
    FROM ReportingStructure r
    INNER JOIN HiyerarsiCTE h ON r.ManagerID = h.EmployeeID
)
SELECT 
    EmployeeName AS [Çalýþan],
    Seviye AS [Seviye],
    Yol AS [Yol]
FROM HiyerarsiCTE
ORDER BY Seviye, EmployeeName;

-- Geçici tabloyu temizleme iþlemi (opsiyonel)
SELECT DISTINCT * INTO #TempClean FROM emprecords_bkp;
TRUNCATE TABLE emprecords_bkp;
INSERT INTO emprecords_bkp SELECT * FROM #TempClean;
SELECT * FROM #TempClean;