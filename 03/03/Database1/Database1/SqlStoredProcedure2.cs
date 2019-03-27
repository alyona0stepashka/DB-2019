using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void SqlStoredProcedure2 ()
    {
        SqlCommand command = new SqlCommand
        {
            Connection = new SqlConnection("Context connection = true")
        };
        command.Connection.Open();
        string sql_string = $"select [Username],[1],[2],[3] from [tblUser] PIVOT(count([tblUser].[UserID]) for [tblUser].[UserID] in([1],[2],[3])) as test_pivot";
        command.CommandText = sql_string.ToString();
        SqlContext.Pipe.ExecuteAndSend(command);
        command.Connection.Close();
    }

}

