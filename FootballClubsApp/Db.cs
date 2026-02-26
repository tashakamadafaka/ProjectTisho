using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Data;

public class Db
{
    private static string connectionString =
        ConfigurationManager.ConnectionStrings["MyDb"].ConnectionString;

    public static MySqlConnection GetConnection()
    {
        return new MySqlConnection(connectionString);
    }

    public static int ExecuteNonQuery(string query, params MySqlParameter[] parameters)
    {
        using (var conn = GetConnection())
        {
            conn.Open();
            using (var cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteNonQuery();
            }
        }
    }

    public static DataTable GetDataTable(string query, params MySqlParameter[] parameters)
    {
        using (var conn = GetConnection())
        {
            conn.Open();
            using (var cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddRange(parameters);
                using (var adapter = new MySqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
        }
    }
}