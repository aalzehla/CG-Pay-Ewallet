using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributor;

namespace cgpay.wallet.repository.SubDistributor
{
    public class SubDistributorRepository:ISubDistributorRepository
    {
        RepositoryDao dao;
        public SubDistributorRepository()
        {
            dao = new RepositoryDao();
        }
        public List<SubDistributorCommon> GetSubDistributorsList(string username,string Distid, string SubDistId = "")
        {
            string sql = "Exec sproc_agent_detail";
            sql += " @flag='s'";
            sql += " ,@agent_type='sub-Distributor'";
            sql += " ,@parent_Id="+dao.FilterParameter(Distid);
            sql += " ,@agent_id="+dao.FilterParameter(SubDistId);
            sql += " ,@action_user="+dao.FilterParameter(username);
            var dt = dao.ExecuteDataTable(sql);
            List<SubDistributorCommon> lst = new List<SubDistributorCommon>();
            if(dt!=null)
            {
                foreach(DataRow item in dt.Rows)
                {
                    SubDistributorCommon SDC = new SubDistributorCommon()
                    {
                        AgentID = item["agent_id"].ToString(),
                        AgentName=item["agent_name"].ToString(),
                        AgentOperationType=item["agent_operation_type"].ToString(),
                        AgentStatus=item["agent_status"].ToString(),
                        AgentMobileNumber=item["agent_mobile_no"].ToString(),
                        kycstatus=item["kyc_status"].ToString(),
                        ParentId=item["parent_id"].ToString()


                    };

                    lst.Add(SDC);
                }
            }
            return lst;

        }
        public SubDistributorCommon GetSubDistributorById(string agentid,string username)
        {
            string sql = "sproc_agent_detail @flag ='s',@action_user= " + dao.FilterString(username) + ",@agent_id = " + dao.FilterString(agentid);
            var dt = dao.ExecuteDataRow(sql);
            SubDistributorCommon SDC = new SubDistributorCommon();
            if(dt!=null)
            {
                SDC.AgentType = dt["agent_type"].ToString();
                SDC.AgentID = dt["agent_id"].ToString();
                SDC.AgentOperationType = dt["agent_operation_type"].ToString();
                SDC.isautocommission = string.IsNullOrEmpty(dt["is_auto_commission"].ToString())? false: Convert.ToBoolean(dt["is_auto_commission"]);
                SDC.AgentName = dt["agent_name"].ToString();
                SDC.AgentMobileNumber = dt["agent_mobile_no"].ToString();
                SDC.AgentEmail = dt["agent_email_address"].ToString();
                SDC.AgentWebUrl = dt["web_url"].ToString();
                SDC.AgentRegistrationNumber = dt["agent_registration_no"].ToString();
                SDC.AgentPanNo = dt["agent_pan_no"].ToString();
               // SDC.AgentContractDate = string.IsNullOrEmpty(dt["agent_contract_local_date"].ToString()) ? Convert.ToDateTime("") : Convert.ToDateTime(dt["agent_contract_local_date"]);
                SDC.AgentAddress = dt["permanent_address"].ToString();///yo k garne
                SDC.AgentLatitude = dt["latitude"].ToString();
                SDC.AgentLongitude = dt["longitude"].ToString();
                SDC.AgentCreditLimit =(float)Convert.ToDouble( dt["agent_credit_limit"]);
                SDC.AgentBalance = (float)Convert.ToDouble(dt["available_balance"]);
                SDC.AgentLogo = dt["agent_logo_img"].ToString();
                SDC.AgentRegistrationCertificate = dt["agent_document_img_back"].ToString();
                SDC.AgentPanCertificate = dt["agent_document_img_front"].ToString();

             //   SDC.UserId = dt[""];
              //  SDC.UserName = dt[""];
              //  SDC.Password = dt[""];
                
                SDC.FirstName = dt["first_name"].ToString();
                SDC.MiddleName = dt["middle_name"].ToString();
                SDC.LastName = dt["last_name"].ToString();
                SDC.DOB_AD = dt["date_of_birth_eng"].ToString();
                SDC.DOB_BS = dt["date_of_birth_nep"].ToString();
                SDC.Gender = dt["gender"].ToString();
                SDC.Occupation = dt["occupation"].ToString();
                SDC.Nationality = dt["agent_nationality"].ToString();
                SDC.PermanentCountry = dt["agent_country"].ToString();
                SDC.PermanentProvince = dt["permanent_province"].ToString();
                SDC.PermanentDistrict = dt["permanent_district"].ToString();
                SDC.PermanentVDC_Muncipality = dt["permanent_localbody"].ToString();
                SDC.PermanentWardNo = dt["permanent_wardno"].ToString();
                  SDC.PermanentStreet = dt["permanent_address"].ToString();
                // SDC.TemporaryCountry = dt[""];
                SDC.TemporaryProvince = dt["temporary_province"].ToString();
                SDC.TemporaryDistrict = dt["temporary_district"].ToString();
                SDC.TemporaryVDC_Muncipality = dt["temporary_localbody"].ToString();
                SDC.TemporaryWardNo = dt["temporary_wardno"].ToString();
                SDC.TemporaryStreet = dt["temporary_address"].ToString();
                SDC.ContactPersonName = dt["contact_person_name"].ToString();
                //SDC.ContactPersonAddress = dt[""];
                SDC.ContactPersonNumber = dt["contact_person_mobile_no"].ToString();
                SDC.ContactPersonIDtype = dt["contact_person_id_type"].ToString();
                SDC.ContactPersonIDNumber = dt["contact_person_id_no"].ToString();
                SDC.ContactPersonIDIssueDate = dt["contact_id_issue_local_date"].ToString();
                SDC.ContactPersonIDIssueDate_BS = dt["contact_id_issued_bs_date"].ToString();
                //SDC.ContactPersonIDExpiryDate = dt[""];
                //SDC.ContactPersonIDExpiryDate_BS = dt[""];
                SDC.ContactPersonIDIssueDistrict = dt["contact_id_issued_district"].ToString();
             //   SDC.ContactPersonIDIssueCountry = dt[""];
                SDC.kycstatus = dt["kyc_status"].ToString();
                SDC.AgentStatus = dt["agent_status"].ToString();
                SDC.ParentId = dt["parent_id"].ToString();

            }
            return SDC;


        }
        public CommonDbResponse Manage(SubDistributorCommon sdc)
        {
            string sql = "Exec sproc_agent_detail";
            sql += " @flag='" + (string.IsNullOrEmpty(sdc.AgentID) ? "i" : "u") + "'";
            sql += " ,@agent_type='Sub-Distributor'";
            sql += " ,@is_auto_commission=" + sdc.isautocommission;// dao.FilterString(sdc.isautocommission.ToString());
            sql += " ,@agent_id="+dao.FilterString(sdc.AgentID);
            sql += " ,@agent_name=" + dao.FilterString(sdc.AgentName);
            sql += " ,@agent_address=" + dao.FilterString(sdc.AgentAddress);
            sql += " ,@mobile_number= " + dao.FilterString(sdc.AgentMobileNumber);
          
            sql += " ,@web_url= " + dao.FilterString(sdc.AgentWebUrl);
            sql += " ,@registration_no= " + dao.FilterString(sdc.AgentRegistrationNumber);
            sql += " ,@pan_no= " + dao.FilterString(sdc.AgentPanNo);
            sql += " ,@contract_date= " + dao.FilterString(sdc.AgentContractDate.ToString());
            sql += " ,@phone_no= " + dao.FilterString(sdc.AgentMobileNumber);


            sql += " ,@latitude=" + dao.FilterString(sdc.AgentID);
            sql += " ,@longitude=" + dao.FilterString(sdc.AgentID);
            sql += " ,@credit_limit=" + dao.FilterString(sdc.AgentCreditLimit.ToString());
            sql += " ,@balance=" + dao.FilterString(sdc.AgentBalance.ToString());

            //image
            sql += ", @logo_img=" + dao.FilterString(sdc.AgentLogo);
            sql += ", @agent_doc_image_front=" + dao.FilterString(sdc.AgentPanCertificate);
            sql += ", @agent_doc_image_back=" + dao.FilterString(sdc.AgentRegistrationCertificate);
            
            //user info

            sql += " ,@first_name=" + dao.FilterString(sdc.FirstName);
            sql += " ,@middle_name=" + dao.FilterString(sdc.MiddleName);
            sql += " ,@last_name=" + dao.FilterString(sdc.LastName);
            sql += " ,@user_full_name=" + dao.FilterString(sdc.FirstName+(string.IsNullOrEmpty(sdc.MiddleName)?"":(" "+sdc.MiddleName))+" "+sdc.LastName);
            sql += " ,@dob_eng=" + dao.FilterString(sdc.DOB_AD);
            sql += " ,@dob_nepali=" + dao.FilterString(sdc.DOB_BS);
            sql += " ,@gender=" + dao.FilterString(sdc.Gender);
            sql += " ,@occupation=" + dao.FilterString(sdc.Occupation);
            sql += " ,@nationality=" + dao.FilterString(sdc.Nationality);
            //permanent Address
            sql += " ,@country=" + dao.FilterString(sdc.PermanentCountry);
            sql += " ,@province=" + dao.FilterString(sdc.PermanentProvince);
            sql += " ,@district=" + dao.FilterString(sdc.PermanentDistrict);
            sql += " ,@local_body=" + dao.FilterString(sdc.PermanentVDC_Muncipality);
            sql += " ,@ward_no=" + dao.FilterString(sdc.PermanentWardNo);
            sql += " ,@address=" + dao.FilterString(sdc.PermanentStreet);


            //Temporary Address
           // sql += " ,@country=" + dao.FilterString(sdc.TemporaryCountry);
            sql += " ,@temp_province=" + dao.FilterString(sdc.TemporaryProvince);
            sql += " ,@temp_district=" + dao.FilterString(sdc.TemporaryDistrict);
            sql += " ,@temp_local_body=" + dao.FilterString(sdc.TemporaryVDC_Muncipality);
            sql += " ,@temp_ward_no=" + dao.FilterString(sdc.TemporaryWardNo);
            sql += " ,@temp_address=" + dao.FilterString(sdc.TemporaryStreet);
            
            //contact person
            sql += " ,@contact_name=" + dao.FilterString(sdc.ContactPersonName);
            sql += " ,@mobile_no=" + dao.FilterString(string.IsNullOrEmpty(sdc.ContactPersonNumber)?sdc.AgentMobileNumber: sdc.ContactPersonNumber);
            sql += " ,@Contact_id_type=" + dao.FilterString(sdc.ContactPersonIDtype);
            sql += " ,@Contact_id_issue_date=" + dao.FilterString(sdc.ContactPersonIDIssueDate);
            //sql += " ,agent_id="+dao.FilterString(sdc.ContactPersonIDIssueDate_BS);
            //sql += " agent_id="+dao.FilterString(sdc.ContactPersonIDExpiryDate);
            
       
            sql += " ,@Contact_id_issue_district=" + dao.FilterString(sdc.ContactPersonIDIssueDistrict);
      
            sql += " ,@action_ip=" + dao.FilterString(sdc.IpAddress);
            sql += " ,@action_user=" + dao.FilterString(sdc.ActionUser);
            if(string.IsNullOrEmpty(sdc.AgentID))
            {
                sql += " ,@agent_operation_type=" + dao.FilterString(sdc.AgentOperationType);
                sql += " ,@Contact_id_no=" + dao.FilterString(sdc.ContactPersonIDNumber);
           //     sql += " ,@usr_type='Manager'";
                sql += " ,@parent_Id=" + dao.FilterString(sdc.ParentId);
                sql += " ,@email_address= " + dao.FilterString(sdc.AgentEmail);
                sql += " ,@user_name=" + dao.FilterString(sdc.UserName);
                sql += " ,@password=" + dao.FilterString(sdc.Password);
                sql += " ,@role_id='10'";

            }
            return dao.ParseCommonDbResponse(sql);
        }

