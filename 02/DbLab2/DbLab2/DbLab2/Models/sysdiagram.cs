using System.ComponentModel.DataAnnotations;
namespace DbLab2.Models

{
    public partial class Sysdiagram
    {
        [Required]
        [StringLength(128)]
        public string Name { get; set; }

        public int Principal_id { get; set; }

        [Key]
        public int diagram_id { get; set; }

        public int? version { get; set; }

        public byte[] definition { get; set; }
    }
}
