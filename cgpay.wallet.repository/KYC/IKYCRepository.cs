using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using cgpay.wallet.shared.Models.KYC;

namespace cgpay.wallet.repository.KYC
{
    public interface IKYCRepository
    {
        List<KYCCommon> GetAgentList(KycFilterCommon model);
        KYCCommon AgentKycInfo(string AgentId);
        Dictionary<string, string> Dropdown(string flag, string search1 = "");
        shared.Models.CommonDbResponse UpadateKycDetails(KYCCommon kycCommon, string status);
    }
}