        public List<SubDistributorCommon> GetUserList(string agentid,string userId)
        {
            List<SubDistributorCommon> lst = new List<SubDistributorCommon>();
            string sql = "sproc_user_detail @flag ='v',@agent_id= " + dao.FilterString(agentid);
            sql += ",@user_id=" + dao.FilterString(userId);
            var sdUser = dao.ExecuteDataTable(sql);
            if (sdUser != null)
            {
                foreach (DataRow dr in sdUser.Rows)
                {
                    SubDistributorCommon SDC = new SubDistributorCommon();
                    SDC.AgentID = dr["agent_id"].ToString();
                    SDC.UserId = dr["user_id"].ToString();
                    SDC.UserFullName = dr["full_name"].ToString();
                    SDC. UserEmail= dr["user_email"].ToString();
                    SDC.UserMobileNo = dr["user_mobile_no"].ToString();
                    SDC.UserName = dr["user_name"].ToString();
                    //Distri.UserPassword = dr["password"].ToString();
                    SDC.UserType = dr["usr_type"].ToString();
                    SDC.isPrimary = dr["is_primary"].ToString();
                    SDC.UserStatus = dr["status"].ToString();
                    lst.Add(SDC);
                }
            }
            return lst;
        }
        
        public SubDistributorCommon GetUserById(string agentid, string UserId = "")
        {
            var SDC = new SubDistributorCommon();
            string sql = "sproc_user_detail @flag ='v', @user_id= " + (String.IsNullOrEmpty(UserId) ? "' '" : dao.FilterString(UserId)) + ",@agent_id = " + dao.FilterString(agentid);
            var dr = dao.ExecuteDataRow(sql);
            if (dr != null)
            {
                SDC.UserFullName = dr["full_name"].ToString();
                SDC.UserEmail = dr["user_email"].ToString();
                SDC.UserId = dr["user_id"].ToString();
                SDC.AgentID = dr["agent_id"].ToString();
                SDC.UserMobileNo = dr["user_mobile_no"].ToString();
                SDC.UserName = dr["user_name"].ToString();
                SDC.UserType = dr["usr_type"].ToString();
               // SDC.isPrimary = dr["is_primary"].ToString();
                SDC.UserStatus = dr["status"].ToString();
            }
            return SDC;
        }
        
