CREATE TABLE [dbo].[insert_pv]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[insert_pv] ADD CONSTRAINT [PK__insert_pv__4DB4832C] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
