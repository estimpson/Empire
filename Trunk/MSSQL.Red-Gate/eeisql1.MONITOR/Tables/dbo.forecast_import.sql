CREATE TABLE [dbo].[forecast_import]
(
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UnitMonth1] [numeric] (20, 6) NULL,
[UnitMonth2] [numeric] (20, 6) NULL,
[UnitMonth3] [numeric] (20, 6) NULL,
[UnitMonth4] [numeric] (20, 6) NULL,
[UnitMonth5] [numeric] (20, 6) NULL,
[UnitMonth6] [numeric] (20, 6) NULL,
[UnitMonth7] [numeric] (20, 6) NULL,
[UnitMonth8] [numeric] (20, 6) NULL,
[UnitMonth9] [numeric] (20, 6) NULL,
[UnitMonth10] [numeric] (20, 6) NULL,
[UnitMonth11] [numeric] (20, 6) NULL,
[UnitMonth12] [numeric] (20, 6) NULL,
[UnitPrice] [numeric] (20, 6) NULL,
[ExtendedMonth1] [numeric] (20, 6) NULL,
[ExtendedMonth2] [numeric] (20, 6) NULL,
[ExtendedMonth3] [numeric] (20, 6) NULL,
[ExtendedMonth4] [numeric] (20, 6) NULL,
[ExtendedMonth5] [numeric] (20, 6) NULL,
[ExtendedMonth6] [numeric] (20, 6) NULL,
[ExtendedMonth7] [numeric] (20, 6) NULL,
[ExtendedMonth8] [numeric] (20, 6) NULL,
[ExtendedMonth9] [numeric] (20, 6) NULL,
[ExtendedMonth10] [numeric] (20, 6) NULL,
[ExtendedMonth11] [numeric] (20, 6) NULL,
[ExtendedMonth12] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[forecast_import] ADD CONSTRAINT [PK_forecast_import] PRIMARY KEY CLUSTERED  ([BasePart]) ON [PRIMARY]
GO
