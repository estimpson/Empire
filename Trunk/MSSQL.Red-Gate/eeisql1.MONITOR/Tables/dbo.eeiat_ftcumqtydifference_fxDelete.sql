CREATE TABLE [dbo].[eeiat_ftcumqtydifference_fxDelete]
(
[atqty] [numeric] (20, 6) NULL,
[ftqty] [numeric] (20, 6) NULL,
[ponumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[eeiat_ftcumqtydifference_fxDelete] ADD CONSTRAINT [PK__eeiat_ftcumqtydi__5FB337D6] PRIMARY KEY CLUSTERED  ([ponumber], [part]) ON [PRIMARY]
GO
