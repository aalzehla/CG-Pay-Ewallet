using admin.onepg.api.Models;
using cgpay.wallet.application.Library;
using cgpay.wallet.application.Models.OnePG;
using cgpay.wallet.business.Log;
using cgpay.wallet.shared.Models.Log;
using middleware.onepg.data;
using middleware.onepg.data.Models;
using middleware.onepg.domain;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.EnterpriseServices.Internal;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using CheckTransactionRequest = middleware.onepg.data.CheckTransactionRequest;
using Errors = middleware.onepg.data.Models.Errors;

namespace cgpay.wallet.application.Library
{
    public class MiddleServiceRequest
    {
        private string AppName;
        private string ApiUsername;
        private string ApiPassword;
        private string SecretKey; 
        private string UserId;
        IApiLogBusiness _log;

        public MiddleServiceRequest(string AppName, string ApiUsername, string ApiPassword, string SecretKey, string UserId = "")
        {
            this.AppName = AppName;
            this.ApiUsername = ApiUsername;
            this.ApiPassword = ApiPassword;
            this.SecretKey = SecretKey;
            this.UserId = UserId;
            _log = new ApiLogBusiness();

        }


        public TransactionStatus GetTransactionDetail(string MerchantId, string MerchantName,
            string MerchantTxnId)
        {
            var service = ServiceFactory.Create(appName: AppName);
            if (service == null)
            {
                return new TransactionStatus() { code = "1", message = "Error", errors = new List<Errors>() { new Errors() { error_code = "1", error_message = "Service Initialization Failed" } } };
            }
            //add api parameters here
            CheckTransactionRequest request = new CheckTransactionRequest()
            {
                MerchantId = MerchantId,
                MerchantTxnId = MerchantTxnId,
                MerchantName = MerchantName
            };
            var logRes = _log.InsertApiLog(new shared.Models.Log.ApiLogCommon()
            {
                transacionId = request.MerchantTxnId,
                partner_tran_id = "",
                apiRequest = request.SerializeObjectToJSON(),
                apiResponse = "",
                userId = UserId,
                IpAddress = "::1",
                functionName = "CheckTransactionStatus"
            });

            service.SecretKey = SecretKey;
            service.ApiUsername = ApiUsername;
            service.ApiPassword = ApiPassword;
            service.AppName = AppName;
            service.UserId = UserId;
            service.TransactionRequestData = request;
            var response = service.GetTransactionStatus();
            var res = ApplicationUtilities.MapObject<TransactionStatus>(response);
            if (res.code == "0")
            {
                //log
                if (logRes.Id != null)
                {
                    _log.UpdateApiLog(new shared.Models.Log.ApiLogCommon()
                    {
                        transacionId = request.MerchantTxnId,
                        partner_tran_id = res.data.GatewayReferenceNo,
                        apiResponse = res.SerializeObjectToJSON(),
                        IpAddress = "::1",
                        userId = UserId,
                        apiLogId = logRes.Id
                    });
                }
                //end
            }
            else
            {
                //log
                if (logRes.Id != null)
                {
                    _log.UpdateApiLog(new shared.Models.Log.ApiLogCommon()
                    {
                        transacionId = request.MerchantTxnId,
                        partner_tran_id = string.Empty,
                        apiResponse = res.SerializeObjectToJSON(),
                        IpAddress = "::1",
                        userId = UserId,
                        apiLogId = logRes.Id
                    });
                }
                //end
            }

            //end log

            return res;
        }


