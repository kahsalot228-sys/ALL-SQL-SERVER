/* ============================================================
   Урок 23. Подготовка к зачету.
   Домашняя работа: проверка базы данных.
   Автор: <ваше имя>
   Дата:  <дата>
   ============================================================ */

USE [ВашаБазаДанных];  -- <-- укажите свою БД
GO

PRINT '=== 1. СПИСОК ТАБЛИЦ И ИХ КОЛИЧЕСТВО ===';
SELECT 
    t.name AS TableName,
    s.name AS SchemaName,
    t.create_date AS Created
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
ORDER BY s.name, t.name;
GO

SELECT COUNT(*) AS TotalTables
FROM sys.tables;
GO

PRINT '=== 2. ИНДЕКСЫ ПО ТАБЛИЦАМ ===';
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_primary_key AS IsPK,
    i.is_unique AS IsUnique
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL
ORDER BY t.name, i.name;
GO

PRINT '=== 3. ФАЙЛОВЫЕ ГРУППЫ ТАБЛИЦ ===';
SELECT 
    t.name AS TableName,
    fg.name AS FileGroupName,
    f.name AS FileLogicalName,
    f.physical_name AS FilePath
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id
JOIN sys.filegroups fg ON i.data_space_id = fg.data_space_id
JOIN sys.database_files f ON fg.data_space_id = f.data_space_id
WHERE i.index_id IN (0, 1)
ORDER BY t.name;
GO

PRINT '=== 4. ВЫЧИСЛЯЕМЫЕ СТОЛБЦЫ ===';
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
LEFT JOIN sys.computed_columns cc 
       ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.is_computed = 1
ORDER BY t.name, c.name;
GO

PRINT '=== 5. ТЕСТ: ВСТАВКА / ВЫБОРКА / УДАЛЕНИЕ ===';
-- Замените на свою таблицу и столбцы
INSERT INTO dbo.YourTable (Column1, Column2)
VALUES ('test_value', 123);

SELECT * FROM dbo.YourTable WHERE Column1 = 'test_value';

DELETE FROM dbo.YourTable WHERE Column1 = 'test_value';
GO

PRINT '=== 6. ПРОВЕРКА ИСПОЛЬЗОВАНИЯ ИНДЕКСА (план + IO) ===';
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM dbo.YourTable WHERE IndexedColumn = 'value';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

PRINT '=== 7. ПРОВЕРКА ОТЧЁТОВ (представления / процедуры) ===';
-- Пример: список всех представлений
SELECT name AS ViewName, create_date
FROM sys.views
ORDER BY name;

-- Пример: список всех хранимых процедур
SELECT name AS ProcName, create_date
FROM sys.procedures
ORDER BY name;

-- Если есть конкретный отчёт — вызовите его:
-- EXEC dbo.Report_YourReportName @Param = 'value';
-- SELECT TOP 10 * FROM dbo.YourReportView;
GO

PRINT '=== ГОТОВО. Проверка завершена. ===';
GO