using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Utilities
{
    public class WorldLinkBillInquiryCommon
    {
        public string WlinkUserName { get; set; }
        public string IpAddress { get; set; }
        public string UserId { get; set; }
    }
    public class WorldLinkBillPaymentCommon
    {
        public string WlinkUserName { get; set; }
        public string PlanId { get; set; }
        public string Amount { get; set; }
        public string TransactionId { get; set; }
    }
}
