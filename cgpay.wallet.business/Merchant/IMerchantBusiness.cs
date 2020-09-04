using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Merchant;

namespace cgpay.wallet.business.Merchant
{
    public interface IMerchantBusiness
    {
        List<MerchantCommon> GetMerchantList(string MerchantId = "", string parentid = "");
        CommonDbResponse ManageMerchant(MerchantCommon merchantCommon);
        MerchantCommon GetMerchantById(string MerchantId);
        CommonDbResponse Disable_EnableMerchant(MerchantCommon merchantCommon);

        CommonDbResponse AddCardQr(string userId, string agentId, string MerchantQr, string qrImagePath);

        List<MerchantUserCommon> GetUserList(string merchantid, string username, string UserId = "");
        MerchantUserCommon GetUserById(string merchantid, string UserId, string username);
        CommonDbResponse ManageUser(MerchantUserCommon discomm);
        CommonDbResponse Disable_EnableMerchantUser(MerchantUserCommon DMC);
        List<MerchantTransactionReportCommon> GetTransactionReport(string merchantid);

        List<MerchantChartCommon> GetDailyTransactionChart(string UserId);
        CommonDbResponse ResetPassword(MerchantCommon mCommon);
    }
}
