using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using direct.gateway.selection.domain;
using direct.gateway.selection.domain.abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Utilities
{
    public class WorldLinkBillPaymentRepository:IWorldLinkBillPaymentRepository
    {
        public RepositoryDao dao;
        public WorldLinkBillPaymentRepository()
        {
            dao = new RepositoryDao();
        }
        public CommonDbResponse CheckWlinkAccount(WorldLinkBillInquiryCommon Common )
        {
            CommonDbResponse response = new CommonDbResponse();
            Dictionary<string, string> Data = new Dictionary<string, string>();
            Data.Add("WlinkUserName", Common.WlinkUserName);
            Data.Add("IpAddress", Common.IpAddress);
            Data.Add("UserId", Common.UserId);
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            var fresponse = factory.GetUserDetails("29", Data);
            response.Message = fresponse.Message;
            response.GatewayName = fresponse.GatewayName;
            if (fresponse.Code == "000")
            {
                response.Code = ResponseCode.Success;
                response.Data = fresponse.Data;

            }
            else
            {
                response.Code = ResponseCode.Failed;

            }
            return response;
        }
        public CommonDbResponse BillPayment(WorldLinkBillPaymentCommon payment)
        {
            CommonDbResponse response = new CommonDbResponse();
            Dictionary<string, string> Data = new Dictionary<string, string>();
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            factory.TransactionId = payment.TransactionId;
            Data.Add("PlanId", payment.PlanId);
            var fresponse = factory.ProcessTransactions(Data);
            if (!string.IsNullOrEmpty(fresponse.GatewayName))
            {
                response.GatewayName = fresponse.GatewayName;
                response.Message = fresponse.Message;
                if (fresponse.GatewayName.ToUpper() == "PRABHUPAY")
                {
                    if (fresponse.Code == "000")
                    {
                        response.Code = ResponseCode.Success;
                        response.Data = fresponse.Data;
                    }
                    else if (fresponse.Code == "777")
                    {
                        response.Code = ResponseCode.Exception;
                        response.Data = fresponse.Data;
                    }
                    else
                    {
                        response.Code = ResponseCode.Failed;
                    }
                }
            }
            return response;
        }
    }
}
