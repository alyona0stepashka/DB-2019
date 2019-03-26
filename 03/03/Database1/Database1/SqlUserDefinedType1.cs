using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, MaxByteSize = 8000)]
public struct SqlUserDefinedType1 : INullable, IBinarySerialize
{
    String Num;
    String Modell;
    String Year;
    public override string ToString()
    {
        // Заменить на собственный код
        return $"Номер: {Num}";
    }

    public bool IsNull
    {
        get
        {
            // Введите здесь код
            return _null;
        }
    }

    public static SqlUserDefinedType1 Null
    {
        get
        {
            SqlUserDefinedType1 h = new SqlUserDefinedType1();
            h._null = true;
            return h;
        }
    }

    public static SqlUserDefinedType1 Parse(SqlString s)
    {
        string[] b = s.Value.Split(' ');
        if (s.IsNull)
            return Null;
        SqlUserDefinedType1 u = new SqlUserDefinedType1
        {
            Num = b[0],
            Modell = b[1],
            Year = b[2]
        };
        return u;
    }

    // Это метод-заполнитель
    public string Method1()
    {
        // Введите здесь код
        return string.Empty;
    }

    // Это статический метод заполнителя
    public static SqlString Method2()
    {
        // Введите здесь код
        return new SqlString("");
    }

    public void Read(BinaryReader r)
    {
        Num = r.ReadString();
    }

    public void Write(BinaryWriter w)
    {
        w.Write($"Номер: {Num}, Модель: {Modell}, Год :{Year}");
    }

    // Это поле элемента-заполнителя
    public int _var1;

    // Закрытый член
    private bool _null;
}