using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Utilities
{
    public class CheckPhoneNumberCommon:CommonDbResponse
    {
        public string ServiceName { get; set; }
        public int ServiceCode { get; set; }
        public ushort CompanyCode { get; set; }
        public string PhoneNumber { get; set; }
    }
}
