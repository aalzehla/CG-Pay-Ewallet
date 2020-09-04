using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models
{
    public class GatewayConfigModel
    {
        public string ApiUsername { get; set; }
        public string ApiPassword { get; set; }
        public string SecretKey { get; set; }
    }
}