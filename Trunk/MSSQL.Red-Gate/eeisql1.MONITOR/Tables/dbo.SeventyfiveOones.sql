CREATE TABLE [dbo].[SeventyfiveOones]
(
[SeventyfiveOone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[datecreated] [datetime] NULL CONSTRAINT [DF__Seventyfi__datec__5E54FF49] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SeventyfiveOones] ADD CONSTRAINT [PK__SeventyfiveOones__5D60DB10] PRIMARY KEY CLUSTERED  ([SeventyfiveOone]) ON [PRIMARY]
GO
