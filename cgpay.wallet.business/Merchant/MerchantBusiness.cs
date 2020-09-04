using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.repository.Merchant;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Merchant;

namespace cgpay.wallet.business.Merchant
{
    public class MerchantBusiness : IMerchantBusiness
    {
        IMerchantManagementRepository _repo;
        public MerchantBusiness(MerchantManagementRepository repo)
        {
            _repo = repo;
        }
        public List<MerchantCommon> GetMerchantList(string MerchantId = "", string parentid = "")
        {
            return _repo.GetMerchantList(MerchantId, parentid);
        }

        public CommonDbResponse ManageMerchant(MerchantCommon merchantCommon)
        {
            return _repo.ManageMerchant(merchantCommon);
        }

        public MerchantCommon GetMerchantById(string MerchantId)
        {
            return _repo.GetMerchantById(MerchantId);
        }

        public CommonDbResponse Disable_EnableMerchant(MerchantCommon merchantCommon)
        {
            return _repo.Disable_EnableMerchant(merchantCommon);
        }

        public CommonDbResponse AddCardQr(string userId, string agentId, string MerchantQr, string qrImagePath)
        {
            return _repo.AddCardQr(userId, agentId, MerchantQr, qrImagePath);
        }

        public List<MerchantUserCommon> GetUserList(string merchantid, string username, string UserId = "")
        {
            return _repo.GetUserList(merchantid, username, UserId);
        }

        public MerchantUserCommon GetUserById(string merchantid, string UserId, string username)
        {
            return _repo.GetUserById(merchantid, UserId, username);
        }
        public CommonDbResponse ManageUser(MerchantUserCommon discomm)
        {
            return _repo.ManageUser( discomm);
        }
        public CommonDbResponse Disable_EnableMerchantUser(MerchantUserCommon DMC)
        {
            return _repo.Disable_EnableMerchantUser(DMC);
        }

        public List<MerchantTransactionReportCommon> GetTransactionReport(string merchantid)
        {
            return _repo.GetTransactionReport(merchantid);
        }

        public List<MerchantChartCommon> GetDailyTransactionChart(string UserId)
        {
            return _repo.GetDailyTransactionChart(UserId);
        }

        public CommonDbResponse ResetPassword(MerchantCommon mCommon)
        {
            return _repo.ResetPassword(mCommon);
        }
    }
}
