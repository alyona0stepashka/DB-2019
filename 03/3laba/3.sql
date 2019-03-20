--Среда CLR разрешается и запрещается посредством опции clr_enabled системной процедуры sp_configure, которая запускается на выполнение инструкцией RECONFIGURE.

USE [FridgyKeyDB]

exec sp_configure 'clr_enabled', 1
exec sp_configure 'clr_strict_security', 0
reconfigure
drop assembly CLRStoredProcedures
 create assembly CLRStoredProcedures
	from 'D:\Study\3k2s\GitRep\DB-2019\03\3laba\3lab\bin\Debug\3lab.dll'
	with permission_set = safe;

go
create procedure GetHack (@firstvalue int)
	as external name CLRStoredProcedures.StoredProcedures.GetHack

declare @ques int;	 
exec @ques = GetHack '8';
print @ques;

select * from tblHack;


