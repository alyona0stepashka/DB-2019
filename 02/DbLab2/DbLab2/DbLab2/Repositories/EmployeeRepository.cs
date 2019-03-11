using DbLab2.Interfaces;
using DbLab2.Models;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DbLab2.Services
{
    public class EmployeeRepository : IEmloyeeRepository
    {
        private readonly SqlConnection _connection;
        public EmployeeRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        public async Task CreateEmployee(Employee employee)
        {

            SqlCommand command = new SqlCommand("sp_CreateEmployee", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@name", employee.Name);
            command.Parameters.AddWithValue("@email", employee.Email);
            command.Parameters.AddWithValue("@password", employee.Password);
            await command.ExecuteNonQueryAsync();
        }

        public async Task<List<Employee>> GetAllEmployees()
        {
            List<Employee> employeeList = new List<Employee>();
            SqlCommand command = new SqlCommand("sp_GetEmployee", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            SqlDataReader reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                Employee employee = new Employee
                {
                    Name = reader.GetString(3),
                    Email = reader.GetString(1),
                    Password = reader.GetString(2),
                    Id = reader.GetInt32(0)
                };
                employeeList.Add(employee);
            }
            return employeeList;
        }
    }
}