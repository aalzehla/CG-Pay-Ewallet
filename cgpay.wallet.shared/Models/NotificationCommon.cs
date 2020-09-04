using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
//using CompareAttribute = System.ComponentModel.DataAnnotations.CompareAttribute;

namespace cgpay.wallet.shared.Models
{
    public class NotificationCommon : Common
    {
        public string Id { get; set; }
        public string Subject { get; set; }
        public string CreatedDate { get; set; }
        public string Notification { get; set; }
        public string ReadStatus { get; set; }
        public string Type { get; set; }

        [Display(Name = "From Date")]
        public string fromDate { get; set; }

        [Display(Name = "To Date")]
        public string toDate { get; set; }


    }
}
