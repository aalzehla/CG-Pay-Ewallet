using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.MobileTopup
{
    public class CheckMobileNumber : CommonDbResponse
    {
        public string ServiceName { get; set; }
        public int ServiceCode { get; set; }
        public ushort CompanyCode { get; set; }
        public string MobileNumber { get; set; }
    }
}
