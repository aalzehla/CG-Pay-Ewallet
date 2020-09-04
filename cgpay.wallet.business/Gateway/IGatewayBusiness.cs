using cgpay.wallet.shared.Models;
using System.Collections.Generic;

namespace cgpay.wallet.business.Gateway
{
    public interface IGatewayBusiness
    {
        List<GatewayCommon> GetGatewayList();
        GatewayCommon GetGatewayById(string Gateway_Id);

        CommonDbResponse ManageGateway(GatewayCommon gatewaysetup);
        CommonDbResponse updatebalance(GatewayBalanceCommon bc);
        List<GatewayProductCommon> GetGatewayProductList(string GatewayId,string ProductId);
        CommonDbResponse ManageGatewayProductCommission(GatewayProductCommon GWPC);
        List<GatewayBalanceCommon> GetGatewayReportList();
    }
}