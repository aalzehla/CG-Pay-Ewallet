using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.LoadBalance
{
    public class FundLoadTransactionLimitCommon
    {

        public string transaction_limit_max { get; set; }
        public string transaction_daily_limit_max { get; set; }
        public string daily_remaining_limit { get; set; }
        public string transaction_monthly_limit_max { get; set; }
        public string monthly_remaining_limit { get; set; }
    }
}
