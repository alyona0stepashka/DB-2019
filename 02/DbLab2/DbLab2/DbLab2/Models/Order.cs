using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DbLab2.Models
{

    [Table("order")]
    public partial class Order
    {
        public Order()
        {
            Cars = new HashSet<Car>();
        }

        public int Id { get; set; }

        public int Client_id { get; set; }

        public int? Employee_id { get; set; }

        [Required]
        [StringLength(100)]
        public string Status { get; set; }

        public virtual Client Client { get; set; }

        public virtual Employee Employee { get; set; }

        public virtual ICollection<Car> Cars { get; set; }
    }
}
