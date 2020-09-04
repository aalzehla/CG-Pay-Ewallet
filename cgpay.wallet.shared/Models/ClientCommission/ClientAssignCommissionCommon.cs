using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.ClientCommission
{
    public class ClientAssignCommissionCommon:Common
    {
        public string CommissionCategoryId { get; set; }
        public string CommissionCategoryName { get; set; }
        public string AgentId { get; set; }
        public string AgentName { get; set; }
        public string AgentType { get; set; }
    }
}
