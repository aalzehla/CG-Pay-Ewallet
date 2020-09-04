using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace cgpay.wallet.application.Models.OnePG
{
    public class BankList
    {
        public string InstitutionName { get; set; }
        public string InstrumentName { get; set; }
        public string InstrumentCode { get; set; }
        public string InstrumentValue { get; set; }
        public string LogoUrl { get; set; }
        public string BankUrl { get; set; }
        public string BankType { get; set; }

    
    }

    public class BankListViewModel
    {
        public List<BankList> Instruments { get; set; }

    }

}