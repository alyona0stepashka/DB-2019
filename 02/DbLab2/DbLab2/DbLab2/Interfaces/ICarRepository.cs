using DbLab2.Models;
using DbLab2.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DbLab2.Interfaces
{
    public interface ICarRepository
    {
        Task<List<Car>> GetCars();
        Task CreateCar(ViewModelCarAdd Car);
        Task UpdateCar(Car Car);
        Task DeleteCar(int id);
    }
}
