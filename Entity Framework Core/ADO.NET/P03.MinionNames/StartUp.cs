using Microsoft.Data.SqlClient;
using System;
using System.Text;

namespace P03.MinionNames
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            string minionsConnectionString = @"Server=(localdb)\MSSQLLocalDB;Database=MinionsDB;Integrated security=true";
            SqlConnection minionsSqlConnection = new SqlConnection(minionsConnectionString);
            string inputId = Console.ReadLine();
            StringBuilder sb = new StringBuilder();
            using (minionsSqlConnection)
            {
                minionsSqlConnection.Open();
                string findingSuitableVillianText = @"SELECT Name FROM Villains WHERE Id =                                               @Id";
                SqlCommand findingSuitableVillianCmd = new SqlCommand(findingSuitableVillianText, minionsSqlConnection);
                findingSuitableVillianCmd.Parameters.AddWithValue("@Id", inputId);
                string name = findingSuitableVillianCmd.ExecuteScalar()?.ToString();
                if (name == null)
                {
                    Console.WriteLine($"No villain with ID {inputId} exists in the database.");
                    return;
                }
                sb.AppendLine($"Villain: {name}");

                string minionsToVillainText = @"SELECT ROW_NUMBER() OVER (ORDER BY m.Name) as                               RowNum,
                                                 m.Name, 
                                                 m.Age
                                                 FROM MinionsVillains AS mv
                                                 JOIN Minions As m ON mv.MinionId = m.Id
                                                 WHERE mv.VillainId = @Id
                                                 ORDER BY m.Name";
                SqlCommand minionsToVillainCmd = new SqlCommand(minionsToVillainText, minionsSqlConnection);
                minionsToVillainCmd.Parameters.AddWithValue("@Id", inputId);
                SqlDataReader reader = minionsToVillainCmd.ExecuteReader();
                using (reader)
                {
                    if (!reader.HasRows)
                    {
                        sb.AppendLine("(no minions)");
                    }
                    else
                    {
                        int cnt = 1;
                        while (reader.Read())
                        {
                            string minionName = reader["Name"]?.ToString();
                            string minionAge = reader["Age"]?.ToString();
                            sb.AppendLine($"{cnt}. {minionName} {minionAge}");
                            cnt++;
                        }
                        

                    }
                }
                sb.ToString().TrimEnd();
                Console.WriteLine(sb);
            }
        }
    }
}
