CREATE TABLE [HN].[Meltflow_parts]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Meltflow_parts] ADD CONSTRAINT [PK__Meltflow__A15FB69445111EA8] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
GRANT SELECT ON  [HN].[Meltflow_parts] TO [APPUser]
GO
