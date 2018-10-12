CREATE TABLE [dbo].[MoldeoBOM]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRunner] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MoldeoBOM] ADD CONSTRAINT [PK__MoldeoBOM__11EC45B7] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
