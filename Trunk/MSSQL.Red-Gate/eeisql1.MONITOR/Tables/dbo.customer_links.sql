CREATE TABLE [dbo].[customer_links]
(
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[link1] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link2] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link3] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link4] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link5] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link6] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link7] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link8] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link9] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link10] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[customer_links] ADD CONSTRAINT [PK__customer_links__28ED12D1] PRIMARY KEY CLUSTERED  ([customer]) ON [PRIMARY]
GO
