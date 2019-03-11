using DbLab2.Data;
using DbLab2.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace DbLab2.Controllers
{
    public class EmployeeController : Controller
    {
        readonly UnitOfWork db = UnitOfWork.DB;

        public async Task<ActionResult> Index()
        {
            List<Employee> listEmpployee = new List<Employee>();
            listEmpployee = await db.EmloyeeRepository.GetAllEmployees();
            return View(listEmpployee);
        }
        // GET: Employee/Create
        public ActionResult Create() => View();

        // POST: Employee/Create
        [HttpPost]
        public async Task<ActionResult> Create(Employee employee)
        {
            if (ModelState.IsValid)
            {
                await db.EmloyeeRepository.CreateEmployee(employee);
                return RedirectToAction("Index");
            }
            return View();
        }
    }
}
