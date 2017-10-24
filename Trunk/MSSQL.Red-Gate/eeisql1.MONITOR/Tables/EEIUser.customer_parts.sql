CREATE TABLE [EEIUser].[customer_parts]
(
[customer_part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[default_distribution_point] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[customer_parts] ADD CONSTRAINT [PK_customer_parts] PRIMARY KEY CLUSTERED  ([customer_part]) ON [PRIMARY]
GO
