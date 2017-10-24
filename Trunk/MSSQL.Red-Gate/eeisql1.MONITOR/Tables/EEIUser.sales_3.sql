CREATE TABLE [EEIUser].[sales_3]
(
[program_manager] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[base_part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[forecast_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[forecast_time_stamp] [datetime] NULL,
[forecast_name_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[forecast_time_stamp_2] [datetime] NULL,
[forecast_year] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[forecast_period] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[forecast_units] [numeric] (18, 6) NULL,
[forecast_sales] [numeric] (18, 6) NULL,
[actual_units] [numeric] (18, 6) NULL,
[actual_sales] [numeric] (18, 6) NULL,
[variance_units] [numeric] (18, 6) NULL,
[variance_sales] [numeric] (18, 6) NULL,
[variance_percentage] [numeric] (18, 6) NULL,
[forecast_year_2] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[forecast_period_2] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[forecast_units_2] [numeric] (18, 6) NULL,
[forecast_sales_2] [numeric] (18, 6) NULL,
[actual_units_2] [numeric] (18, 6) NULL,
[actual_sales_2] [numeric] (18, 6) NULL,
[variance_units_2] [numeric] (18, 6) NULL,
[variance_sales_2] [numeric] (18, 6) NULL,
[variance_percentage_2] [numeric] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[sales_3] ADD CONSTRAINT [PK_sales_3] PRIMARY KEY CLUSTERED  ([base_part], [forecast_year], [forecast_period]) ON [PRIMARY]
GO
