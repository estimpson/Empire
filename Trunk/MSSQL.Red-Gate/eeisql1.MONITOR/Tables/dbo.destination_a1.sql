CREATE TABLE [dbo].[destination_a1]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[field1] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field2] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field3] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field4] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field5] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field6] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field7] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field8] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field9] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field10] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field11] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field12] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc1] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc2] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc3] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc4] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc5] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc6] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc7] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc8] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc9] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc10] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc11] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field_desc12] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[destination_a1] ADD CONSTRAINT [PK__destination_a1__123EB7A3] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
