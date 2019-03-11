using DbLab2.Interfaces;
using DbLab2.Models;
using DbLab2.ViewModels;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DbLab2.Services
{
    public class CarRepository : ICarRepository
    {
        private readonly SqlConnection _connection;
        public CarRepository(SqlConnection connection)
        {
            _connection = connection;
        }

        public async Task CreateCar(ViewModelCarAdd Car)
        {
            SqlCommand command = new SqlCommand("sp_CreateCar", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@transmission", Car.Transmission);
            command.Parameters.AddWithValue("@color", Car.Color);
            command.Parameters.AddWithValue("@price", Car.Price);
            command.Parameters.AddWithValue("@engine_type", Car.Engine_type);
            command.Parameters.AddWithValue("@body_type", Car.Body_type);
            command.Parameters.AddWithValue("@name", Car.Name);
            await command.ExecuteNonQueryAsync();
        }

        public async Task DeleteCar(int id)
        {
            SqlCommand command = new SqlCommand("sp_DeleteCar", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@carId", id);
            await command.ExecuteNonQueryAsync();
        }

        public async Task<List<Car>> GetCars()
        {
            List<Car> employeeList = new List<Car>();
            SqlCommand command = new SqlCommand("sp_GetCars", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            SqlDataReader reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                Car car = new Car
                {
                    Id = reader.GetInt32(0),
                    Transmission = reader.GetString(1),
                    Price = reader.GetInt32(2),
                    Color = reader.GetString(3)
                };
                employeeList.Add(car);
            }
            return employeeList;
        }

        public async Task UpdateCar(Car Car)
        {
            SqlCommand command = new SqlCommand("sp_UpdateCar", _connection)
            {
                CommandType = CommandType.StoredProcedure
            };
            command.Parameters.AddWithValue("@transmission", Car.Transmission);
            command.Parameters.AddWithValue("@color", Car.Color);
            command.Parameters.AddWithValue("@price", Car.Price);
            command.Parameters.AddWithValue("@engine_type", Car.Model.Engine_type);
            command.Parameters.AddWithValue("@body_type", Car.Model.Body_type);
            command.Parameters.AddWithValue("@name", Car.Model.Name);
            command.Parameters.AddWithValue("@modelId", Car.ModelId);
            command.Parameters.AddWithValue("@carId", Car.Id);
            await command.ExecuteNonQueryAsync();

        }
    }
}