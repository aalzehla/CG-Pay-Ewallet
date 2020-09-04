using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Unity.Processors;

namespace cgpay.wallet.application.Models
{
    public class BankFormModel
    {
        public string MerchantId { get; set; }
        public double Amount { get; set; }
        public string MerchantTxnId { get; set; }
        public string ProcessId { get; set; }
        public string GatewayUrl { get; set; }
        public string GatewayFormMethod { get; set; }
    }
}