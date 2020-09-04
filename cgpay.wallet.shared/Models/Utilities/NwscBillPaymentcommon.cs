using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Utilities
{
    public class NwscBillInquiryCommon
    {
        public string OfficeCode { get; set; }
        public string CustomerId { get; set; }
        public string UserId { get; set; }
        public string IpAddress { get; set; }
    }
    public class NwscBillPaymentCommon
    {
        public string CustomerId { get; set; }
        public string OfficeCode { get; set; }
        public string ServiceCharge { get; set; }
        public string TotalDueAmount { get; set; }

        public string TransactionId { get; set; }

    }
}
