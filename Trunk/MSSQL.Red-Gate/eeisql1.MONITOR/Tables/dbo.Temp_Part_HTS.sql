CREATE TABLE [dbo].[Temp_Part_HTS]
(
[DefaultVendor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StdCost] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Commodity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTSDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTSCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Temp_Part_HTS] ADD CONSTRAINT [PK_Temp_Part_HTS] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
