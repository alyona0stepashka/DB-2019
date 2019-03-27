using System;
using System.Text;
using System.Threading.Tasks;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

partial  class StoredProcedures
{
    [SqlProcedure]
    public static int GetKkal(int a)
    {
        int rows;
        SqlConnection conn = new SqlConnection("Context Connection=true");
        conn.Open();
        SqlCommand sqlCmd = conn.CreateCommand();
        sqlCmd.CommandText = @"select count(*) from [tblKkal] where [Kkal]<@firstvalue";
        sqlCmd.Parameters.AddWithValue("@firstvalue", a); 
        rows = (int)sqlCmd.ExecuteScalar();
        conn.Close();
        return rows;
    }
}