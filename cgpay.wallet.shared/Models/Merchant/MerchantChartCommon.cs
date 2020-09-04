using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Merchant
{
    public class MerchantChartCommon
    {
        public string TransactionYear { get; set; }
        public string TransactionMonth { get; set; }
        public string TransactionDay { get; set; }
        public string TotalAmount { get; set; }
        public string TotalTransaction { get; set; }
        
    }
}
