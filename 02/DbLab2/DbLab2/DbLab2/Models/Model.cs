using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace DbLab2.Models
{
    [Table("model")]
    public partial class Model
    {
        public Model()
        {
            Cars = new HashSet<Car>();
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public string Body_type { get; set; }

        public string Engine_type { get; set; }

        public virtual ICollection<Car> Cars { get; set; }
    }
}
