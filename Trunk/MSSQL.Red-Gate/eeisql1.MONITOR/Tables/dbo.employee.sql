CREATE TABLE [dbo].[employee]
(
[name] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[operator_code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[password] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[serial_number] [int] NULL,
[epassword] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operatorlevel] [int] NULL,
[employee] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[npassword] [varbinary] (255) NULL,
[EmployeeID] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [PK__employee__7D78A4E7] PRIMARY KEY CLUSTERED  ([operator_code]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [UQ__employee__7E6CC920] UNIQUE NONCLUSTERED  ([password]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employee] ADD CONSTRAINT [UQ__employee__7F60ED59] UNIQUE NONCLUSTERED  ([password]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[employee] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[employee] TO [APPUser]
GO
