using FootballClubsApp;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;

public class ClubsRepository
{
    public List<Club> GetAll()
    {
        List<Club> clubs = new List<Club>();
        string sql = "SELECT ClubId, Name, City, CreatedAt FROM clubs ORDER BY Name";

        DataTable dt = Db.GetDataTable(sql);
        foreach (DataRow row in dt.Rows)
        {
            clubs.Add(new Club
            {
                ClubId = Convert.ToInt32(row["ClubId"]),
                Name = row["Name"].ToString(),
                City = row["City"].ToString(),
                CreatedAt = Convert.ToDateTime(row["CreatedAt"])
            });
        }

        return clubs;
    }

    public void Add(Club club)
    {
        string sql = "INSERT INTO clubs (Name, City) VALUES (@name, @city)";
        Db.ExecuteNonQuery(sql,
            new MySqlParameter("@name", club.Name),
            new MySqlParameter("@city", club.City));
    }

    public void Update(Club club)
    {
        string sql = "UPDATE clubs SET Name=@name, City=@city WHERE ClubId=@id";
        Db.ExecuteNonQuery(sql,
            new MySqlParameter("@name", club.Name),
            new MySqlParameter("@city", club.City),
            new MySqlParameter("@id", club.ClubId));
    }

    public void Delete(int id)
    {
        string sql = "DELETE FROM clubs WHERE ClubId=@id";
        Db.ExecuteNonQuery(sql, new MySqlParameter("@id", id));
    }
}