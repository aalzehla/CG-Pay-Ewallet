using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Log
{
   public class ApiLogCommon
    {
        [Display(Name = "Transaction Id")]
        public string transacionId { get; set; }

        public string userId { get; set; }
        [Display(Name = "User Name")]
        public string UserName { get; set; }

        public string functionName { get; set; }

        [Display(Name = "API Request")]
        public string apiRequest { get; set; }
        public string apiResponse { get; set; }

        public string createdNepaliDate { get; set; }

        public string createdLocalDate { get; set; }


        public string Action { get; set; }

        public string apiLogId { get; set; }

        public string createdUtcDate { get; set; }

        [Display(Name = "From Date")]
        public string fromDate { get; set; }

        [Display(Name = "To Date")]
        public string toDate { get; set; }

        public string partner_Id { get; set; }

        public string partner_tran_id { get; set; }

        public string IpAddress { get; set; }






    }
}
