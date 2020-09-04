using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Log
{
    public class AccessLogCommon : Common
    {
        public string pageName { get; set; }
        public string logType { get; set; }

        public string actionIpAddress { get; set; }

        public string browser { get; set; }

        //public string msg { get; set; }

        //public string createdBy { get; set; }

        public string createdUtcDate { get; set; }

        public string createdLocalDate { get; set; }

        [Display(Name = "From Date")]
        public string fromDate { get; set; }

        [Display(Name = "To Date")]

        public string toDate { get; set; }




    }
}
