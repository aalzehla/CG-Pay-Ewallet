using cgpay.wallet.api.Services;
using cgpay.wallet.api.Services.contracts.Repository;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using direct.gateway.selection.domain;
using direct.gateway.selection.domain.abstracts;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Utilities
{
    
    public class NeaBillPaymentRepository:INeaBillPaymentRepository
    {
        public RepositoryDao dao;
        public NeaBillPaymentRepository()
        {
            dao = new RepositoryDao();
        }
        public Dictionary<string,string> GetNeaOfficeList()
        {
            string sql = "sproc_get_dropdown_list @flag='019'";
            var dt = dao.ExecuteDataTable(sql);
            var dictionary = new System.Collections.Generic.Dictionary<string, string>();

            if (null == dt || dt.Rows.Count == 0)
            {
                return dictionary;
            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                
                dictionary.Add(dt.Rows[i][0].ToString(), dt.Rows[i][1].ToString());
                
            }
            return dictionary;

        }

        public CommonDbResponse GetPackage(NeaBillInquiryCommon NBI)
        {
            CommonDbResponse response = new CommonDbResponse();
           
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            Dictionary<string, string> Data = new Dictionary<string, string>();
            Data.Add("CustomerId", NBI.ConsumerId);
            Data.Add("ScNo", NBI.ScNo);
            Data.Add("OfficeCode", NBI.OfficeCode);
            Data.Add("IpAddress", NBI.IpAddress);
            Data.Add("UserId", NBI.ActionUser);
            var fresponse = factory.GetUserDetails("26",Data);

            response.Message = fresponse.Message;
            response.GatewayName = fresponse.GatewayName;
            
            if (fresponse.Code == "000")
            {
                string sql = "[sproc_parse_nea_detail] @additional_value=" + fresponse.Data;
                var dt = dao.ExecuteDataRow(sql);

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

            
            return response;
        }

        public CommonDbResponse neabillCharges(NeaBillChargeCommon NBIR)
        {
            CommonDbResponse response = new CommonDbResponse();
           
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            Dictionary<string, string> Data = new Dictionary<string, string>();
            Data.Add("CustomerId", NBIR.ConsumerId);
            Data.Add("ScNo", NBIR.ScNo);
            Data.Add("OfficeCode", NBIR.OfficeCode);
            Data.Add("PayableAmount", NBIR.PayableAmount);
            Data.Add("IpAddress", NBIR.IpAddress);
            Data.Add("UserId", NBIR.ActionUser);
            var fresponse = factory.GetUserDetails("26",Data);

            response.Message = fresponse.Message;
            response.GatewayName = fresponse.GatewayName;

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
            return response;
        }

        public CommonDbResponse payment(NeaBillPaymentCommon BP)
        {
            CommonDbResponse response = new CommonDbResponse();
            var checkvalidation = NeaValidation(BP);
            if (checkvalidation.Code != ResponseCode.Success)
            {
                response.Code = ResponseCode.Failed;
                response.Message = checkvalidation.Message;
                return response;
            }
            //var ServiceName = "NEA";
            //var ServiceCode = "1";
            Dictionary<string, string> Dict = new Dictionary<string, string>();
            Dict.Add("OfficeCode",BP.OfficeCode);
            Dict.Add("ConsumerId",BP.ConsumerId);
            Dict.Add("SCharge",BP.Charges);          
            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            factory.TransactionId = BP.TransactionId;
            var payment = factory.ProcessTransactions(Dict);  
            
            if(payment.GatewayName.ToUpper()=="PRABHUPAY")
            {
                if(payment.Code=="000")
                {
                    response.Code = ResponseCode.Success;
                    response.Data = payment.Data;
                }
                else if(payment.Code=="777")
                {
                    response.Code = ResponseCode.Exception;
                    response.Data = payment.Data;
                }
                else
                {
                    response.Code = ResponseCode.Failed;
                }
            }
            //response.Id = payment.TransactionId;
            //response.Data = payment;
            return response;
        }
        private CommonDbResponse NeaValidation(NeaBillPaymentCommon PC)
        {
            CommonDbResponse response = new CommonDbResponse();
           if(Convert.ToDouble(PC.PayableAmount)< Convert.ToDouble(PC.MinAmount)|| Convert.ToDouble(PC.PayableAmount) > Convert.ToDouble(PC.MaxAmount))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Invalid Amount";
                return response;
            }
           if(!Regex.IsMatch(PC.ScNo, @"^[0 - 9][0 - 9.] *[A - za - z0-9] *$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid SC.No";
                return response;
            }
            if (!Regex.IsMatch(PC.ConsumerId, @"^\d+$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid Consumer Number";
                return response;
            }else if (!Regex.IsMatch(PC.OfficeCode, @"^\d+$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please Select valid Branch";
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
