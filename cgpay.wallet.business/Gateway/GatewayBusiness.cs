using cgpay.wallet.repository.Gateway;
using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.Gateway
{
    public class GatewayBusiness : IGatewayBusiness
    {
        IGatewayRepository repo;

        public GatewayBusiness(GatewayRepository _repo)
        {
            repo = _repo;
        }

        public List<GatewayCommon> GetGatewayList()
        {
            return repo.GetGatewayList();
        }

        public CommonDbResponse ManageGateway(GatewayCommon gatewaysetup)
        {
            return repo.ManageGateway( gatewaysetup);
        }

        public GatewayCommon GetGatewayById(string UserId)
        {
            return repo.GetGatewayById(UserId);
        }
        public CommonDbResponse updatebalance(GatewayBalanceCommon bc)
        {
            return repo.updatebalance(bc);
        }
        public List<GatewayProductCommon> GetGatewayProductList(string GatewayId, string ProductId)
        {
            return repo.GetGatewayProductList( GatewayId,  ProductId);
        }
        public CommonDbResponse ManageGatewayProductCommission(GatewayProductCommon GWPC)
        {
            return repo.ManageGatewayProductCommission(GWPC);
        }

        public List<GatewayBalanceCommon> GetGatewayReportList()
        {
            return repo.GetGatewayReportList();
        }
    }
}
