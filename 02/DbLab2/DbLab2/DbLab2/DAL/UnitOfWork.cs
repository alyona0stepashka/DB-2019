using DbLab2.Interfaces;
using DbLab2.Services;
using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace DbLab2.Data
{
    public class UnitOfWork
    {
        public UnitOfWork()
        {
            string connectionString = WebConfigurationManager.ConnectionStrings["CarShopContext"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();
            CarRepository = new CarRepository(connection);
            EmloyeeRepository = new EmployeeRepository(connection);
            
        }
        
        public CarRepository CarRepository { get; set; }
        public EmployeeRepository EmloyeeRepository { get; set; }

        private static UnitOfWork db;
        
        public static UnitOfWork DB
        {
            get => db ?? (db = new UnitOfWork());
        }
    }
}