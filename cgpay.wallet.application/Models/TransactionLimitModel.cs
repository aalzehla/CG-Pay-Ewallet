using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class TransactionLimitModel
    {
        [Display(Name = "Transaction Id")]
        public string transacation_id { get; set; }

        [Display(Name = "Transaction Type")]
        public string transacation_type { get; set; }

        [Display(Name = " Maximum Transaction Limit")]
        public string transaction_limit_maximum { get; set; }

        [Display(Name = "  Maximum Daily Transaction Limit")]
        public string daily_maximum_limit { get; set; }

        [Display(Name = "  Maximum Monthly Transaction Limit")]
        public string monthly_maximum_limit { get; set; }

        [Display(Name = "Kyc Status")]
        public string kyc_status { get; set; }
        
    }
}