using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.BulkUpload;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.BulkUpload
{
    public interface IBulkUploadBusiness
    {
        CommonDbResponse BulkUpload(string FileName, string FilePath, string ActionUser, string AgentId);

        List<BulkUploadCommon> GetUploadedDataList(string ProcessId, string ActionUser, string DataImportSource = "");
        List<BulkUploadCommon> GetUploadedDataDetailList(string ProcessId, string ActionUser, string DataImportSource = "");

        CommonDbResponse ClearUploadedData(string ActionUser, string DataImportSource = "");

        List<BulkTopUpCommon> BulkTopUp(string AgentId, string ActionUser, string FileName = "");

        CommonDbResponse LogFile(string FileName, string FilePath, string ActionUser);

        List<BulkTopUpReceiptCommon> GetBulkTopUpReceiptList(string ProcessId = "");
    }
}
