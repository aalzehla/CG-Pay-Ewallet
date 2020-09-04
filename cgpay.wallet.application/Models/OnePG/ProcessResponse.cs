using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.OnePG
{
    public class ProcessResponse
    {

        public string MerchantId { get; set; }
        public string Amount { get; set; }
        public string MerchantTxnId { get; set; }
        public string ProcessId { get; set; }
        public string GatewayUrl { get; set; }
        public string GatewayFormMethod { get; set; }
    }
}