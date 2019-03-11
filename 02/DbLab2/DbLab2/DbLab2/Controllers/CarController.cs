using DbLab2.Data;
using DbLab2.Models;
using DbLab2.Services;
using DbLab2.ViewModels;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace DbLab2.Controllers
{
    public class CarController : Controller
    {
        UnitOfWork db = UnitOfWork.DB;
        // GET: Car
        public async Task<ActionResult> Index()
        {
            List<Car> listCars = new List<Car>();
            listCars = await db.CarRepository.GetCars();
            return View(listCars);
        }

        // GET: Car/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Car/Create
        [HttpPost]
        public async Task<ActionResult> Create(ViewModelCarAdd car)
        {
            if (ModelState.IsValid)
            {
                await db.CarRepository.CreateCar(car);
                return RedirectToAction("Index");
            }
            return View();
        }

        // GET: Car/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Car/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Car/Delete
        public ActionResult Delete()
        {
            return View();
        }

        // DELETE: Car/Delete/5
        [HttpPost]
        public async Task<ActionResult> Delete(int id)
        {
            if (ModelState.IsValid)
            {
                await db.CarRepository.DeleteCar(id);
                return RedirectToAction("Index");
            }
            return View();
        }
    }
}
