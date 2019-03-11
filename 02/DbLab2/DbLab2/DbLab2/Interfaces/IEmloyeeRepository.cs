using DbLab2.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DbLab2.Interfaces
{
    public interface IEmloyeeRepository
    {
        Task<List<Employee>> GetAllEmployees();
        Task CreateEmployee(Employee employee);
    }
}
