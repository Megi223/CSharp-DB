using Microsoft.Data.SqlClient;
using System;

namespace P02.VillainNames
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            string minionsConnectionString = @"Server=(localdb)\MSSQLLocalDB;Database=MinionsDB;Integrated security=true";
            SqlConnection minionsSqlConnection = new SqlConnection(minionsConnectionString);
            using (minionsSqlConnection)
            {
                minionsSqlConnection.Open();
                string queryText = @"SELECT v.Name, COUNT(mv.VillainId) AS MinionsCount  
                                        FROM Villains AS v 
                                        JOIN MinionsVillains AS mv ON v.Id = mv.VillainId 
                                        GROUP BY v.Id, v.Name 
                                        HAVING COUNT(mv.VillainId) > 3 
                                        ORDER BY COUNT(mv.VillainId)";
                SqlCommand queryCommand = new SqlCommand(queryText, minionsSqlConnection);
                SqlDataReader reader = queryCommand.ExecuteReader();
                using (reader)
                {
                    while (reader.Read())
                    {
                        string name = reader["Name"]?.ToString();
                        string numberOfMinions = reader.GetInt32(1).ToString();
                        Console.WriteLine($"{name} - {numberOfMinions}");
                    }
                }

            }

        }
    }
}
