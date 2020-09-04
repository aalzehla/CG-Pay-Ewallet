using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.LoadBalance
{
    public class ViewTransactionReponseModel
    {
        public int code { get; set; }
        [Display(Name = "Message")]
        public string Message { get; set; }
        [Display(Name = "Gateway Transaction Id")]
        public string pmt_gateway_txn_id { get; set; }

        [Display(Name = "Transaction Id")]
        public string pmt_txn_id { get; set; }
        [Display(Name = "Amount")]
        public string amount { get; set; }
        [Display(Name = "Transaction Status")]
        public string gateway_status { get; set; }

        [Display(Name = "Agent Id")]
        public string agent_id { get; set; }

        [Display(Name = "User Name")]
        public string user_name { get; set; }

        [Display(Name = "Bank Name")]
        public string BankName { get; set; }



        [Display(Name = "Payment Type")]
        public string Type { get; set; }
    }
}
