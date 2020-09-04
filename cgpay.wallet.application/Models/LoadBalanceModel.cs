using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class LoadBalanceModel
    {
        public string pmt_txn_id { get; set; }
        public string service_charge { get; set; }
        [Required(AllowEmptyStrings =false, ErrorMessage ="Amount is Required")]
        [Display(Name ="Amount")]
        public string amount { get; set; }
        public string card_no { get; set; }
        public string remarks { get; set; }
        public string user_id { get; set; }
        public string gateway_status { get; set; }
        public string pmt_gateway_id { get; set; }
        public string action_user { get; set; }
        public string error_code { get; set; }
        public string action_ip { get; set; }
        public string action_browser { get; set; }
        public string pmt_gateway_txn_id { get; set; }
        public string instrument_code { get; set; }

        //for transaction limit
        public int transactionlimitmax //only for value conversion
        {
            get
            {
                if (transaction_limit_max != null)
                {
                    float i = 0;
                    if (float.TryParse(transaction_limit_max,out i))
                    {
                        return Convert.ToInt32(i);
                    }
                    

                }
                return 0;

            }
           
        }

        public int transactiondailylimitmax //only for value conversion
        {
            get
            {
                if (transaction_daily_limit_max != null)
                {
                    float i = 0;
                    if (float.TryParse(transaction_daily_limit_max, out i))
                    {
                        return Convert.ToInt32(i);
                    }


                }
                return 0;

            }

        }
        public int transactionmonthlylimitmax //only for value conversion
        {
            get
            {
                if (transaction_monthly_limit_max != null)
                {
                    float i = 0;
                    if (float.TryParse(transaction_monthly_limit_max, out i))
                    {
                        return Convert.ToInt32(i);
                    }


                }
                return 0;

            }

        }

        public string transaction_limit_max { get; set; }
        public string transaction_daily_limit_max { get; set; }
        public string daily_remaining_limit { get; set; }
        public string transaction_monthly_limit_max { get; set; }
        public string monthly_remaining_limit { get; set; }
    }
}