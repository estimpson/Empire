CREATE TABLE [dbo].[temp_trw_prices]
(
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_trw_prices] ADD CONSTRAINT [PK_temp_trw_prices] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
