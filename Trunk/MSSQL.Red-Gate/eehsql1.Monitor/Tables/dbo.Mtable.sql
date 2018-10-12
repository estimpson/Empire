CREATE TABLE [dbo].[Mtable]
(
[IDTable] [numeric] (18, 0) NOT NULL IDENTITY(1, 1),
[NameTable] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Query] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PuedeBorrarRegistro] [bit] NULL CONSTRAINT [DF__Mtable__PuedeBor__6F19A174] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Mtable] ADD CONSTRAINT [PK_Mtable] PRIMARY KEY CLUSTERED  ([IDTable]) ON [PRIMARY]
GO
