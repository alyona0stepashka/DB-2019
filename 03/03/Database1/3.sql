--����� CLR ����������� � ����������� ����������� ����� clr_enabled ��������� ��������� sp_configure, 
--������� ����������� �� ���������� ����������� RECONFIGURE.

USE [KP]

exec sp_configure 'clr_enabled', 1
exec sp_configure 'clr_strict_security', 0
reconfigure
select * from QUESTION
drop assembly CLRStoredProcedures
 create assembly CLRStoredProcedures
	from 'E:\�������\3 ���� 2 ���\��\Database1\Database1\bin\Debug\Database1.dll'
	with permission_set = safe;

go
create procedure GetQuestion (@firstvalue int, @secondvalue int)
	as external name CLRStoredProcedures.StoredProcedures.GetQuestion
	drop proc GetQuestion
	 
declare @ques int
exec @ques = GetQuestion '50',' 2000'
print @ques

select * from QUESTION

drop type eml
create type eml
external name CLRStoredProcedures.SqlUserDefinedType1
go
declare @s eml
set @s= 'Savenko Anna ������������'
select @s.ToString();

create procedure SqlStoredProcedure2
	as external name CLRStoredProcedures.StoredProcedures.SqlStoredProcedure2

exec SqlStoredProcedure2
 