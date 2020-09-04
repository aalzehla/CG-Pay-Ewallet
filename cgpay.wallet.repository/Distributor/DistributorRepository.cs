using cgpay.wallet.shared.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace cgpay.wallet.repository.Distributor
{
    public class DistributorRepository : IDistributorRepository
    {
        RepositoryDao DAO;
        public DistributorRepository()
        {
            DAO = new RepositoryDao();
        }
        public List<shared.Models.DistributorCommon> GetDistributorList(string AgentId = "")
        {
            var Dis = new List<shared.Models.DistributorCommon>();
            string sql = "sproc_agent_detail @flag ='s',@agent_id="+DAO.FilterString(AgentId)+",@action_user= " + DAO.FilterString("superadmin");
            var dUser = DAO.ExecuteDataTable(sql);
            if (dUser != null)
            {
                foreach (DataRow item in dUser.Rows)
                {
                    shared.Models.DistributorCommon Distri = new shared.Models.DistributorCommon()
                    {
                        AgentID = item["agent_id"].ToString(),
                        AgentName = item["agent_name"].ToString(),
                        AgentOperationType = item["agent_operation_type"].ToString(),
                        AgentStatus = item["agent_status"].ToString(),
                        AgentMobileNumber = item["agent_mobile_no"].ToString(),
                        kycstatus = item["kyc_status"].ToString(),
                    };

                    Dis.Add(Distri);
                }
            }
            return Dis;
        }
        public shared.Models.DistributorCommon GetDistributorById(string DistId, string username)
        {
            var Dis = new shared.Models.DistributorCommon();
            string sql = "sproc_agent_detail @flag ='s',@action_user= " + DAO.FilterString(username) + ",@agent_id = " + DAO.FilterString(DistId);
            var dt = DAO.ExecuteDataRow(sql);
            if (dt != null)
            {
                //Agent Information

                Dis.AgentType = dt["agent_type"].ToString();
                Dis.AgentID = dt["agent_id"].ToString();
                Dis.AgentOperationType = dt["agent_operation_type"].ToString();
                Dis.isautocommission = string.IsNullOrEmpty(dt["is_auto_commission"].ToString()) ? false : Convert.ToBoolean(dt["is_auto_commission"]);
                Dis.AgentName = dt["agent_name"].ToString();
                Dis.AgentMobileNumber = dt["agent_mobile_no"].ToString();
                Dis.AgentEmail = dt["agent_email_address"].ToString();
                Dis.AgentWebUrl = dt["web_url"].ToString();
                Dis.AgentRegistrationNumber = dt["agent_registration_no"].ToString();
                Dis.AgentPanNo = dt["agent_pan_no"].ToString();
                Dis.AgentContractDate = dt["agent_contract_local_date"].ToString();//remain
                Dis.AgentAddress = dt["permanent_address"].ToString();///yo k garne
                Dis.AgentLatitude = dt["latitude"].ToString();
                Dis.AgentLongitude = dt["longitude"].ToString();
                Dis.AgentCreditLimit = (float)Convert.ToDouble(dt["agent_credit_limit"]);
                Dis.AgentBalance = (float)Convert.ToDouble(dt["available_balance"]);
                Dis.AgentLogo = dt["agent_logo_img"].ToString();
                Dis.AgentRegistrationCertificate = dt["agent_document_img_back"].ToString();
                Dis.AgentPanCertificate = dt["agent_document_img_front"].ToString();

                //   Dis.UserId = dt[""];
                //  Dis.UserName = dt[""];
                //  Dis.Password = dt[""];

                Dis.FirstName = dt["first_name"].ToString();
                Dis.MiddleName = dt["middle_name"].ToString();
                Dis.LastName = dt["last_name"].ToString();
                Dis.DOB_AD = dt["date_of_birth_eng"].ToString();
                Dis.DOB_BS = dt["date_of_birth_nep"].ToString();
                Dis.Gender = dt["gender"].ToString();
                Dis.Occupation = dt["occupation"].ToString();
                Dis.Nationality = dt["agent_nationality"].ToString();
                Dis.PermanentCountry = dt["agent_country"].ToString();
                Dis.PermanentProvince = dt["permanent_province"].ToString();
                Dis.PermanentDistrict = dt["permanent_district"].ToString();
                Dis.PermanentVDC_Muncipality = dt["permanent_localbody"].ToString();
                Dis.PermanentWardNo = dt["permanent_wardno"].ToString();
                Dis.PermanentStreet = dt["permanent_address"].ToString();
                // Dis.TemporaryCountry = dt[""];
                Dis.TemporaryProvince = dt["temporary_province"].ToString();
                Dis.TemporaryDistrict = dt["temporary_district"].ToString();
                Dis.TemporaryVDC_Muncipality = dt["temporary_localbody"].ToString();
                Dis.TemporaryWardNo = dt["temporary_wardno"].ToString();
                Dis.TemporaryStreet = dt["temporary_address"].ToString();
                Dis.ContactPersonName = dt["contact_person_name"].ToString();
                Dis.ContactPersonAddress = dt["contact_person_address"].ToString();
                Dis.ContactPersonNumber = dt["contact_person_mobile_no"].ToString();
                Dis.ContactPersonIDtype = dt["contact_person_id_type"].ToString();
                Dis.ContactPersonIDNumber = dt["contact_person_id_no"].ToString();
                Dis.ContactPersonIDIssueDate = dt["contact_id_issue_local_date"].ToString();
                Dis.ContactPersonIDIssueDate_BS = dt["contact_id_issued_bs_date"].ToString();
                //Dis.ContactPersonIDExpiryDate = dt[""];
                //Dis.ContactPersonIDExpiryDate_BS = dt[""];
                Dis.ContactPersonIDIssueDistrict = dt["contact_id_issued_district"].ToString();
                //   Dis.ContactPersonIDIssueCountry = dt[""];
                Dis.kycstatus = dt["kyc_status"].ToString();
                Dis.AgentStatus = dt["agent_status"].ToString();
            }
            return Dis;
        }
        public Dictionary<string, string> Dropdown(string flag, string search1 = "")
        {
            string sql = "sproc_get_dropdown_list";
            sql += " @flag=" + DAO.FilterString(flag);
            sql += (string.IsNullOrEmpty(search1) ? "" : ", @search_field1=" + DAO.FilterString(search1));
            //Dictionary<string, string> dict = DAO.ParseSqlToDictionary(sql);
            Dictionary<string, string> dict = new Dictionary<string, string>();
            var dbres = DAO.ExecuteDataTable(sql);
            if (dbres != null)
            {
                foreach (DataRow dr in dbres.Rows)
                {
                    {
                        dict = dbres.AsEnumerable().ToDictionary<DataRow, string, string>(row => row["value"].ToString(), row => row["text"].ToString());
                    }
                }
            }
            else
                dict = null;
            return dict;
        }
        public CommonDbResponse ManageDistributor(DistributorCommon discomm, string username)
        {
            //string sql = "sproc_agent_detail ";
            //sql += "@flag ='" + (string.IsNullOrEmpty(discomm.DistributorId) ? "i" : "u")  "'  ,@action_user = " + DAO.FilterString(username) ;

            string sql = "Exec sproc_agent_detail";
            sql += " @flag='" + (string.IsNullOrEmpty(discomm.AgentID) ? "i" : "u") + "'";
            sql += " ,@agent_type='Distributor'";
           
            sql += " ,@is_auto_commission=" + discomm.isautocommission;// DAO.FilterString(discomm.isautocommission.ToString());
            sql += " ,@agent_id=" + DAO.FilterString(discomm.AgentID);
            sql += " ,@agent_name=" + DAO.FilterString(discomm.AgentName);
            sql += " ,@agent_address=" + DAO.FilterString(discomm.AgentAddress);
            sql += " ,@mobile_number= " + DAO.FilterString(discomm.AgentMobileNumber);

            sql += " ,@web_url= " + DAO.FilterString(discomm.AgentWebUrl);
            sql += " ,@registration_no= " + DAO.FilterString(discomm.AgentRegistrationNumber);
            sql += " ,@pan_no= " + DAO.FilterString(discomm.AgentPanNo);
            sql += " ,@contract_date= " + DAO.FilterString(discomm.AgentContractDate.ToString());
            sql += " ,@phone_no= " + DAO.FilterString(discomm.AgentMobileNumber);


            sql += " ,@latitude=" + DAO.FilterString(discomm.AgentID);
            sql += " ,@longitude=" + DAO.FilterString(discomm.AgentID);
            sql += " ,@credit_limit=" + DAO.FilterString(discomm.AgentCreditLimit.ToString());
            sql += " ,@balance=" + DAO.FilterString(discomm.AgentBalance.ToString());

            //image
            sql += ", @logo_img=" + DAO.FilterString(discomm.AgentLogo);
            sql += ", @agent_doc_image_front=" + DAO.FilterString(discomm.AgentPanCertificate);
            sql += ", @agent_doc_image_back=" + DAO.FilterString(discomm.AgentRegistrationCertificate);

            //user info

            sql += " ,@first_name=" + DAO.FilterString(discomm.FirstName);
            sql += " ,@middle_name=" + DAO.FilterString(discomm.MiddleName);
            sql += " ,@last_name=" + DAO.FilterString(discomm.LastName);
            sql += " ,@user_full_name=" + DAO.FilterString(discomm.FirstName + (string.IsNullOrEmpty(discomm.MiddleName) ? "" : (" " + discomm.MiddleName)) + " " + discomm.LastName);
            sql += " ,@dob_eng=" + DAO.FilterString(discomm.DOB_AD);
            if (string.IsNullOrEmpty(discomm.AgentID))
            {
                sql += " ,@user_name=" + DAO.FilterString(discomm.UserName);
            }
            sql += " ,@dob_nepali=" + DAO.FilterString(discomm.DOB_BS);
            sql += " ,@gender=" + DAO.FilterString(discomm.Gender);
            sql += " ,@occupation=" + DAO.FilterString(discomm.Occupation);
            sql += " ,@nationality=" + DAO.FilterString(discomm.Nationality);
            //permanent Address
            sql += " ,@country=" + DAO.FilterString(discomm.PermanentCountry);
            sql += " ,@province=" + DAO.FilterString(discomm.PermanentProvince);
            sql += " ,@district=" + DAO.FilterString(discomm.PermanentDistrict);
            sql += " ,@local_body=" + DAO.FilterString(discomm.PermanentVDC_Muncipality);
            sql += " ,@ward_no=" + DAO.FilterString(discomm.PermanentWardNo);
            sql += " ,@address=" + DAO.FilterString(discomm.PermanentStreet);


            //Temporary Address
            // sql += " ,@country=" + DAO.FilterString(discomm.TemporaryCountry);
            sql += " ,@temp_province=" + DAO.FilterString(discomm.TemporaryProvince);
            sql += " ,@temp_district=" + DAO.FilterString(discomm.TemporaryDistrict);
            sql += " ,@temp_local_body=" + DAO.FilterString(discomm.TemporaryVDC_Muncipality);
            sql += " ,@temp_ward_no=" + DAO.FilterString(discomm.TemporaryWardNo);
            sql += " ,@temp_address=" + DAO.FilterString(discomm.TemporaryStreet);

            //contact person
            //if (!string.IsNullOrEmpty(discomm.AgentID))
            //{
                sql += " ,@contact_name=" + DAO.FilterString(discomm.ContactPersonName);
                sql += " ,@Contact_id_type=" + DAO.FilterString(discomm.ContactPersonIDtype);
                sql += " ,@Contact_id_issue_date=" + DAO.FilterString(discomm.ContactPersonIDIssueDate);
                sql += " ,@Contact_id_issue_date_bs=" + DAO.FilterString(discomm.ContactPersonIDIssueDate_BS);
                sql += " ,@Contact_id_address=" + DAO.FilterString(discomm.ContactPersonAddress);
                //sql += " agent_id="+DAO.FilterString(discomm.ContactPersonIDExpiryDate);
                sql += " ,@Contact_id_issue_district=" + DAO.FilterString(discomm.ContactPersonIDIssueDistrict);
            //}

            sql += " ,@mobile_no=" + DAO.FilterString(string.IsNullOrEmpty(discomm.ContactPersonNumber) ? discomm.AgentMobileNumber : discomm.ContactPersonNumber);
           
            sql += " ,@action_ip=" + DAO.FilterString(discomm.IpAddress);
            sql += ", @action_user=" + DAO.FilterString(discomm.ActionUser);
            if (!string.IsNullOrEmpty(discomm.AgentID))
            {
                sql += " ,@agent_operation_type=" + DAO.FilterString(discomm.AgentOperationType);
                sql += " ,@Contact_id_no=" + DAO.FilterString(discomm.ContactPersonIDNumber);
                //     sql += " ,@usr_type='Manager'";
                sql += " ,@email_address= " + DAO.FilterString(discomm.AgentEmail);
                sql += " ,@user_name=" + DAO.FilterString(discomm.UserName);
                sql += " ,@password=" + DAO.FilterString(discomm.Password);

            }
            return DAO.ParseCommonDbResponse(sql);
        }
        public List<shared.Models.DistributorCommon> GetUserList(string DistId,string UserId="")
        {
            var Dis = new List<shared.Models.DistributorCommon>();
            string sql = "sproc_user_detail @flag ='v',@agent_id= " + DAO.FilterString(DistId)+ ",@user_id="+DAO.FilterString(UserId);
            var dUser = DAO.ExecuteDataTable(sql);
            if (dUser != null)
            {
                foreach (DataRow dr in dUser.Rows)
                {
                    shared.Models.DistributorCommon Distri = new shared.Models.DistributorCommon();
                    Distri.AgentID = dr["agent_id"].ToString();
                    Distri.UserId = dr["user_id"].ToString();
                    Distri.UserFullName = dr["full_name"].ToString();
                    Distri.UserEmail = dr["user_email"].ToString();
                    Distri.UserMobileNo = dr["user_mobile_no"].ToString();
                    Distri.UserName = dr["user_name"].ToString();
                    //Distri.UserPassword = dr["password"].ToString();
                    Distri.UserType = dr["usr_type"].ToString();
                    Distri.isPrimary = dr["is_primary"].ToString();
                    Distri.UserStatus = dr["status"].ToString();
                    Dis.Add(Distri);
                }
            }


            return Dis;
        }
        public CommonDbResponse AssignDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary)
        {
            string sql = "Exec sproc_agent_detail";
            sql += " @flag='drole'";
            sql += " ,@user_id="+DAO.FilterString(UserId);
            sql += " ,@agent_id=" + DAO.FilterString(DistId);
            sql += " ,@is_primary=" + DAO.FilterString(IsPrimary);
            sql += " ,@role_id=" + DAO.FilterString(RoleId);
            return DAO.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse getDistributorRoleAssigned(string DistId, string UserId)
        {
            string sql = "Exec sproc_agent_detail";
            sql += " @flag='gdrole'";
            sql += " ,@user_id=" + DAO.FilterString(UserId);
            sql += " ,@agent_id=" + DAO.FilterString(DistId);
            return DAO.ParseCommonDbResponse(sql);
        }
        public shared.Models.DistributorCommon GetUserById(string DistId, string UserId = "")
        {
            var Dis = new shared.Models.DistributorCommon();
            string sql = "sproc_user_detail @flag ='v', @user_id= " + (String.IsNullOrEmpty(UserId) ? "' '" : DAO.FilterString(UserId)) + ",@agent_id = " + DAO.FilterString(DistId);
            var dr = DAO.ExecuteDataRow(sql);
            if (dr != null)
            {
                Dis.UserFullName = dr["full_name"].ToString();
                Dis.UserEmail = dr["user_email"].ToString();
                Dis.UserMobileNo = dr["user_mobile_no"].ToString();
                Dis.UserName = dr["user_name"].ToString();
                Dis.UserType = dr["usr_type"].ToString();
                Dis.isPrimary = dr["is_primary"].ToString();
                Dis.UserStatus = dr["status"].ToString();
            }
            return Dis;
        }
        public CommonDbResponse ManageUser(DistributorCommon discomm)
        {
            string sql = "sproc_user_detail ";
            sql += "@flag ='" + (string.IsNullOrEmpty(discomm.UserId) ? "i" : "u") + "' ";
            sql += ",@user_id =" + DAO.FilterString(discomm.UserId);
            sql += ",@agent_id =" + DAO.FilterString(discomm.AgentID);
            sql += ",@user_name = " + DAO.FilterString(discomm.UserName);
            sql += ",@full_name =" + DAO.FilterString(discomm.UserFullName);
            sql += ",@email  =" + DAO.FilterString(discomm.UserEmail);
            sql += ",@password  =" + DAO.FilterString(discomm.Password);
            sql += ",@mobile   =" + DAO.FilterString(discomm.UserMobileNo);
            sql += ",@usr_type =" + DAO.FilterString(discomm.UserType);
            sql += ",@is_primary =" + DAO.FilterString(discomm.isPrimary);
            sql += ",@status =" + DAO.FilterString(discomm.UserStatus);
            return DAO.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse block_unblockuser(string userid, string status, string agentid)
        {
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='uu'";
            sql += ", @status=" + DAO.FilterString(status);
            sql += ", @user_id=" + DAO.FilterString(userid);
            sql += ", @agent_id=" + DAO.FilterString(agentid);
            return DAO.ParseCommonDbResponse(sql);
        }
    }

}
