CREATE TABLE [dbo].[temp_alc_quote_date]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quote_date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_alc_quote_date] ADD CONSTRAINT [PK__temp_alc_quote_d__131DCD43] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
