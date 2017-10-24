SELECT name AS [File Name] , file_id, physical_name AS [Physical Name], 
    size/128 AS [Total Size in MB],size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 
    AS [Available Space In MB]
    FROM sys.database_files;
    
    -- Get Table names, row counts, and compression status (SQL 2008 Only)
    SELECT OBJECT_NAME(object_id) AS [Table Name], SUM(Rows) AS [Row Count], 
           data_compression_desc AS [Compression]
    FROM sys.partitions 
    WHERE index_id < 2 --ignore the partitions from the non-clustered index if any
    AND OBJECT_NAME(object_id) NOT LIKE 'sys%'
    AND OBJECT_NAME(object_id) NOT LIKE 'queue_%' 
    AND OBJECT_NAME(object_id) NOT LIKE 'filestream_tombstone%' 
    GROUP BY object_id, data_compression_desc
    ORDER BY SUM(Rows) DESC;
    
    -- Get count of rows, data and index size in current database
    SELECT  object_name(id) AS [TableName], rowcnt AS [Rows], 
           (dpages * 8)/1024 AS [DataSize_MB], 
           ((SUM(used) * 8) - (dpages * 8))/1024 AS [IndexSize_MB]
    FROM sys.sysindexes 
    WHERE indid IN (0,1) 
    AND OBJECTPROPERTY(id, 'IsUserTable') = 1 
    GROUP BY id, rowcnt, reserved, dpages
    ORDER BY dpages DESC; 
    
    -- Look at recent compressed full backups (SQL 2008 Only)
    SELECT TOP (5) bs.server_name, bs.database_name AS [Database Name], 
    CONVERT (BIGINT, bs.backup_size / 1048576 ) AS [Uncompressed Backup Size (MB)],
    CONVERT (BIGINT, bs.compressed_backup_size / 1048576 ) AS [Compressed Backup Size (MB)],
    CONVERT (NUMERIC (20,2), (CONVERT (FLOAT, bs.backup_size) /
    CONVERT (FLOAT, bs.compressed_backup_size))) AS [Compression Ratio], 
    DATEDIFF (SECOND, bs.backup_start_date, bs.backup_finish_date) AS [Backup Elapsed Time (sec)],
    bs.backup_finish_date AS [Backup Finish Date]
    FROM msdb.dbo.backupset AS bs 
    WHERE DATEDIFF (SECOND, bs.backup_start_date, bs.backup_finish_date) > 0 
    AND bs.backup_size > 0
    AND bs.type = 'D' -- Change to L if you want Log backups
    ORDER BY bs.backup_finish_date DESC;