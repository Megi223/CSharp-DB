using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Text;

namespace P05.ChangeTownNamesCasing
{
    public class StartUp
    {
        static void Main(string[] args)
        {
            string countryName = Console.ReadLine();
            string minionsConnectionString = @"Server=(localdb)\MSSQLLocalDB;Database=MinionsDB;Integrated security=true";
            SqlConnection minionsSqlConnection = new SqlConnection(minionsConnectionString);
            StringBuilder sb = new StringBuilder();
            using (minionsSqlConnection)
            {
                minionsSqlConnection.Open();
                int countryId = GetCountryId(countryName, minionsSqlConnection);
                int affectedRows = UpdateCitiesNames(minionsSqlConnection, countryId);
                if (affectedRows == 0)
                {
                    sb.AppendLine("No town names were affected.");
                }
                else
                {
                    string namesArrSeparatedByCommas = GetNewCitiesNames(minionsSqlConnection, countryId);
                    sb.AppendLine($"{affectedRows} town names were affected.")
                        .AppendLine($"[{namesArrSeparatedByCommas}]");
                }
                sb.ToString().TrimEnd();
                Console.WriteLine(sb);
            }


        }

        private static string GetNewCitiesNames(SqlConnection minionsSqlConnection, int countryId)
        {
            List<string> namesArr = new List<string>();
            string getCitiesNamesText = @"SELECT [Name]
                                                    FROM Towns
                                                    WHERE CountryCode = @countryId";
            SqlCommand getCitiesNamesCmd = new SqlCommand(getCitiesNamesText, minionsSqlConnection);
            getCitiesNamesCmd.Parameters.AddWithValue("@countryId", countryId);
            SqlDataReader reader = getCitiesNamesCmd.ExecuteReader();
            using (reader)
            {
                while (reader.Read())
                {
                    string name = reader["Name"].ToString();
                    namesArr.Add(name);
                }
            }
            string namesArrSeparatedByCommas = string.Join(", ", namesArr);
            return namesArrSeparatedByCommas;
        }

        private static int UpdateCitiesNames(SqlConnection minionsSqlConnection, int countryId)
        {
            string updateCitiesText = @"UPDATE Towns
                                            SET Name = UPPER(Name)
                                            WHERE CountryCode = @countryId";
            SqlCommand updateCitiesCmd = new SqlCommand(updateCitiesText, minionsSqlConnection);
            updateCitiesCmd.Parameters.AddWithValue("@countryId", countryId);
            int affectedRows = updateCitiesCmd.ExecuteNonQuery();
            return affectedRows;
        }

        private static int GetCountryId(string countryName, SqlConnection minionsSqlConnection)
        {
            string getCountryIdText = @"SELECT Id FROM Countries
                                                WHERE [Name]=@name";
            SqlCommand getCountryIdCmd = new SqlCommand(getCountryIdText, minionsSqlConnection);
            getCountryIdCmd.Parameters.AddWithValue("@name", countryName);
            int countryId = int.Parse(getCountryIdCmd.ExecuteScalar()?.ToString());
            return countryId;
        }
    }
}
