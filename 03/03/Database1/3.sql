--Среда CLR разрешается и запрещается посредством опции clr_enabled системной процедуры sp_configure, 
--которая запускается на выполнение инструкцией RECONFIGURE.

USE [FridgyKeyDB]

exec sp_configure 'clr_enabled', 1
exec sp_configure 'clr_strict_security', 0
reconfigure
select * from [tblKkal]
select * from [tblUser]
 create assembly CLRStoredProcedures1
	from 'D:\Study\3k2s\GitRep\DB-2019\03\03\Database1\Database1\bin\Debug\Database1.dll'
	with permission_set = safe;

go
create procedure GetKkal (@firstvalue int)
	as external name CLRStoredProcedures1.StoredProcedures.GetKkal
	 
declare @ques int
exec @ques = GetKkal '50'
print @ques


create type eml
external name CLRStoredProcedures1.SqlUserDefinedType1
go
declare @s eml
set @s= '4321AA12 audi 2007'
select @s.ToString();

create procedure SqlStoredProcedure2
	as external name CLRStoredProcedures1.StoredProcedures.SqlStoredProcedure2

exec SqlStoredProcedure2
 
	drop procedure SqlStoredProcedure2
drop type eml
	drop proc GetKkal
drop assembly CLRStoredProcedures1