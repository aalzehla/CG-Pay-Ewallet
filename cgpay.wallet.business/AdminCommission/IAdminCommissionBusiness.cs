﻿using cgpay.wallet.shared.Models.DynamicReport;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.AdminCommission
{
    public interface IAdminCommissionBusiness
    {
        List<AdminCommissionReportCommon> GetAdminCommissionReport(string FromDate="", string ToDate="");
        List<AdminCommissionReportCommon> GetAdminCommissionDetailList(string ProductId, string CurrentDate);
        List<AdminCommissionReportCommon> GetAdminCommissionDetail(string TransactionId);
    }
}
