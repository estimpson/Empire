CREATE TABLE [dbo].[alc_quote_date_fxDelete]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quote_date] [datetime] NULL,
[price] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[alc_quote_date_fxDelete] ADD CONSTRAINT [PK__alc_quote_date__02E7657A] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
