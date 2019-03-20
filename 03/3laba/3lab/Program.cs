using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public class StoredProcedures
{
    [SqlProcedure]
    public static int GetHack(int a)
    {
        int rows;
        SqlConnection conn = new SqlConnection("Context Connection=true");
        conn.Open();
        SqlCommand sqlCmd = conn.CreateCommand();
        sqlCmd.CommandText = @"select count(*) from [dbo].[tblHack] where [HackID]=@firstvalue;";
        sqlCmd.Parameters.Add("@firstvalue", a); 
        rows = (int)sqlCmd.ExecuteScalar();
        conn.Close();
        return rows;
    }
}