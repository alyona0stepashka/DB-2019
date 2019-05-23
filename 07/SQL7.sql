


----------------------1
create table TableLab7 (
id INTEGER primary key identity(1,1),
xml_column XML
);

create table Users (
id INTEGER primary key identity(1,1),
name nvarchar(50));

insert into Users(name) values('anna');
insert into Users(name) values('alyona');

create table Students (
id_stud INTEGER primary key identity(1,1),
adress nvarchar(50));
insert into Students(adress) values ('Mozyr');
insert into Students(adress) values ('Minsk');

create table Teacher(
 id_teach INTEGER primary key identity(1,1),
subjects nvarchar(50));
insert into Teacher(subjects) values ('Russian');
insert into Teacher(subjects) values ('maths');
--------------------2	

create procedure generateXML
as
declare @x XML
set @x = (Select Name [name], 
Id [id], GETDATE() [date]  
from Users u join Students s on u.id = s.id_stud
join Teacher t on t.id_teach = s.id_stud
FOR XML AUTO);
SELECT @x
go

execute generateXML;

---------------------3
create procedure InsertInTableLab7
as
DECLARE  @s XML  
SET @s = (Select Name [name], 
Id [id], GETDATE() [date]  
from Users u join Students s on u.id = s.id_stud
join Teacher t on t.id_teach = s.id_stud
for xml raw);
--FOR XML AUTO, TYPE);
insert into TableLab7 values(@s);
go
  
  execute InsertInTableLab7
  select * from TableLab7;

------------------4 ???????????????
create primary xml index XML_Index on TableLab7(xml_column);

select * from TableLab7
------------------5
create procedure SelectXML
as
select xml_column.query('/row') as[xml_column] from TableLab7 for xml auto, type;
go

execute SelectXML;