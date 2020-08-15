using Microsoft.Data.SqlClient;
using System;
using System.Globalization;
using System.Linq;
using System.Text;

namespace P04.AddMinion
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            string minionsConnectionString = @"Server=(localdb)\MSSQLLocalDB;Database=MinionsDB;Integrated security=true";
            SqlConnection minionsSqlConnection = new SqlConnection(minionsConnectionString);
            string[] inputMinionInfo = Console.ReadLine().Split(": ").ToArray();
            string[] inputVillainInfo = Console.ReadLine().Split(": ").ToArray();
            
            string minionParametersString = inputMinionInfo[1].ToString();
            string[] minionParametersArr = minionParametersString.Split(" ").ToArray();
            string minionName = minionParametersArr[0];
            string minionAge = minionParametersArr[1]; //cast to int???
            string minionTown = minionParametersArr[2];

            string villainName = inputVillainInfo[1];
            StringBuilder sb = new StringBuilder();
            using (minionsSqlConnection)
            {
                minionsSqlConnection.Open();
                string townId = EnsureTownExists(minionsSqlConnection, minionTown, sb);
                EnsureVillainExists(minionsSqlConnection, villainName, sb);
                AddMinionToDatabase(minionsSqlConnection, minionName, minionAge, townId);
                string minionId = GetMinionId(minionsSqlConnection, minionName);
                string villainId = GetVillainId(minionsSqlConnection, villainName);
                AddMinionToVillain(minionsSqlConnection, minionName, villainName, sb, minionId, villainId);
                sb.ToString().TrimEnd();
                Console.WriteLine(sb);
            }
        }

        private static void AddMinionToVillain(SqlConnection minionsSqlConnection, string minionName, string villainName, StringBuilder sb, string minionId, string villainId)
        {
            string insertMinionToVillainText = @"INSERT INTO MinionsVillains (MinionId,                                         VillainId) VALUES (@villainId,                                             @minionId)";
            SqlCommand insertMinionToVillainCmd = new SqlCommand(insertMinionToVillainText, minionsSqlConnection);
            insertMinionToVillainCmd.Parameters.AddRange(new[]
            {
                    new SqlParameter("@villainId",villainId),
                    new SqlParameter("@minionId",minionId)
                });
            sb.AppendLine($"Successfully added {minionName} to be minion of {villainName}.");
        }

        private static string GetVillainId(SqlConnection minionsSqlConnection, string villainName)
        {
            string getVillainIdText = @"SELECT Id FROM Villains WHERE Name = @Name";
            SqlCommand getVillainIdCmd = new SqlCommand(getVillainIdText, minionsSqlConnection);
            getVillainIdCmd.Parameters.AddWithValue("@Name", villainName);
            string villainId = getVillainIdCmd.ExecuteScalar()?.ToString();
            return villainId;
        }

        private static string GetMinionId(SqlConnection minionsSqlConnection, string minionName)
        {
            string getMinionIdText = @"SELECT Id FROM Minions WHERE Name = @Name";
            SqlCommand getMinioinIdCmd = new SqlCommand(getMinionIdText, minionsSqlConnection);
            getMinioinIdCmd.Parameters.AddWithValue("@Name", minionName);
            string minionId = getMinioinIdCmd.ExecuteScalar()?.ToString();
            return minionId;
        }

        private static void AddMinionToDatabase(SqlConnection minionsSqlConnection, string minionName, string minionAge, string townId)
        {
            string insertMinionText = @"INSERT INTO Minions (Name, Age, TownId) VALUES                              (@name, @age, @townId)";
            SqlCommand insertMinionCmd = new SqlCommand(insertMinionText, minionsSqlConnection);
            insertMinionCmd.Parameters.AddRange(new[]
            {
                    new SqlParameter("@name",minionName),
                    new SqlParameter("@age",minionAge),
                    new SqlParameter("@townId",townId)
                });
            insertMinionCmd.ExecuteNonQuery();
        }

        private static void EnsureVillainExists(SqlConnection minionsSqlConnection, string villainName, StringBuilder sb)
        {
            string villainExistsText = @"SELECT Id FROM Villains WHERE Name = @Name";
            SqlCommand villainExistsCmd = new SqlCommand(villainExistsText, minionsSqlConnection);
            villainExistsCmd.Parameters.AddWithValue("@Name", villainName);
            string villainId = villainExistsCmd.ExecuteScalar()?.ToString();
            if (villainId == null)
            {
                string addVillain = @"INSERT INTO Villains (Name, EvilnessFactorId)                             VALUES (@villainName, 4)";
                SqlCommand addVillainCmd = new SqlCommand(addVillain, minionsSqlConnection);
                addVillainCmd.Parameters.AddWithValue("@villainName", villainName);
                addVillainCmd.ExecuteNonQuery();
                sb.AppendLine($"Villain {villainName} was added to the database.");
            }
        }

        private static string EnsureTownExists(SqlConnection minionsSqlConnection, string minionTown, StringBuilder sb)
        {
            string townExistsText = @"SELECT Id FROM Towns WHERE Name = @townName";
            SqlCommand townExistsCmd = new SqlCommand(townExistsText, minionsSqlConnection);
            townExistsCmd.Parameters.AddWithValue("@townName", minionTown);
            string townId = townExistsCmd.ExecuteScalar()?.ToString();
            if (townId == null)
            {
                string addTownText = "INSERT INTO Towns (Name) VALUES (@townName)";
                SqlCommand addTownCmd = new SqlCommand(addTownText, minionsSqlConnection);
                addTownCmd.Parameters.AddWithValue("@townName", minionTown);
                addTownCmd.ExecuteNonQuery();
                sb.AppendLine($"Town {minionTown} was added to the database.");
                townId = townExistsCmd.ExecuteScalar()?.ToString();
            }
            return townId;
        }
    }
}
