using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.Merchant;

namespace cgpay.wallet.repository.Merchant
{
    public class MerchantManagementRepository : IMerchantManagementRepository
    {

        RepositoryDao DAO;
        public MerchantManagementRepository()
        {
            DAO = new RepositoryDao();
        }

        public List<MerchantCommon> GetMerchantList(string MerchantId = "", string parentid = "")
        {
            string sql = "sproc_merchant_detail";
            sql += " @flag='s'";
            sql += " ,@merchant_type='Merchant'";
            sql += " ,@parent_Id=" + DAO.FilterParameter(parentid);
            sql += " ,@agent_id=" + DAO.FilterParameter(MerchantId);
            var dt = DAO.ExecuteDataTable(sql);
            List<MerchantCommon> lst = new List<MerchantCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    MerchantCommon merchantCommon = new MerchantCommon
                    {
                        ParentID = item["parent_id"].ToString(),
                        MerchantID = item["agent_id"].ToString(),
                        MerchantName = item["agent_name"].ToString(),
                        MerchantOperationType = item["agent_operation_type"].ToString(),
                        MerchantStatus = item["agent_status"].ToString(),
                        MerchantCreditLimit = item["agent_credit_limit"].ToString(),
                        MerchantMobileNumber = item["agent_mobile_no"].ToString(),
                        MerchantCode = item["agent_code"].ToString()
                        //UserID = item["user_id"].ToString(),
                    };
                    lst.Add(merchantCommon);
                }
            }
            return lst;
        }

        public CommonDbResponse ManageMerchant(MerchantCommon merchantCommon)
        {
            string sql = "sproc_merchant_detail ";
            sql += "@flag='" + (string.IsNullOrEmpty(merchantCommon.MerchantID) ? "i" : "u") + "'";
            sql += " ,@merchant_type='Merchant'";
            sql += " ,@agent_id=" + DAO.FilterString(merchantCommon.MerchantID);
            sql += " ,@merchant_commission_type=" + merchantCommon.MerchantCommissionType;
            sql += " ,@merchant_mobile_no=" + DAO.FilterString(merchantCommon.MerchantMobileNumber);
            sql += " ,@merchant_country=" + DAO.FilterString(merchantCommon.MerchantCountry);
            sql += " ,@merchant_province=" + DAO.FilterString(merchantCommon.MerchantProvince);
            sql += " ,@merchant_district=" + DAO.FilterString(merchantCommon.MerchantDistrict);
            sql += " ,@merchant_local_body=" + DAO.FilterString(merchantCommon.MerchantVDC_Muncipality);
            sql += " ,@merchant_ward_number=" + DAO.FilterString(merchantCommon.MerchantWardNo);
            sql += " ,@merchant_street=" + DAO.FilterString(merchantCommon.MerchantStreet);
            sql += " ,@merchant_available_balance=" + DAO.FilterString(merchantCommon.MerchantBalance);
            sql += " ,@merchant_logo=" + DAO.FilterString(merchantCommon.MerchantLogo);
            //user info
            sql += " ,@user_id=" + DAO.FilterString(merchantCommon.UserID);
            sql += " ,@first_name=" + DAO.FilterString(merchantCommon.FirstName);
            sql += " ,@middle_name=" + DAO.FilterString(merchantCommon.MiddleName);
            sql += " ,@last_name=" + DAO.FilterString(merchantCommon.LastName);
            sql += " ,@action_user=" + DAO.FilterString(merchantCommon.ActionUser);
            sql += " ,@action_ip=" + DAO.FilterString(merchantCommon.IpAddress);
            sql += " ,@action_platform=''";// + DAO.FilterString(merchantCommon.IpAddress);
            sql += " ,@role_id='12'";
            sql += " ,@usr_type='Merchant'";
            sql += " ,@usr_type_id='12'";
            sql += " ,@merchant_phone_number=" + DAO.FilterString(merchantCommon.MerchantPhoneNumber);
            sql += " ,@merchant_email=" + DAO.FilterString(merchantCommon.MerchantEmail);
            sql += " ,@merchant_web_url=" + DAO.FilterString(merchantCommon.MerchantWebUrl);
            sql += " ,@merchant_registration_no=" + DAO.FilterString(merchantCommon.MerchantRegistrationNumber);
            sql += " ,@merchant_Pan_no=" + DAO.FilterString(merchantCommon.MerchantPanNumber);
            sql += " ,@merchant_contract_date=" + DAO.FilterString(merchantCommon.MerchantContractDate);
            sql += " ,@merchant_reg_certificate=" + DAO.FilterString(merchantCommon.MerchantRegistrationCertificate);
            sql += " ,@merchant_pan_Certificate=" + DAO.FilterString(merchantCommon.MerchantPanCertificate);
            sql += " ,@merchant_name=" + DAO.FilterString(merchantCommon.MerchantName);// DAO.FilterString(merchantCommon.FirstName+" "+ merchantCommon.MiddleName+" "+merchantCommon.LastName);


            if (string.IsNullOrEmpty(merchantCommon.MerchantID))
            {
                //sql += " ,@merchant_name=" + DAO.FilterString(merchantCommon.MerchantName);// DAO.FilterString(merchantCommon.FirstName+" "+ merchantCommon.MiddleName+" "+merchantCommon.LastName);
                sql += " ,@user_name=" + DAO.FilterString(merchantCommon.UserName);
                sql += " ,@password=" + DAO.FilterString(merchantCommon.Password);
                sql += " ,@confirm_password=" + DAO.FilterString(merchantCommon.ConfirmPassword);
                sql += " ,@user_mobile_number=" + DAO.FilterString(merchantCommon.UserMobileNumber);
                sql += " ,@user_email=" + DAO.FilterString(merchantCommon.UserEmail);
                sql += " ,@parent_id=" + DAO.FilterString(merchantCommon.ParentID);
            }

            return DAO.ParseCommonDbResponse(sql);
        }

        public MerchantCommon GetMerchantById(string MerchantId)
        {
            string sql = "sproc_merchant_detail";
            sql += " @flag='md'";
            sql += ", @agent_id=" + DAO.FilterString(MerchantId);
            var dt = DAO.ExecuteDataRow(sql);
            MerchantCommon merchantCommon = new MerchantCommon();
            if (dt != null)
            {
                merchantCommon.MerchantCode = dt["agent_code"].ToString();
                merchantCommon.MerchantType = dt["agent_type"].ToString();
                merchantCommon.MerchantID = dt["agent_id"].ToString();
                merchantCommon.ParentID = dt["parent_id"].ToString();
                merchantCommon.MerchantOperationType = dt["agent_operation_type"].ToString();
                string test = dt["is_auto_commission"].ToString();
                merchantCommon.MerchantCommissionType = dt["is_auto_commission"].ToString().ToUpper() == "TRUE" ? true : false;//dt[""].ToString();
                merchantCommon.MerchantName = dt["agent_name"].ToString();
                merchantCommon.MerchantPhoneNumber = dt["agent_phone_no"].ToString();
                merchantCommon.MerchantMobileNumber = dt["agent_mobile_no"].ToString();
                merchantCommon.MerchantEmail = dt["agent_email_address"].ToString();
                merchantCommon.MerchantWebUrl = dt["web_url"].ToString();
                merchantCommon.MerchantRegistrationNumber = dt["agent_registration_no"].ToString();
                merchantCommon.MerchantPanNumber = dt["agent_pan_no"].ToString();
                merchantCommon.MerchantContractDate = dt["agent_contract_local_date"].ToString();
                merchantCommon.MerchantContractDate_BS = dt["agent_contract_nepali_date"].ToString();
                merchantCommon.MerchantCountry = dt["agent_country"].ToString();

                merchantCommon.MerchantProvince = dt["permanent_province"].ToString();
                merchantCommon.MerchantDistrict = dt["permanent_district"].ToString();
                merchantCommon.MerchantVDC_Muncipality = dt["permanent_localbody"].ToString();
                merchantCommon.MerchantWardNo = dt["permanent_wardno"].ToString();
                merchantCommon.MerchantStreet = dt["permanent_address"].ToString();

                merchantCommon.MerchantCreditLimit = dt["agent_credit_limit"].ToString();
                merchantCommon.MerchantBalance = dt["available_balance"].ToString();
                merchantCommon.MerchantLogo = dt["agent_logo_img"].ToString();
                merchantCommon.MerchantPanCertificate = dt["agent_document_img_front"].ToString();
                merchantCommon.MerchantRegistrationCertificate = dt["agent_document_img_back"].ToString();
                merchantCommon.UserID = dt["user_id"].ToString();
                merchantCommon.UserName = dt["user_name"].ToString();
                merchantCommon.FirstName = dt["first_name"].ToString();
                merchantCommon.MiddleName = dt["middle_name"].ToString();
                merchantCommon.LastName = dt["last_name"].ToString();
                merchantCommon.FullName = merchantCommon.FirstName + " " + merchantCommon.MiddleName + " " + merchantCommon.LastName;
                merchantCommon.UserMobileNumber = dt["user_mobile_no"].ToString();
                merchantCommon.UserEmail = dt["user_email"].ToString();
                merchantCommon.MerchantQr = dt["agent_qr_image"].ToString();

            }
            return merchantCommon;
        }

        public CommonDbResponse Disable_EnableMerchant(MerchantCommon merchantCommon)
        {
            string sql = "sproc_merchant_detail ";
            sql += " @flag='edm'";
            sql += ",@agent_id=" + DAO.FilterString(merchantCommon.MerchantID);
            //sql += ",@user_id=" + DAO.FilterString(merchantCommon.UserID);
            sql += ",@action_user=" + DAO.FilterString(merchantCommon.ActionUser);
            sql += ",@user_status=" + DAO.FilterString(merchantCommon.MerchantStatus);

            return DAO.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse AddCardQr(string userId, string agentId, string MerchantQr, string qrImagePath)
        {
            string sql = "sproc_merchant_detail @flag = 'qr'";
            sql += ", @agent_id=" + DAO.FilterString(agentId);
            sql += ", @user_id=" + DAO.FilterString(userId);
            sql += ", @merchantqr=" + DAO.FilterString(MerchantQr);
            sql += ", @qr_image_path=" + DAO.FilterString(qrImagePath);
            return DAO.ParseCommonDbResponse(sql);
        }

        public List<MerchantUserCommon> GetUserList(string merchantid, string username, string UserId = "")
        {
            var common = new List<MerchantUserCommon>();
            string sql = "sproc_merchant_detail @flag ='su',@agent_id= " + DAO.FilterString(merchantid) + ",@action_user=" + DAO.FilterString(username) + ",@user_id=" + DAO.FilterString(UserId);
            var MUser = DAO.ExecuteDataTable(sql);
            if (MUser != null)
            {
                foreach (DataRow dr in MUser.Rows)
                {
                    MerchantUserCommon Mcommon = new MerchantUserCommon();
                    Mcommon.MerchantId = dr["agent_id"].ToString();
                    Mcommon.UserId = dr["user_id"].ToString();
                    Mcommon.FullName = dr["full_name"].ToString();
                    Mcommon.UserEmail = dr["user_email"].ToString();
                    Mcommon.UserMobileNumber = dr["user_mobile_no"].ToString();
                    Mcommon.UserName = dr["user_name"].ToString();

                    Mcommon.IsPrimary = dr["is_primary"].ToString();
                    Mcommon.UserStatus = dr["status"].ToString();
                    common.Add(Mcommon);
                }
            }
            return common;
        }
        public CommonDbResponse ManageUser(MerchantUserCommon discomm)
        {
            string sql = "sproc_merchant_detail ";
            sql += "@flag ='" + (string.IsNullOrEmpty(discomm.UserId) ? "iu" : "uu") + "' ";
            sql += ",@user_id =" + DAO.FilterString(discomm.UserId);
            sql += ",@agent_id =" + DAO.FilterString(discomm.MerchantId);
            sql += ",@full_name =" + DAO.FilterString(discomm.FullName);
            sql += ",@password  =" + DAO.FilterString(discomm.Password);
            sql += ",@action_user =" + DAO.FilterString(discomm.ActionUser);
            sql += ",@action_ip =" + DAO.FilterString(discomm.IpAddress);
            sql += " ,@role_id='12'";
            if (string.IsNullOrEmpty(discomm.UserId))
            {
                sql += ",@is_primary ='N'";
                sql += ",@user_status ='Y'";
                sql += ",@usr_type_id ='12'";
                sql += ",@usr_type ='Merchant'";// + dao.FilterString(discomm.UserType);
                sql += ",@user_mobile_number   =" + DAO.FilterString(discomm.UserMobileNumber);
                sql += ",@user_name = " + DAO.FilterString(discomm.UserName);
                sql += ",@user_email  =" + DAO.FilterString(discomm.UserEmail);

            }
            return DAO.ParseCommonDbResponse(sql);
        }
        public MerchantUserCommon GetUserById(string merchantid, string UserId, string username)
        {
            var Dis = new MerchantUserCommon();
            string sql = "sproc_merchant_detail @flag ='su', @user_id= " + DAO.FilterString(UserId) + ",@agent_id = " + DAO.FilterString(merchantid) + ",@action_user=" + DAO.FilterString(username);
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {
                Dis.FullName = dr["full_name"].ToString();
                Dis.UserEmail = dr["user_email"].ToString();
                Dis.UserMobileNumber = dr["user_mobile_no"].ToString();
                Dis.UserName = dr["user_name"].ToString();
                //Dis.type = dr["usr_type"].ToString();
                Dis.IsPrimary = dr["is_primary"].ToString();
                Dis.UserStatus = dr["status"].ToString();
                Dis.MerchantQr = dr["agent_qr_image"].ToString();
            }
            return Dis;
        }
        public CommonDbResponse Disable_EnableMerchantUser(MerchantUserCommon DMC)
        {
            string sql = "sproc_merchant_detail ";
            sql += " @flag='edu'";
            sql += ",@agent_id=" + DAO.FilterString(DMC.MerchantId);
            sql += ",@user_id=" + DAO.FilterString(DMC.UserId);
            sql += ",@action_user=" + DAO.FilterString(DMC.ActionUser);
            sql += ",@user_status=" + DAO.FilterString(DMC.UserStatus);

            return DAO.ParseCommonDbResponse(sql);
        }

        public List<MerchantTransactionReportCommon> GetTransactionReport(string merchantid)
        {
            var common = new List<MerchantTransactionReportCommon>();
            string sql = "sproc_topup_report @flag ='mt',@agent_id= " + DAO.FilterString(merchantid) ;
            var MUser = DAO.ExecuteDataTable(sql);
            if (MUser != null)
            {
                foreach (DataRow dr in MUser.Rows)
                {
                    MerchantTransactionReportCommon Mcommon = new MerchantTransactionReportCommon();
                    Mcommon.MerchantID = dr["MerchantID"].ToString();
                    Mcommon.UserID = dr["UserId"].ToString();
                    Mcommon.MerchantCode = dr["MerchantCode"].ToString();
                    Mcommon.Amount = dr["Amount"].ToString();
                    Mcommon.CommissionAmount = dr["CommissionAmt"].ToString();
                    Mcommon.TransactionId = dr["TxnId"].ToString();

                    Mcommon.CreateDate = dr["createdDate"].ToString();
                    common.Add(Mcommon);
                }
            }
            return common;
        }

        public List<MerchantChartCommon> GetDailyTransactionChart(string UserId)
        {
            var common = new List<MerchantChartCommon>();
            string sql = "sproc_dashboard @flag ='md',@user= " + DAO.FilterString(UserId);
            var MUser = DAO.ExecuteDataTable(sql);
            if (MUser != null)
            {
                foreach (DataRow dr in MUser.Rows)
                {
                    MerchantChartCommon Mcommon = new MerchantChartCommon();
                    Mcommon.TransactionYear = dr["TxnYear"].ToString();
                    Mcommon.TransactionMonth = dr["TxnMonth"].ToString();
                    Mcommon.TransactionDay = dr["TxnDay"].ToString();
                    Mcommon.TotalAmount = dr["TotalAmount"].ToString();
                    Mcommon.TotalTransaction = dr["TotalTxn"].ToString();
                  
                    common.Add(Mcommon);
                }
            }
            return common;

        }

        public CommonDbResponse ResetPassword(MerchantCommon mCommon)
        {
            string sql = "sproc_merchant_detail @flag = 'rpass'";
            sql += ", @agent_id=" + DAO.FilterString(mCommon.MerchantID);
            sql += ", @user_id=" + DAO.FilterString(mCommon.UserID);
            sql += ", @action_user=" + DAO.FilterString(mCommon.ActionUser);
            //sql += ", @created_ip=" + DAO.FilterString(mCommon.ActionIP);
            return DAO.ParseCommonDbResponse(sql);
        }
    }
}
