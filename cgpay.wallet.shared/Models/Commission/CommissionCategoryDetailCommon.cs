using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace cgpay.wallet.shared.Models.Commission
{
    public class CommissionCategoryDetailCommon:Common
    {
        public string CommissionDetailId { get; set; }
        public string CommissionCategoryId { get; set; }
        public string ProductId { get; set; }
        public string ProductLabel { get; set; }
        public string CommissionType { get; set; }
        public string CommissionPercentType { get; set; }
        public string CommissionValue { get; set; }
        public List<SelectListItem> CommissionTypeList { get; set; }
        public List<SelectListItem> CommissionPercentTypeList { get; set; }

    }
}
