CREATE TABLE [EEIUser].[sales_1_temp]
(
[forecast_name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[time_stamp] [datetime] NULL,
[program_manager] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[base_part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[forecast_year] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[forecast_period] [numeric] (2, 0) NOT NULL,
[forecast_units] [numeric] (18, 6) NULL,
[selling_price] [numeric] (18, 6) NULL,
[forecast_sales] [numeric] (18, 6) NULL
) ON [PRIMARY]
GO
