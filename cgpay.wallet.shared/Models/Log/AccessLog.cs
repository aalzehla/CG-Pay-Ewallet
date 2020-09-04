using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Log
{
    public class AccessLog : Common
    {
        public string page_name { get; set; }
        public string log_type { get; set; }

        public string action_ip_address { get; set; }

        public string browser { get; set; }

        public string msg { get; set; }

        public string created_by { get; set; }



    }
}
