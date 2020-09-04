using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Errors
{
    public class ErrorsLog
    {
        //@error_Page,@error_Msg,@error_Detail,@USER   
        public string error_page { get; set; }
        public string error_msg { get; set; }
        public string error_detail { get; set; }
        public string user { get; set; }
        public string IpAddress { get; set; }
    }
}
