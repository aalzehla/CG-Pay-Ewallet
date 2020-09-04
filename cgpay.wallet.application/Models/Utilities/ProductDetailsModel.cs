using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.Utilities
{
    public class ProductDetailsModel
    {
        public string Code { get; set; }
        public string Message { get; set; }
        public string ProductLogo { get; set; }
        public string MinAmount { get; set; }
        public string MaxAmount { get; set; }
        public string ProductId { get; set; }
        public string CommissionValue { get; set; }
        public string CommissionType { get; set; }
        public string ServiceCode { get; set; }
        public string CompanyCode { get; set; }
    }
}