using cgpay.wallet.api.Services;
using cgpay.wallet.api.Services.contracts.Repository;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Utilities;
using direct.gateway.selection.domain;
using direct.gateway.selection.domain.abstracts;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.LandlinePayment
{
    public class LandLinePaymentRepository:ILandLinePaymentRepository
    {
        RepositoryDao dao;
        public LandLinePaymentRepository()
        {
            dao = new RepositoryDao();
        }
        public CommonDbResponse ConsumeService(string PhoneNumber,long Amount)
        {
            CommonDbResponse response = new CommonDbResponse();
            if(!Regex.IsMatch(PhoneNumber,@"^\d+$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid Mobile Number";
                return response;
            }
            var CheckPhone = PhoneNumberValidate(PhoneNumber, Amount);
            if(CheckPhone.Code!=ResponseCode.Success)
            {
                response.Code = ResponseCode.Failed;
                response.Message = CheckPhone.Message;
                return response;
            }
            IServiceRepository factory = apiServicesAbstractFactory.Create(CheckPhone.ServiceName);
            var package = factory.PACKAGE(CheckPhone.PhoneNumber, CheckPhone.ServiceCode.ToString(), Amount.ToString());
            if (package.Result != "000")
            {
                response.Code = ResponseCode.Failed;
                response.Message = package.ResultMessage;
                return response;
            }
            var payment = factory.PAYMENT(Amount.ToString(), CheckPhone.PhoneNumber, package.BillInfo.Bill.BillNumber, package.BillInfo.Bill.RefStan, CheckPhone.ServiceCode.ToString());
            response.Code = payment.Result != "000" ? ResponseCode.Failed : ResponseCode.Success;
            response.Message = payment.ResultMessage;
            response.Extra1 = package.Result == "000" ? package.BillInfo.Bill.BillNumber : "";
            response.Extra2 = package.Result == "000" ? package.BillInfo.Bill.RefStan : "";
            response.Id = package.TransactionId;
            response.Data = payment;
            return response;

        }

        private CheckPhoneNumberCommon PhoneNumberValidate(string PhoneNumber,long Amount)
        {
            if (PhoneNumber.Length > 9 && PhoneNumber.Substring(0, 3) == "977")
            {
                PhoneNumber = "0"+PhoneNumber.Substring(3);
            }
            if (!PhoneNumberLengthValidate(PhoneNumber))
            {
                return new CheckPhoneNumberCommon { Code = ResponseCode.Failed, Message = "Please Enter Valid Phone Number with Area Code" };
            }

         
            if (PhoneNumber.Length != 9 )
            {
                return new CheckPhoneNumberCommon { Code = ResponseCode.Failed, Message = "Please Enter Valid format ({areaCode}XXXXXXX)" };
            }

            PhoneNumber = PhoneNumber.Substring(1,8);

            if (PhoneNumber.Substring(0,2)=="12" || PhoneNumber.Substring(0,3)== "512")//UTL
            {
                ushort? ServiceCode = null;
                if (Amount == 10 || Amount == 20 || Amount == 50 || Amount == 100 || Amount == 250 || Amount == 500 || Amount == 1000)
                    ServiceCode = 0;

                if (ServiceCode == null)
                {
                    return new CheckPhoneNumberCommon { Code = ResponseCode.Failed, Message = "Please Enter Valid Amount" };
                }

                return new CheckPhoneNumberCommon { Code = ResponseCode.Success, ServiceCode = 0, CompanyCode = 582, PhoneNumber =  PhoneNumber, ServiceName = "UTL" };
            }
            else//NTC
            {
                return new CheckPhoneNumberCommon { Code = ResponseCode.Success, ServiceCode = 2, CompanyCode = 585, PhoneNumber =  PhoneNumber, ServiceName = "NTC" };
            }
        }
        private bool PhoneNumberLengthValidate(string MobileNumber)
        {
            if (Regex.IsMatch(MobileNumber, @"^\d{9}$"))
            {
                return true;
            }
            return false;
        }

        public CommonDbResponse GetPackage(string PhoneNumber, long Amount, string servicecode)
        {
            CommonDbResponse response = new CommonDbResponse();
            if (!Regex.IsMatch(PhoneNumber, @"^\d+$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid Phone Number";
                return response;
            }

            var checkPhone = PhoneNumberValidate(PhoneNumber, Amount);
            if (checkPhone.Code != ResponseCode.Success)
            {
                response.Code = ResponseCode.Failed;
                response.Message = checkPhone.Message;
                return response;
            }

            IServiceRepository factory = apiServicesAbstractFactory.Create(checkPhone.ServiceName);
            var package = factory.PACKAGE(checkPhone.PhoneNumber, servicecode);
            response.Message = package.ResultMessage;
            response.Code = package.Result != "000" ? ResponseCode.Failed : ResponseCode.Success;
            response.Extra1 = package.Result == "000" ? package.BillInfo.Bill.BillNumber : "";
            response.Extra2 = package.Result == "000" ? package.BillInfo.Bill.RefStan : "";
            response.Id = package.TransactionId;
            response.Data = package;
            return response;
        }

        public CommonDbResponse Payment(string PhoneNumber, long Amount, string servicecode, string billnumber, string refstan)
        {
            CommonDbResponse response = new CommonDbResponse();
            if (!Regex.IsMatch(PhoneNumber, @"^\d+$"))
            {
                response.Code = ResponseCode.Failed;
                response.Message = "Please input valid Mobile Number";
                return response;
            }

            var checkMobile = PhoneNumberValidate(PhoneNumber, Amount);
            if (checkMobile.Code != ResponseCode.Success)
            {
                response.Code = ResponseCode.Failed;
                response.Message = checkMobile.Message;
                return response;
            }

            IServiceRepository factory = apiServicesAbstractFactory.Create(checkMobile.ServiceName);
            var payment = factory.PAYMENT(Amount.ToString(), checkMobile.PhoneNumber, billnumber, refstan, servicecode);
            response.Message = payment.ResultMessage;
            response.Code = payment.Result != "000" ? ResponseCode.Failed : ResponseCode.Success;
            response.Extra1 = payment.Result == "000" ? billnumber : "";
            response.Extra2 = payment.Result == "000" ? refstan : "";
            response.Id = payment.TransactionId;
            response.Data = payment;
            return response;
        }

        public CommonDbResponse DirectPayment(string TransactionId)
        {
            CommonDbResponse response = new CommonDbResponse();

            GatewaySwitchAbstractService factory = GatewaySwitchAbstractFactory.Create("cgpay");
            factory.TransactionId = TransactionId;
            var fresponse = factory.ProcessTransactions();

            response.Message = fresponse.Message;
            response.Data = fresponse.Data;
            response.GatewayName = fresponse.GatewayName;

            if (fresponse.Code == "000")
            {
                response.Code = ResponseCode.Success;


            }
            else if (fresponse.Code == "777")
            {
                response.Code = ResponseCode.Exception;


            }
            else
            {
                response.Code = ResponseCode.Failed;
            }

            //if (fresponse.GatewayName.ToUpper() == "PRABHUPAY")
            //{
            //    response.Message = fresponse.Message;


            //    if (fresponse.Code == "000")
            //    {
            //        response.Code = ResponseCode.Success;
            //        response.Data = fresponse.Data;

            //    }
            //    else if (fresponse.Code == "777")
            //    {
            //        response.Code = ResponseCode.Exception;
            //        response.Data = fresponse.Data;

            //    }
            //    else
            //    {
            //        response.Code = ResponseCode.Failed;
            //    }
            //}


            //}
            //if(fresponse.GatewayName.ToUpper() == "PAYPOINT")
            //{

            //    response.Message = fresponse.Message;
            //    if (fresponse.Code == "000")
            //    {
            //        response.Code = ResponseCode.Success;
            //        response.Data = fresponse.Data;

            //    }
            //    else if (fresponse.Code == "777")
            //    {
            //        response.Code = ResponseCode.Exception;
            //    }
            //    else
            //    {
            //        response.Code = ResponseCode.Failed;
            //    }
            //}



            //if (payment.GatewayName == "PAYPOINT")
            //{
            //    if (payment.Code == shared.Models.ResponseCode.Success)
            //    {
            //        var billNo = payment.Extra1;
            //        var refStan = payment.Extra2;
            //        var ppresponse = (PPResponse)payment.Data;
            //        var data = new MobileTopUpPaymentUpdateRequest();
            //        data.action_user = Session["UserName"].ToString();
            //        data.transaction_id = response.Extra1;
            //        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
            //        data.amount = clientModel.Amount;
            //        data.bill_number = billNo;
            //        data.refstan = refStan;
            //        data.status_code = ppresponse.Result;
            //        data.remarks = ppresponse.ResultMessage;
            //        data.ip_address = ApplicationUtilities.GetIP();
            //        data.product_id = clientModel.ProductId;
            //        data.partner_txn_id = ppresponse.TransactionId;
            //        response = _mtp.MobileTopUpPaymentResponse(data);
            //        failed = false;

            //    }
            //    else
            //    {
            //        var ppresponse = (PPResponse)payment.Data;
            //        var data = new MobileTopUpPaymentUpdateRequest();
            //        data.action_user = Session["UserName"].ToString();
            //        data.transaction_id = response.Extra1;
            //        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
            //        data.amount = clientModel.Amount;
            //        data.status_code = ((int)payment.Code).ToString();
            //        data.remarks = payment.Message;
            //        data.ip_address = ApplicationUtilities.GetIP();
            //        data.product_id = clientModel.ProductId;
            //        response = _mtp.MobileTopUpPaymentResponse(data);

            //    }
            //}
            //if (payment.GatewayName == "PRABHUPAY")
            //{
            //    if (payment.Code == ResponseCode.Success)
            //    {
            //        var billNo = payment.Extra1;
            //        var refStan = payment.Extra2;
            //        var ppresponse = (PPResponse)payment.Data;
            //        var data = new MobileTopUpPaymentUpdateRequest();
            //        data.action_user = Session["UserName"].ToString();
            //        data.transaction_id = response.Extra1;
            //        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
            //        data.amount = clientModel.Amount;
            //        data.bill_number = billNo;
            //        data.refstan = refStan;
            //        data.status_code = ppresponse.Result;
            //        data.remarks = ppresponse.ResultMessage;
            //        data.ip_address = ApplicationUtilities.GetIP();
            //        data.product_id = clientModel.ProductId;
            //        data.partner_txn_id = ppresponse.TransactionId;
            //        response = _mtp.MobileTopUpPaymentResponse(data);
            //        failed = false;

            //    }
            //    else if (payment.Code == ResponseCode.Exception)
            //    {

            //        var billNo = payment.Extra1;
            //        var refStan = payment.Extra2;
            //        var ppresponse = (PPResponse)payment.Data;
            //        var data = new MobileTopUpPaymentUpdateRequest();
            //        data.action_user = Session["UserName"].ToString();
            //        data.transaction_id = response.Extra1;
            //        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
            //        data.amount = clientModel.Amount;
            //        data.bill_number = billNo;
            //        data.refstan = refStan;
            //        data.status_code = ppresponse.Result;
            //        data.remarks = ppresponse.ResultMessage;
            //        data.ip_address = ApplicationUtilities.GetIP();
            //        data.product_id = clientModel.ProductId;
            //        data.partner_txn_id = ppresponse.TransactionId;
            //        response = _mtp.MobileTopUpPaymentResponse(data);
            //        failed = false;
            //    }
            //    else
            //    {
            //        var ppresponse = (PPResponse)payment.Data;
            //        var data = new MobileTopUpPaymentUpdateRequest();
            //        data.action_user = Session["UserName"].ToString();
            //        data.transaction_id = response.Extra1;
            //        data.additonal_data = Newtonsoft.Json.JsonConvert.SerializeObject(ppresponse);
            //        data.amount = clientModel.Amount;
            //        data.status_code = ((int)payment.Code).ToString();
            //        data.remarks = payment.Message;
            //        data.ip_address = ApplicationUtilities.GetIP();
            //        data.product_id = clientModel.ProductId;
            //        response = _mtp.MobileTopUpPaymentResponse(data);
            //    }
            //}



            return response;

        }

       
    }
}
