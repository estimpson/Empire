CREATE TABLE [dbo].[Sheet1]
(
[base_part] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2010] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jan_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Feb_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mar_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Apr_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[May_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jun_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jul_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aug_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sep_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Oct_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nov_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dec_11_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2011] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jan_12_Demand_] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Feb_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mar_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Apr_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[May_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jun_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jul_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aug_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sep_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Oct_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nov_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dec_12_Demand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2012] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2013] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2014] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2015] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Demand_2016] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales_2010_] [money] NULL,
[Jan_11_Sales_] [money] NULL,
[Feb_11_Sales_] [money] NULL,
[Mar_11_Sales_] [money] NULL,
[Apr_11_Sales_] [money] NULL,
[May_11_Sales_] [money] NULL,
[Jun_11_Sales_] [money] NULL,
[Jul_11_Sales_] [money] NULL,
[Aug_11_Sales_] [money] NULL,
[Sep_11_Sales_] [money] NULL,
[Oct_11_Sales_] [money] NULL,
[Nov_11_Sales_] [money] NULL,
[Dec_11_Sales_] [money] NULL,
[Sales_2011] [money] NULL,
[Jan_12_Sales_] [money] NULL,
[Feb_12_Sales_] [money] NULL,
[Mar_12_Sales_] [money] NULL,
[Apr_12_Sales_] [money] NULL,
[May_12_Sales_] [money] NULL,
[Jun_12_Sales_] [money] NULL,
[Jul_12_Sales_] [money] NULL,
[Aug_12_Sales_] [money] NULL,
[Sep_12_Sales_] [money] NULL,
[Oct_12_Sales_] [money] NULL,
[Nov_12_Sales_] [money] NULL,
[Dec_12_Sales_] [money] NULL,
[Sales_2012] [money] NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'AlternateBackShade', N'100', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'AlternateBackThemeColorIndex', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'AlternateBackTint', N'100', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'Attributes', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'BackShade', N'100', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'BackTint', N'100', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'DatasheetForeThemeColorIndex', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'DatasheetGridlinesThemeColorIndex', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'DateCreated', N'1/11/2012 4:04:04 PM', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'DisplayViewsOnSharePointSite', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'FilterOnLoad', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'HideNewField', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'LastUpdated', N'1/11/2012 4:04:05 PM', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DefaultView', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_OrderByOn', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Orientation', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'Name', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'OrderByOnLoad', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'ReadOnlyWhenDisconnected', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'RecordCount', N'413', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'ThemeFontIndex', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'TotalsRow', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'Updatable', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', NULL, NULL
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'ॷꩍέ䫧⎶䰤숈節', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Apr_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Apr_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'』䫱专ಒ熷ሗ', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Apr_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'36', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Apr_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'ۺ᥽䬘鲁㥡멒ృ', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Apr_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'18', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Apr_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'边ꀛ꜀䟽⮶苆ꏩ匼', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Apr_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'49', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Apr_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Apr_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'ﱚ밗䳏䍿檴︫�뷔', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Aug_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'9', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Aug_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'Ͷど佇撋┪��', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Aug_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'40', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Aug_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'塀ᾷ㡷䤴骄칧肸펬', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Aug_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'22', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Aug_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'�䮶冮䋲�厄뽺市', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Aug_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'53', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Aug_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Aug_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'GUID', N'臿�嶓䈬芘쉲䎤⠆', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'Name', N'base_part', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'SourceField', N'base_part', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'base_part'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'鎠炫ࢋ䊍焃టᅎ', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Dec_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'13', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Dec_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'⼱㯨㭆䨏�鍬眊', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Dec_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'44', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Dec_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'⒤˸恅䁀Ⴓ辶踞', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Dec_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'26', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Dec_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'域띤䖇蚶䯺㕳', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Dec_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'57', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Dec_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Dec_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'GUID', N'磫롺䮧঄㪺੮뾻', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2010', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2010', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2010'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'GUID', N'纙損垙䊸䦪頦擟', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2011', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'14', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2011', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2011'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'GUID', N'黏立鉲䐪⺋豐⸰', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2012', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'27', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2012', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2012'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'GUID', N'憐㷡䳘邉�纸', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2013', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'28', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2013', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2013'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'GUID', N'犎楰倉䕤뺜毲̳', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2014', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'29', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2014', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2014'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'GUID', N'㩧乭應丙麘幒≚', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2015', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'30', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2015', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2015'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'GUID', N'휙쳏缼䐠ﲸ刉↜锝', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'Name', N'Demand_2016', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'31', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'SourceField', N'Demand_2016', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Demand_2016'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'䱚䐄䨟㊪摝ం萉', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Feb_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Feb_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'鸕뽇ⶒ䄖垲魁蕕快', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Feb_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'34', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Feb_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'컾鶵퐫䵱嶆狐迟൤', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Feb_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'16', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Feb_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'㝃㧬씮䝩ྤ睱瑓敶', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Feb_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'47', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Feb_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Feb_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'殒칠ﱩ䘅榞慦쐑葾', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Jan_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jan_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'乐�쀐䙥즫碔ᖮă', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Jan_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'33', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jan_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'GUID', N'癖첗䠶璛龳ﶲ', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'Name', N'Jan_12_Demand_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'15', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jan_12_Demand_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Demand_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'ク䐘怖䘡嶋葤兜', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Jan_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'46', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jan_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jan_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'鹼쐩猎䙍ᒹ勁㛀갮', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Jul_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jul_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'芩삋杯䊰涖䱕퀁', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Jul_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'39', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jul_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'ೝ䔵ඵꅱ務', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Jul_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'21', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jul_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'緷숿ꓫ䔱亚싣', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Jul_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'52', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jul_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jul_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'韛䷟䚚턞ၳ遖', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Jun_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'7', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jun_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'䦸䂯᠏⫳᮹', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Jun_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'38', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jun_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'囟∃顋䐾�씻ꫢ槜', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'@', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Jun_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'20', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jun_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'剨怷䳨�曓䖻깹', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Jun_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'51', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Jun_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Jun_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'ﶶ撪눋今鞀뗡杬⊸', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Mar_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'4', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Mar_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'䥮䚰檝䆤ʥ䓒鲎డ', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Mar_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'35', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Mar_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'毜⠉❖䯦ꚑ끍ꧪ蝑', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Mar_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'17', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Mar_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'褔ඐ�䖍ﶖ⌮驢屑', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Mar_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'48', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Mar_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Mar_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'싇倶⢢䩳⊵巑ᅋ㵃', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'May_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'6', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'May_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'ว⡌탎䋀ꎽ᪮憘䤛', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'May_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'37', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'May_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'ꆫ⫗䱟΋酑⺖灈', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'May_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'19', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'May_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'逩똉ṕ䖖Ẵ覵䝢徛', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'May_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'50', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'May_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'May_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'뉉ﵝ䌬薙ᩗ漆', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Nov_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'12', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Nov_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'쬡ʹ浄䏣颫犔舊좢', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Nov_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'43', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Nov_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'㝬䔲莤「飹鐆', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Nov_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'25', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Nov_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'腍飵ⵥ䗰쒍ꭅ䶎輫', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Nov_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'56', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Nov_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Nov_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'흇ℯ�䞝銰됑쨧', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Oct_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'11', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Oct_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'⼵ಯ绗䇢릣踞ユ⇫', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Oct_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'42', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Oct_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'쒣킵嚛佐暛ދꠟᨶ', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Oct_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'24', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Oct_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'츏䌫ꂚ箬冣', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Oct_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'55', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Oct_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Oct_12_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'GUID', N'ᾓ쫀䜪Ꚋ�赾䙊', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'Name', N'Sales_2010_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'32', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Sales_2010_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2010_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'GUID', N'ネ鯧κ䅱皾㷉ᘞ陈', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'Name', N'2011_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'45', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'SourceField', N'2011_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2011'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'GUID', N'닧ᮛ⏆䝓抨鲯ﾓ躴', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'Name', N'Sales_2012', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'58', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'SourceField', N'Sales_2012', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sales_2012'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'螜턝뺜䱂뚛ᙲ毦', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Sep_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Sep_11_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'햽틬ﭙ䷢��㢸녊', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Sep_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'41', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Sep_11_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_11_Sales_'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'True', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'Attributes', N'2', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'GUID', N'鲌ﹾ䦚梆�Ὶ척', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_DisplayControl', N'109', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_Format', N'* #,##0;* (#,##0);* -', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMEMode', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'MS_IMESentMode', N'3', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'Name', N'Sep_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'23', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'Size', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceField', N'Sep_12_Demand', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'Type', N'10', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'UnicodeCompression', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Demand'
GO
EXEC sp_addextendedproperty N'AggregateType', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'AllowZeroLength', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'AppendOnly', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'Attributes', N'1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'CollatingOrder', N'1033', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnHidden', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnOrder', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'ColumnWidth', N'-1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'CurrencyLCID', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'DataUpdatable', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'GUID', N'䢑姬餕䣼ﶔ浀씁涘', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_DecimalPlaces', N'255', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'MS_Format', N'$#,##0.00;($#,##0.00)', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'Name', N'Sep_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'OrdinalPosition', N'54', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'Required', N'False', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'ResultType', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'Size', N'8', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceField', N'Sep_12_Sales_', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'SourceTable', N'Sheet1', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'TextAlign', N'0', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
EXEC sp_addextendedproperty N'Type', N'5', 'SCHEMA', N'dbo', 'TABLE', N'Sheet1', 'COLUMN', N'Sep_12_Sales_'
GO
