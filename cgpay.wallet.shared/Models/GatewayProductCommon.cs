using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models
{
    public class GatewayProductCommon:Common
    {
        
        public int GatewayProductId { get; set; }
        public string GatewayId { get; set; }
        public string ProductId { get; set; }
        public string ProductLabel { get; set; }

        public float CommissionValue { get; set; }
        public string CommissionType { get; set; }
        public string CommissionEarned { get; set; }
        public string IsProduct { get; set; }
    }
}
