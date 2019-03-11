using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DbLab2.Models
{

    [Table("history")]
    public partial class History
    {
        public int Id { get; set; }

        public int Car_id { get; set; }

        [Required]
        [StringLength(300)]
        public string Operation { get; set; }

        public DateTime CreateAt { get; set; }
    }
}
