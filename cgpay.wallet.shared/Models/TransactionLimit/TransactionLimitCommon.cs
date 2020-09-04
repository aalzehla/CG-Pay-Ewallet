using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.TransactionLimit
{
   public class TransactionLimitCommon : Common
    {      
        public string transacation_id { get; set; }     
        public string transacation_type { get; set; }     
        public string transaction_limit_maximum { get; set; }
        public string daily_maximum_limit { get; set; }    
        public string monthly_maximum_limit { get; set; }   
        public string kyc_status { get; set; }
        public string TxnLimitMax { get; set; }
        public string TxnDailyLimitMax { get; set; }
        public string TxnMonthlyLimitMax { get; set; }
        public string TxnDailyRemainingLimit { get; set; }
        public string TxnMonthlyRemainingLimit { get; set; }

    }
}
