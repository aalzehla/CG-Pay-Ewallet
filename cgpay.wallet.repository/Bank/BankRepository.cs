using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Bank;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.Bank
{
    public class BankRepository : IBankRepository
    {
        RepositoryDao repo;

        public BankRepository()
        {
            repo = new RepositoryDao();
        }
        public CommonDbResponse AddBank(BankCommon bank)
        {
            string sqlCommand = "Execute sproc_funding_bank_detail ";
            sqlCommand += "@flag = 'i' ,";
            sqlCommand += "@funding_bank_name = '"+ bank.BankName + "' ,";
            sqlCommand += "@funding_bank_branch = '" + bank.BankBranch + "' ,";
            sqlCommand += "@funding_account_number = '" + bank.BankAccountNo + "' ,";
            sqlCommand += "@funding_bank_status = '" + bank.BankStatus + "' ,";
            sqlCommand += "@action_user = '" + bank.ActionUser+ "' ,";
            sqlCommand += "@from_ip_address = '" + bank.IpAddress + "'";
            return repo.ParseCommonDbResponse(sqlCommand);
        }

        public List<BankCommon> GetBankList()
        {
            List<BankCommon> bankList = new List<BankCommon>();
            string sqlCommand = "Execute sproc_funding_bank_detail ";
            sqlCommand += "@flag = 'S'";

            DataTable bankDt =  repo.ExecuteDataTable(sqlCommand);
            if (bankDt != null)
            {
                foreach (DataRow row in bankDt.Rows)
                {
                    BankCommon b = new BankCommon();
                    b.BankID = row["funding_bank_id"].ToString();
                    b.BankName = row["funding_bank_name"].ToString();
                    b.BankAccountNo = row["funding_account_number"].ToString();
                    b.BankBranch = row["funding_bank_branch"].ToString();
                    b.BankStatus = row["bank_status"].ToString();
                    b.BankCreatedBy = row["created_by"].ToString();
                    b.CreatedDate = Convert.ToDateTime(row["created_local_date"]);
                    bankList.Add(b);
                }

            }
            return bankList;
        }

        public CommonDbResponse UpdateBank(BankCommon bank)
        {
            string sqlCommand = "Execute sproc_funding_bank_detail ";
            sqlCommand += "@flag = 'u' ,";
            sqlCommand += "@funding_bank_id = '" + bank.BankID + "' ,";
            sqlCommand += "@funding_bank_name = '" + bank.BankName + "' ,";
            sqlCommand += "@funding_bank_branch = '" + bank.BankBranch + "' ,";
            sqlCommand += "@funding_account_number = '" + bank.BankAccountNo + "' ,";
            sqlCommand += "@funding_bank_status = '" + bank.BankStatus + "' ,";
            sqlCommand += "@action_user = '" + bank.ActionUser+ "' ,";
            sqlCommand += "@from_ip_address = '" + bank.IpAddress + "'";
            return repo.ParseCommonDbResponse(sqlCommand);
        }
    }
}
