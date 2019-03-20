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
    public static int GetQuestion(int a, int b)
    {
        int rows;
        SqlConnection conn = new SqlConnection("Context Connection=true");
        conn.Open();
        SqlCommand sqlCmd = conn.CreateCommand();
        sqlCmd.CommandText = @"select count(*) from QUESTION where ID_QUESTION between @firstvalue and @secondvalue";
        sqlCmd.Parameters.Add("@firstvalue", a);
        sqlCmd.Parameters.Add("@secondvalue", b);
        rows = (int)sqlCmd.ExecuteScalar();
        conn.Close();
        return rows;
    }
}