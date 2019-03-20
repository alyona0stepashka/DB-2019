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
        string sql_string = $"select ID_QUESTION,QUESTION,[42],[1051],[1052],[1053] from QUESTION PIVOT(count(QUESTION.ID_TEST) for QUESTION.ID_TEST in([42],[1051],[1052],[1053]))as test_pivott";
        command.CommandText = sql_string.ToString();
        SqlContext.Pipe.ExecuteAndSend(command);
        command.Connection.Close();
    }

}

