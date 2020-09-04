using cgpay.wallet.repository.BulkUpload;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.BulkUpload;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.business.BulkUpload
{


    public class BulkUploadBusiness : IBulkUploadBusiness
    {
        IBulkUploadRepository _repo;
        public BulkUploadBusiness()
        {
            _repo = new BulkUploadRepository();
        }

        public CommonDbResponse BulkUpload(string FileName, string FilePath, string ActionUser, string AgentId)
        {
             return _repo.BulkUpload(FileName, FilePath, ActionUser, AgentId);
        }

        public List<BulkUploadCommon> GetUploadedDataDetailList(string ProcessId, string ActionUser, string DataImportSource = "")
        {
            return _repo.GetUploadedDataDetailList(ProcessId, ActionUser, DataImportSource);
        }

        public List<BulkUploadCommon> GetUploadedDataList(string ProcessId, string ActionUser, string DataImportSource = "")
        {
            return _repo.GetUploadedDataList(ProcessId, ActionUser, DataImportSource);
        }

        public CommonDbResponse ClearUploadedData(string ActionUser, string DataImportSource = "")
        {
            return _repo.ClearUploadedData(ActionUser, DataImportSource);
        }

        public List<BulkTopUpCommon> BulkTopUp(string AgentId, string ActionUser, string FileName = "")
        {
            return _repo.BulkTopUp(AgentId, ActionUser, FileName);
        }

        public CommonDbResponse LogFile(string FileName, string FilePath, string ActionUser)
        {
            return _repo.LogFile(FileName, FilePath, ActionUser);
        }

        public List<BulkTopUpReceiptCommon> GetBulkTopUpReceiptList(string ProcessId = "")
        {
            return _repo.GetBulkTopUpReceiptList(ProcessId);
        }
    }
}
