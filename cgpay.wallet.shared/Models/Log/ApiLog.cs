using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Log
{
   public class ApiLog
    {
        public string transacion_Id { get; set; }

        public string user_Id { get; set; }

        public string function_Name { get; set; }

        [Display(Name = "API Request")]
        public string api_Request { get; set; }
        public string api_Response { get; set; }

        public string created_nepali_Date { get; set; }

        public string created_local_Date { get; set; }


        public string Action { get; set; }

        public string api_log_id { get; set; }

       





    }
}
