using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DbLab2.ViewModels
{
    public class ViewModelCarAdd
    {
        public string Transmission { get; set; }

        public int Price { get; set; }

        public string Name { get; set; }

        public string Color { get; set; }

        public string Engine_type { get; set; }
        
        public string Body_type{ get; set; }
    }
}