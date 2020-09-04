    using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.KYC;
using cgpay.wallet.shared.Models.Menus;


namespace cgpay.wallet.repository.KYC
{
    public class KYCRepository : IKYCRepository
    {
        RepositoryDao DAO;
        public KYCRepository()
        {
            DAO = new RepositoryDao();
        }

        public List<KYCCommon> GetAgentList(KycFilterCommon model)
        {
            var KycDetails = new List<KYCCommon>();
            string sql = "sproc_kyc_manage @flag ='list' ";
            sql += string.IsNullOrEmpty(model.KycStatus)? "" : ", @kyc_status =" + DAO.FilterString(model.KycStatus); 
            sql += string.IsNullOrEmpty(model.Email)? "" : ", @email_address =" + DAO.FilterString(model.Email);
            sql += string.IsNullOrEmpty(model.MobileNumber)? "" : ", @mobile_no =" + DAO.FilterString(model.MobileNumber);
            sql += string.IsNullOrEmpty(model.FromDate)? "" : ", @from_date =" + DAO.FilterString(model.FromDate);
            sql += string.IsNullOrEmpty(model.ToDate)? "" : ", @to_date =" + DAO.FilterString(model.ToDate);
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    KYCCommon KycDetail = new KYCCommon();
                    KycDetail.AgentId = dr["AgentId"].ToString();
                    KycDetail.MobileNo = dr["Mobile"].ToString();
                    KycDetail.EmailAddress = dr["Email"].ToString();
                    KycDetail.SubmittedDate = DateTime.Parse(dr["SubmittedDate"].ToString()).ToLongDateString();
                    KycDetail.KycStatus = dr["KYCStatus"].ToString();

                    KycDetails.Add(KycDetail);
                }
            }
            return KycDetails;
        }

        public KYCCommon AgentKycInfo(string AgentId)
        {
            KYCCommon kycCommon = new KYCCommon();
            string sql = "sproc_kyc_manage @flag ='v', @agent_id= '" + AgentId + "'";
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    kycCommon.AgentType= dr["agent_type"].ToString();
                    kycCommon.AgentId= dr["agent_id"].ToString();
                    kycCommon.FirstName = dr["first_name"].ToString();
                    kycCommon.MiddleName = dr["middle_name"].ToString();
                    kycCommon.LastName = dr["last_name"].ToString();
                    kycCommon.DOB_Eng = dr["date_of_birth_eng"].ToString();
                    kycCommon.DOB_Nep = dr["date_of_birth_nep"].ToString();
                    //kycCommon.DOB_Eng = string.IsNullOrEmpty(dr["date_of_birth_eng"].ToString()) ? "" : Convert.ToDateTime(dr["date_of_birth_eng"].ToString()).ToString("yyyy-MM-dd");
                    //kycCommon.DOB_Nep = string.IsNullOrEmpty(dr["date_of_birth_nep"].ToString()) ? "" : Convert.ToDateTime(dr["date_of_birth_nep"].ToString()).ToString("yyyy-MM-dd");
                    kycCommon.Gender = dr["gender"].ToString();
                    kycCommon.Occupation = dr["occupation"].ToString();
                    kycCommon.MaritalStatus = dr["marital_status"].ToString();
                    kycCommon.SpouseName = dr["spouse_name"].ToString();
                    kycCommon.FatherName = dr["father_name"].ToString();
                    kycCommon.MotherName = dr["mother_name"].ToString();
                    kycCommon.GrandFatherName = dr["grand_father_name"].ToString();
                    kycCommon.Nationality = dr["agent_nationality"].ToString();
                    kycCommon.Country = dr["agent_country"].ToString();
                    kycCommon.PProvince = dr["permanent_province"].ToString();
                    kycCommon.PDistrict = dr["permanent_district"].ToString();
                    kycCommon.PLocalBody = dr["permanent_localbody"].ToString();
                    kycCommon.PWardNo = dr["permanent_wardno"].ToString();
                    kycCommon.PAddress = dr["permanent_address"].ToString();
                    kycCommon.TProvince = dr["temporary_province"].ToString();
                    kycCommon.TDistrict = dr["temporary_district"].ToString();
                    kycCommon.TLocalBody = dr["temporary_localbody"].ToString();
                    kycCommon.TWardNo = dr["temporary_wardno"].ToString();
                    kycCommon.TAddress = dr["temporary_address"].ToString();
                    kycCommon.PhoneNo = dr["agent_phone_no"].ToString();
                    kycCommon.EmailAddress = dr["agent_email_address"].ToString();
                    kycCommon.MobileNo = dr["agent_mobile_no"].ToString();
                    kycCommon.Remarks = dr["admin_remarks"].ToString();
                    kycCommon.KycStatus = dr["KYC_Status"].ToString();
                    kycCommon.Id_type = dr["Identification_type"].ToString();
                    kycCommon.Id_No = dr["Identification_NO"].ToString();
                    kycCommon.Id_IssuedDateAD = string.IsNullOrEmpty(dr["Identification_issued_date"].ToString()) ? "" : Convert.ToDateTime(dr["Identification_issued_date"].ToString()).ToString("yyyy-MM-dd");
                    kycCommon.Id_IssuedDateBS = string.IsNullOrEmpty(dr["Identification_issued_date_nepali"].ToString()) ? "" : Convert.ToDateTime(dr["Identification_issued_date_nepali"].ToString()).ToString("yyyy-MM-dd");
                    kycCommon.Id_ExpiryDateAD = string.IsNullOrEmpty(dr["Identification_expiry_date"].ToString()) ? "" : Convert.ToDateTime(dr["Identification_expiry_date"].ToString()).ToString("yyyy-MM-dd");
                    kycCommon.Id_ExpiryDateBS = string.IsNullOrEmpty(dr["identification_expiry_date_nepali"].ToString()) ? "" : Convert.ToDateTime(dr["identification_expiry_date_nepali"].ToString()).ToString("yyyy-MM-dd");
                    //kycCommon.Id_IssuedDateAD = dr["Identification_issued_date"].ToString();
                    //kycCommon.Id_IssuedDateBS = dr["Identification_issued_date_nepali"].ToString();
                    //kycCommon.Id_ExpiryDateAD = dr["Identification_expiry_date"].ToString();
                    //kycCommon.Id_ExpiryDateBS = dr["identification_expiry_date_nepali"].ToString();
                    kycCommon.Id_IssuedPlace = dr["Identification_issued_place"].ToString();
                    kycCommon.PPImage = dr["Identification_photo_Logo"].ToString();
                    kycCommon.Id_DocumentFront = dr["Id_document_front"].ToString();
                    kycCommon.Id_DocumentBack = dr["Id_document_back"].ToString();
                    //kycCommon.SubmittedDate = DateTime.Parse(dr["Submitted Date"].ToString());

                }
            }
            else
                kycCommon = null;

            return kycCommon;
        }

        public Dictionary<string, string> Dropdown(string flag, string search1="")
        {
            string sql = "sproc_get_dropdown_list";
            sql += " @flag=" + DAO.FilterString(flag);
            sql += (string.IsNullOrEmpty(search1) ?"": ", @search_field1="+ DAO.FilterString(search1));
            //Dictionary<string, string> dict = DAO.ParseSqlToDictionary(sql);
            Dictionary<string, string> dict = new Dictionary<string, string>();
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                        dict = dbres.AsEnumerable().ToDictionary<DataRow, string, string>(row => row["value"].ToString(), row => row["text"].ToString());
                }
            }

            else
                dict = null;
            return dict;
        }

        public CommonDbResponse UpadateKycDetails(KYCCommon kycCommon, string status )
        {
            string sql = "sproc_kyc_manage ";
            sql += "@flag =" + DAO.FilterString(status);
            sql += ",@first_name=" + DAO.FilterString(kycCommon.FirstName);
            sql += ",@middle_name=" + DAO.FilterString(kycCommon.MiddleName);
            sql += ",@last_name=" + DAO.FilterString(kycCommon.LastName);
            sql += ",@dob_eng=" + DAO.FilterString(kycCommon.DOB_Eng);
            sql += ",@dob_nep=" + DAO.FilterString(kycCommon.DOB_Nep);
            sql += ",@gender=" + DAO.FilterString(kycCommon.Gender);
            sql += ",@occupation=" + DAO.FilterString(kycCommon.Occupation);
            sql += ",@marital_status=" + DAO.FilterString(kycCommon.MaritalStatus);
            sql += ",@spouse_name=" + DAO.FilterString(kycCommon.SpouseName);
            sql += ",@father_name=" + DAO.FilterString(kycCommon.FatherName);
            sql += ",@mother_name=" + DAO.FilterString(kycCommon.MotherName);
            sql += ",@grand_father_name=" + DAO.FilterString(kycCommon.GrandFatherName);
            sql += ",@nationality=" + DAO.FilterString(kycCommon.Nationality);
            sql += ",@country=" + DAO.FilterString(kycCommon.Country);
            sql += ",@province=" + DAO.FilterString(kycCommon.PProvince);
            sql += ",@district=" + DAO.FilterString(kycCommon.PDistrict);
            sql += ",@local_body=" + DAO.FilterString(kycCommon.PLocalBody);
            sql += ",@ward_no=" + DAO.FilterString(kycCommon.PWardNo);
            sql += ",@address=" + DAO.FilterString(kycCommon.PAddress);
            sql += ",@temp_province=" + DAO.FilterString(kycCommon.TProvince);
            sql += ",@temp_district=" + DAO.FilterString(kycCommon.TDistrict);
            sql += ",@temp_local_body=" + DAO.FilterString(kycCommon.TLocalBody);
            sql += ",@temp_ward_no=" + DAO.FilterString(kycCommon.TWardNo);
            sql += ",@temp_address=" + DAO.FilterString(kycCommon.TAddress);
            sql += ",@phone_no=" + DAO.FilterString(kycCommon.PhoneNo);
            sql += ",@email_address=" + DAO.FilterString(kycCommon.EmailAddress);
            sql += ",@action_user=" + DAO.FilterString(kycCommon.ActionUser);
            sql += ",@action_ip_address=" + DAO.FilterString(kycCommon.Updated_IP);
            sql += ",@mobile_no=" + DAO.FilterString(kycCommon.MobileNo);
            sql += ",@remarks=" + DAO.FilterString(kycCommon.Remarks);
            //Document Details
            sql += ",@agent_id=" + DAO.FilterString(kycCommon.AgentId);
            sql += ",@id_type=" + DAO.FilterString(kycCommon.Id_type);
            sql += ",@id_number=" + DAO.FilterString(kycCommon.Id_No);
            sql += ",@id_issuedate_local=" + DAO.FilterString(kycCommon.Id_IssuedDateAD);
            sql += ",@id_issue_date_nepali=" + DAO.FilterString(kycCommon.Id_IssuedDateBS);
            sql += ",@id_expiry_date_local=" + DAO.FilterString(kycCommon.Id_ExpiryDateAD);
            sql += ",@id_expiry_date_nepali=" + DAO.FilterString(kycCommon.Id_ExpiryDateBS);
            sql += ",@id_issue_district=" + DAO.FilterString(kycCommon.Id_IssuedPlace);
            sql += ",@ppPhoto_img=" + DAO.FilterString(kycCommon.PPImage);
            sql += ",@id_front_img=" + DAO.FilterString(kycCommon.Id_DocumentFront);
            sql += ",@id_back_photo_img=" + DAO.FilterString(kycCommon.Id_DocumentBack);
            //sql += ",first_name=" + DAO.FilterString(kycCommon.FirstName);

            return DAO.ParseCommonDbResponse(sql);
        }
    }
}
