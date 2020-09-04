using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Log
{
   public class ActivityLog
    {
        //@page_url,@page_name, @log_type, @action_ip_address, @action_browser, @action_user
        public string page_url { get; set; }
        public string page_name { get; set; }
        public string log_type { get; set; }
        public string ipaddress { get; set; }
        public string browser_detail { get; set; }
        public string user_name { get; set; }
        public string CreatedLocalDate { get; set; }
        public string Email { get; set; }
        public string MobileNumber { get; set; }
        public string CreatedBy { get; set; }
        public string ActionUser { get; set; }
    }
}
