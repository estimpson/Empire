CREATE TYPE [dbo].[n] FROM numeric (20, 6) NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[n] TO [public]
GO
