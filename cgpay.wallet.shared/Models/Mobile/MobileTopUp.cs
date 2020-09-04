using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Mobile
{
    public class MobileTopUp
    {
        public string action_user { get; set; }
        public string subscriber_no { get; set; }
    }

    public class MobileTopUpPaymentRequest : MobileTopUp
    {
        public string amount { get; set; }
        public string product_id { get; set; }
        public string quantity { get; set; }
        public string additonal_data { get; set; }
        public string CardNo { get; set; }
        public string CardAmount { get; set; }
        public string CreatedIp { get; set; }

    }
    public class MobileTopUpPaymentUpdateRequest : MobileTopUp
    {
        public string amount { get; set; }
        public string product_id { get; set; }
        public string quantity { get; set; }
        public string additonal_data { get; set; }
        public string bill_number { get; set; }
        public string refstan { get; set; }
        public string transaction_id { get; set; }
        public string remarks { get; set; }
        public string status_code { get; set; }
        public string ip_address { get; set; }
        public string service_charge { get; set; }
        public string partner_txn_id { get; set; }
    }

    public class MobileTopUpPaymentResponse
    {
        public string code { get; set; }
        public string message { get; set; }
    }
}
