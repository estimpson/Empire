CREATE TABLE [dbo].[destination_package]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[package] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[customer_box_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cum] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[destination_package] ADD CONSTRAINT [PK__destination_pack__23FE4082] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