        public BankResponse GetPaymentInstrumentDetail(string MerchantId, string MerchantName
               )
        {
            var service = ServiceFactory.Create(appName: AppName);
            if (service == null)
            {
                return new BankResponse() { code = "1", message = "Error", errors = new List<Errors>() { new Errors() { error_code = "1", error_message = "Service Initialization Failed" } } };
            }
            //add api parameters here
            PaymentInstrument.Request request = new PaymentInstrument.Request()
            {
                MerchantId = MerchantId,
                MerchantName = MerchantName
            };
            //log
            var logRes = _log.InsertApiLog(new shared.Models.Log.ApiLogCommon()
            {
                transacionId = string.Empty,
                partner_tran_id = string.Empty,
                apiRequest = request.SerializeObjectToJSON(),
                apiResponse = string.Empty,
                userId = UserId,
                IpAddress = "::1",
                functionName = "GetPaymentInstrumentDetails"
            });

            //end log
            service.SecretKey = SecretKey;
            service.ApiUsername = ApiUsername;
            service.ApiPassword = ApiPassword;
            service.PaymentInstrumentData = request;
            service.AppName = AppName;
            service.UserId = UserId;
            var response = service.GetPaymentInstrument();
            var res = ApplicationUtilities.MapObject<BankResponse>(response);
            if (res.code == "0")
            {
                //log
                if (logRes.Id != null)
                {
                    _log.UpdateApiLog(new shared.Models.Log.ApiLogCommon()
                    {
                        transacionId = string.Empty,
                        partner_tran_id = string.Empty,
                        apiResponse = res.SerializeObjectToJSON(),
                        IpAddress = "::1",
                        userId = UserId,
                        apiLogId = logRes.Id
                    });
                }
               //end log
            }
            else
            {
                //log
                if (logRes.Id != null)
                {
                    _log.UpdateApiLog(new shared.Models.Log.ApiLogCommon()
                    {
                        transacionId = string.Empty,
                        partner_tran_id = string.Empty,
                        apiResponse = res.SerializeObjectToJSON(),
                        IpAddress = "::1",
                        userId = UserId,
                        apiLogId = logRes.Id
                    });
                }
                //end
            }

            return res;

        }


        public RedirectionFormData GetFormObject(string MerchantId, string MerchantName, string MerchantTxnId, string Amount, string TransactionRemarks,  string InstrumentCode = "")
        {
            var service = ServiceFactory.Create(appName: AppName);
            if (service == null)
            {
                return new RedirectionFormData() { code = "1", message = "Error", errors = new List<Errors>() { new Errors() { error_code = "1", error_message = "Service Initialization Failed" } } };

            }
            //add api parameters here
            ProcessIdRequest request = new ProcessIdRequest()
            {
                MerchantId = MerchantId,
                MerchantName = MerchantName,
                Amount = Amount,
                MerchantTxnId = MerchantTxnId,
                TransactionRemarks = TransactionRemarks
            };
            //insert log
            var logRes = _log.InsertApiLog(new shared.Models.Log.ApiLogCommon()
            {
                transacionId = string.Empty,
                partner_tran_id = string.Empty,
                apiRequest = request.SerializeObjectToJSON(),
                apiResponse = string.Empty,
                userId = UserId,
                IpAddress = "::1",
                functionName = "GetProcessId"
            });

            //end log
            service.SecretKey = SecretKey;
            service.ApiUsername = ApiUsername;
            service.ApiPassword = ApiPassword;
            service.ProcessRequestData = request;
            service.AppName = AppName;
            service.UserId = UserId;
            var response = service.GetRedirectionFormObject(InstrumentCode);
            var res = ApplicationUtilities.MapObject<RedirectionFormData>(response);
            if (res.code == "0")
            {
                //log
                if (logRes.Id != null)
                {
                    _log.UpdateApiLog(new shared.Models.Log.ApiLogCommon()
                    {
                        transacionId = string.Empty,
                        partner_tran_id = string.Empty,
                        apiResponse = res.SerializeObjectToJSON(),
                        IpAddress = "::1",
                        userId = UserId,
                        apiLogId = logRes.Id
                    });
                }
                //end log
            }
            else
            {
                //log
                if (logRes.Id != null)
                {
                    _log.UpdateApiLog(new shared.Models.Log.ApiLogCommon()
                    {
                        transacionId = string.Empty,
                        partner_tran_id = string.Empty,
                        apiResponse = res.SerializeObjectToJSON(),
                        IpAddress = "::1",
                        userId = UserId,
                        apiLogId = logRes.Id
                    });
                }
                //end
            }
            return res;
        }
    }
}