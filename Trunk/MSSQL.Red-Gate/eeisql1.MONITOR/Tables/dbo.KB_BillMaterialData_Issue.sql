CREATE TABLE [dbo].[KB_BillMaterialData_Issue]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Linea] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parte] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [decimal] (18, 6) NULL,
[Requerimiento] [decimal] (18, 6) NULL,
[Requerimiento Total] [decimal] (18, 6) NULL,
[materialista] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dia_inicio] [datetime] NULL,
[dia_actual] [datetime] NULL,
[entregado] [numeric] (18, 6) NULL,
[rebajado] [numeric] (18, 6) NULL,
[diasentregados] [numeric] (10, 7) NULL,
[diasacargar] [numeric] (18, 6) NULL,
[manualadd] [numeric] (18, 6) NULL,
[custom2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[KB_BillMaterialData_Issue] ADD CONSTRAINT [aaaaaBillMaterialData_PK] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [linea] ON [dbo].[KB_BillMaterialData_Issue] ([Linea]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [par] ON [dbo].[KB_BillMaterialData_Issue] ([Parte]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Attributes', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'DateCreated', N'09/19/2006 1:21:35 PM', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'LastUpdated', N'10/19/2006 10:16:40 AM', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DefaultView', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_OrderByOn', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Orientation', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'Name', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'RecordCount', N'2238', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'Updatable', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', NULL, NULL
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'GUID', N'莠粙࿱䝋릨꜐繹菇', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Name', N'Description', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'SourceField', N'Description', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'GUID', N'玛䫃늿ꌟ㰁䏕', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'Name', N'dia_actual', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'9', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'SourceField', N'dia_actual', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'Type', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_actual'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'GUID', N'ꑔ愮춥䅏ằ᪽섣綜', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'Name', N'dia_inicio', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'SourceField', N'dia_inicio', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'Type', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'dia_inicio'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'GUID', N'䷾˔ⷃ丞⸄덈', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'Name', N'diasacargar', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'13', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'SourceField', N'diasacargar', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasacargar'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'GUID', N'꽱ኢ䛛ꎛ홹ᅙ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Name', N'diasentregados', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'12', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'SourceField', N'diasentregados', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'diasentregados'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'GUID', N'თ⛩Ⲫ䢭㶧럟饋梃', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Name', N'entregado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'SourceField', N'entregado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'entregado'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Attributes', N'17', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1024', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'GUID', N'뀒쓯䅪Ґ옛젝轒', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Name', N'ID', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'SourceField', N'ID', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'1980', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'GUID', N'橻窍㰉䪭⮨', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Name', N'Linea', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'SourceField', N'Linea', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Linea'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'DefaultValue', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'GUID', N'ꙥ≇䵜꺹앖ᚫ턨', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'Name', N'manualadd', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'14', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'SourceField', N'manualadd', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'manualadd'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'GUID', N'氵↿低盦㿩', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Name', N'materialista', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'7', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Size', N'50', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'SourceField', N'materialista', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'materialista'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'2535', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'GUID', N'᧢ሟ䠯ត얄䒮ឪ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Name', N'Parte', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'2', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'SourceField', N'Parte', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Parte'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'GUID', N'僇큘雟䈬䒙먉Ķ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Name', N'Quantity', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'SourceField', N'Quantity', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'Type', N'7', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Quantity'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'GUID', N'䝔⵩᝔䀇薝렎ꥤ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Name', N'rebajado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'11', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Size', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'SourceField', N'rebajado', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'Type', N'4', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'rebajado'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'GUID', N'吺몊䬘皬䂑ꑪ', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Name', N'Requerimiento', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'5', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'SourceField', N'Requerimiento', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'Type', N'7', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'3082', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'GUID', N'ᣴ䈒ⶂí耘簫', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Name', N'Requerimiento Total', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'6', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'SourceField', N'Requerimiento Total', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'SourceTable', N'BillMaterialData', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
EXEC sp_addextendedproperty N'Type', N'7', 'SCHEMA', N'dbo', 'TABLE', N'KB_BillMaterialData_Issue', 'COLUMN', N'Requerimiento Total'
GO
