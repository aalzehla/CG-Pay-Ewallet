using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.OnePG
{
    public class AuthenticationLogRequest
    {

        public string MerchantId { get; set; }
        public string MerchantName { get; set; }
        public string Amount { get; set; }
        public string MerchantTxnId { get; set; }
       // public string TransactionRemarks { get; set; }
    }
    public class CheckTransactionStatus
    {

        public string MerchantId { get; set; }
        public string MerchantName { get; set; }
        public string MerchantTxnId { get; set; }
    }
}