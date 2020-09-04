using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.application.Models.OnePG
{
   public class CheckTransactionRequest
    {
        public string MerchantId { get; set; }
        public string MerchantName { get; set; }
        public string MerchantTxnId { get; set; }
    }
}
