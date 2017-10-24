CREATE TABLE [dbo].[KB_BillMaterialData_Transfer]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Linea] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parte] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [numeric] (25, 6) NULL,
[Requerimiento] [numeric] (25, 6) NULL,
[Requerimiento Total] [numeric] (25, 6) NULL,
[entregado] [numeric] (25, 6) NULL,
[diasentregados] [numeric] (25, 6) NULL,
[fecha_inicio] [datetime] NULL,
[rebajado] [numeric] (25, 6) NULL,
[materialista] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[diasacargar] [numeric] (25, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KB_BillMaterialData_Transfer] ADD CONSTRAINT [PK_KB_BillMaterialData_Transfer] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Attributes', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'DateCreated', N'10/14/2006 8:41:41 AM', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'LastUpdated', N'10/16/2006 11:40:27 AM', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DefaultView', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Filter', N'((BillMaterialData_Transfer.[Requerimiento Total]=0))', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_OrderBy', N'BillMaterialData_Transfer.Linea', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_OrderByOn', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Orientation', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'Name', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'RecordCount', N'2238', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'Updatable', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', NULL, NULL
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'GUID', N'叵䔥䜁톇૴埔㰢', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Format', N'@', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Name', N'Description', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'SourceField', N'Description', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'GUID', N'鴂涩琣䢏満꣥煾', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Name', N'diasentregados', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'7', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'SourceField', N'diasentregados', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'GUID', N'ꣴ⭅ﺻ䯈ウ՜轶退', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Name', N'entregado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'6', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Size', N'50', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'SourceField', N'entregado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'GUID', N'ὺꈈ䨽䁇쮶꘹䑐䋴', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'Name', N'fecha_inicio', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'SourceField', N'fecha_inicio', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'Type', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'fecha_inicio'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'GUID', N'럍䮠텀䠷請䈅촶', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_Format', N'@', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Name', N'Linea', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'SourceField', N'Linea', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'GUID', N'⹹ꑱ䦉뢞翳쉎늠', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Name', N'materialista', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Size', N'50', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'SourceField', N'materialista', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'GUID', N'ꃰ㳲嬧䒮উꀺ졬ꂈ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_Format', N'@', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Name', N'Parte', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'SourceField', N'Parte', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'GUID', N'堵㠧ㄷ䒴Ꞁ咺ٯꀒ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Name', N'Quantity', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'SourceField', N'Quantity', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'GUID', N'춀ﯶ泫䐕㺛ꬸ鵫␇', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Name', N'rebajado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'9', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'SourceField', N'rebajado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'GUID', N'篦柶䁮禧츸ꢝ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Name', N'Requerimiento', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'SourceField', N'Requerimiento', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'1905', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'GUID', N'᥾т瀫侩⎋杠鳫틗', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Name', N'Requerimiento Total', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'5', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'SourceField', N'Requerimiento Total', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData_Transfer', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Transfer', 'COLUMN', N'Requerimiento Total'
GO
