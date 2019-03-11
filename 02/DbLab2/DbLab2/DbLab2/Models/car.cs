using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DbLab2.Models
{

    [Table("car")]
    public partial class Car
    {
        public Car()
        {
            Orders = new HashSet<Order>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Transmission { get; set; }

        public int Price { get; set; }

        public int ModelId { get; set; }

        public string Color { get; set; }

        public virtual Model Model { get; set; }

        public virtual ICollection<Order> Orders { get; set; }
    }
}
