using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using direct.gateway.selection.domain;
using direct.gateway.selection.domain.abstracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Utilities
{
    public class NwscBillPaymentRepository:INwscBillPaymentRepository
    {
        public RepositoryDao dao;
        public NwscBillPaymentRepository()
        {
            dao = new RepositoryDao();
        }
        public CommonDbResponse GetNwscBill(NwscBillInquiryCommon billinq)
        {
            CommonDbResponse response = new CommonDbResponse();
            Dictionary<string, string> Data = new Dictionary<string, string>();
            Data.Add("CustomerId", billinq.CustomerId);
            Data.Add("OfficeCode", billinq.OfficeCode);
            Data.Add("UserId", billinq.UserId);
            Data.Add("IpAddress", billinq.IpAddress);
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");

            var fresponse = factory.GetUserDetails("34", Data);
            response.Message = fresponse.Message;
            response.GatewayName = fresponse.GatewayName;
            if(fresponse.Code=="000")
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
        public CommonDbResponse BillPayment(NwscBillPaymentCommon payment)
        {
            CommonDbResponse response = new CommonDbResponse();
            var checkvalidation = NWSCvalidation(payment);
            if (checkvalidation.Code != ResponseCode.Success)
            {
                response.Code = ResponseCode.Failed;
                response.Message = checkvalidation.Message;
                return response;
            }
            Dictionary<string, string> Data = new Dictionary<string, string>();
            Data.Add("OfficeCode", payment.OfficeCode);
            Data.Add("SCharge", payment.OfficeCode);
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            factory.TransactionId = payment.TransactionId;
            var fresponse = factory.ProcessTransactions(Data);
            if(fresponse.GatewayName.ToUpper()=="PRABHUPAY")
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
            return response;
        }

        private CommonDbResponse NWSCvalidation(NwscBillPaymentCommon payment)
        {
            CommonDbResponse response = new CommonDbResponse();
            if (!Regex.IsMatch(payment.CustomerId, @"^\d+$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid Customer Number";
                return response;
            }
            else if(payment.CustomerId.Length < 1 || payment.CustomerId.Length>7)
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid length Customer Number";
                return response;
            }
            else
            {
                response.Code = ResponseCode.Success;
                return response;
            }
        }


    }
}
