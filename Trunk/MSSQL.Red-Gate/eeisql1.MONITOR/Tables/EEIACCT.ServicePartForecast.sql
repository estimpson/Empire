CREATE TABLE [EEIACCT].[ServicePartForecast]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ForecastYear] [int] NOT NULL,
[ForecastAmount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIACCT].[ServicePartForecast] ADD CONSTRAINT [PK__ServiceP__56655DB07991A086] PRIMARY KEY CLUSTERED  ([BasePart], [ForecastYear]) ON [PRIMARY]
GO
