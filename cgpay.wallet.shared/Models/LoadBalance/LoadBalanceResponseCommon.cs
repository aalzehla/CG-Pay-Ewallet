using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.LoadBalance
{
    public class LoadBalanceResponseCommon
    {
        
        public string pmt_gateway_txn_id { get; set; }
        public string pmt_txn_id { get; set; }
        public string amount { get; set; }
        public string gateway_status { get; set; }
        public string agent_id { get; set; }
        public string user_name { get; set; }

        public string BankName { get; set; }
        public string Type { get; set; }

    }
}