        public CommonDbResponse ManageUser(SubDistributorCommon SDC,string changepassword)
        {
            string sql = "sproc_user_detail ";
            sql += "@flag ='" + (string.IsNullOrEmpty(SDC.UserId) ? "i" : "u") + "' ";
            sql += ",@user_id =" + dao.FilterString(SDC.UserId);
            sql += ",@agent_id =" + dao.FilterString(SDC.AgentID);
            sql += ",@user_name = " + dao.FilterString(SDC.UserName);
            sql += ",@full_name =" + dao.FilterString(SDC.UserFullName);
            sql += ",@email  =" + dao.FilterString(SDC.UserEmail);
            
            sql += ",@mobile   =" + dao.FilterString(SDC.UserMobileNo);
            sql += ",@usr_type_id =" + dao.FilterString(SDC.UserTypeId);
            sql += ",@usr_type =" + dao.FilterString(SDC.UserType);
          //  sql += ",@is_primary =" + dao.FilterString(SDC.isPrimary);
            sql += ",@status =" + dao.FilterString(SDC.UserStatus);
            if((!string.IsNullOrEmpty(SDC.UserId) && changepassword.ToLower()=="on") || string.IsNullOrEmpty(SDC.UserId))
            {
                sql += ",@password  =" + dao.FilterString(SDC.Password);
                sql += ",@confirm_password  =" + dao.FilterString(SDC.ConfirmPassword);
            }
            if(string.IsNullOrEmpty(SDC.UserId))
            {
                sql += ",@is_primary =" + dao.FilterString(SDC.isPrimary);
                sql += ",@role_id ='10'";
            }

            return dao.ParseCommonDbResponse(sql);
        }
        public CommonDbResponse block_unblockuser(string userid, string status,string agentid)
        {
            var sql = "Exec sproc_user_detail ";
            sql += " @flag='e'";
            sql += ", @status=" + dao.FilterString(status);
            sql += ", @user_id=" + dao.FilterString(userid);
            sql += ", @agent_id=" + dao.FilterString(agentid);
            return dao.ParseCommonDbResponse(sql);
        }
    }
}
