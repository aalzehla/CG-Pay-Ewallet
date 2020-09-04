using cgpay.wallet.shared.Models;

using cgpay.wallet.shared.Models.SubAgentManagement;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.SubAgentManagement
{
    public class SubAgentManagementRepository : ISubAgentManagementRepository
    {
        RepositoryDao dao;
        public SubAgentManagementRepository()
        {
            dao = new RepositoryDao();
        }


        public List<SubAgentManagementCommon> GetSubAgentList( string ParentId, string username, string AgentId = "")
        {
            string sql = "Exec sproc_agent_Detail_v3";
            sql += " @flag='s'";
            sql += " ,@agent_type='sub-Agent'";
            sql += " ,@parent_Id=" + dao.FilterParameter(ParentId);
            sql += " ,@agent_id=" + dao.FilterParameter(AgentId);
            sql += " ,@action_user=" + dao.FilterParameter(username);
            var dt = dao.ExecuteDataTable(sql);
            List<SubAgentManagementCommon> lst = new List<SubAgentManagementCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    SubAgentManagementCommon SAC = new SubAgentManagementCommon()
                    {
                        ParentID = item["parent_id"].ToString(),
                        AgentID = item["agent_id"].ToString(),
                        AgentName = item["agent_name"].ToString(),
                        AgentOperationType = item["agent_operation_type"].ToString(),
                       


                        AgentStatus = item["agent_status"].ToString(),
                        AgentCreditLimit = item["agent_credit_limit"].ToString(),
                        AgentMobileNumber = item["agent_mobile_no"].ToString()


                    };

                    lst.Add(SAC);
                }
            }
            return lst;
        }


        public SubAgentManagementCommon GetSubAgentById(string AgentId, string username)
        {
            string sql = "Exec sproc_agent_Detail_v3";
            sql += " @flag='ds'";
            sql += ", @agent_id=" + dao.FilterString(AgentId);
            sql += ", @action_user=" + dao.FilterString(username);
            var dt = dao.ExecuteDataRow(sql);
            SubAgentManagementCommon AC = new SubAgentManagementCommon();
            if (dt != null)
            {
                AC.AgentType = dt["agent_type"].ToString();
                AC.AgentID = dt["agent_id"].ToString();
                AC.ParentID = dt["parent_id"].ToString();
                AC.AgentOperationType = dt["agent_operation_type"].ToString();
                //string test = dt["is_auto_commission"].ToString();
                AC.AgentCommissionType = dt["is_auto_commission"].ToString().ToUpper() == "TRUE" ? true : false;//dt[""].ToString();
                AC.AgentName = dt["agent_name"].ToString();
                AC.AgentPhoneNumber = dt["agent_phone_no"].ToString();
                AC.AgentMobileNumber = dt["agent_mobile_no"].ToString();
                AC.AgentEmail = dt["agent_email_address"].ToString();
                // AC.AgentWebUrl = dt["agent_web_url"].ToString();
                AC.AgentWebUrl = dt["web_url"].ToString();
                AC.AgentRegistrationNumber = dt["agent_registration_no"].ToString();
                AC.AgentPanNumber = dt["agent_pan_no"].ToString();
                AC.AgentContractDate = dt["agent_contract_local_date"].ToString();
                AC.AgentContractDate_BS = dt["agent_contract_nepali_date"].ToString();
                AC.AgentCountry = dt["agent_country"].ToString();
                //AC.AgentProvince = dt["agent_province"].ToString();
                //AC.AgentDistrict = dt["agent_district"].ToString();
                //AC.AgentVDC_Muncipality = dt["agent_localbody"].ToString();
                //AC.AgentWardNo = dt["agent_wardno"].ToString();
                //AC.AgentStreet = dt["agent_address"].ToString();

                AC.AgentProvince = dt["permanent_province"].ToString();
                AC.AgentDistrict = dt["permanent_district"].ToString();
                AC.AgentVDC_Muncipality = dt["permanent_localbody"].ToString();
                AC.AgentWardNo = dt["permanent_wardno"].ToString();
                AC.AgentStreet = dt["agent_address"].ToString();

                AC.AgentCreditLimit = dt["agent_credit_limit"].ToString();
                AC.AgentBalance = dt["available_balance"].ToString();
                AC.AgentLogo = dt["agent_logo_img"].ToString();
                //AC.AgentRegistrationCertificate = dt["agent_registeration_cert_image"].ToString();
                //AC.AgentPanCertificate = dt["agent_pan_cert_image"].ToString(); 
                AC.AgentRegistrationCertificate = dt["agent_document_img_back"].ToString();
                AC.AgentPanCertificate = dt["agent_document_img_front"].ToString();
                AC.UserID = dt["user_id"].ToString();
                AC.UserName = dt["user_name"].ToString();
                //AC.Password = dt[""].ToString();
                //AC.ConfirmPassword = dt[""].ToString();
                AC.FirstName = dt["first_name"].ToString();
                AC.MiddleName = dt["middle_name"].ToString();
                AC.LastName = dt["last_name"].ToString();
                AC.UserMobileNumber = dt["user_mobile_no"].ToString();
                AC.UserEmail = dt["user_email"].ToString();

                AC.ContactPersonName = dt["contact_person_name"].ToString();
                AC.ContactPersonMobileNumber = dt["contact_person_mobile_no"].ToString();
                AC.ContactPersonIdType = dt["contact_person_id_type"].ToString();
                AC.ContactPersonIdNumber = dt["contact_person_id_no"].ToString();
                //AC.ContactPersonIdIssueCountry = dt[""].ToString();
                AC.ContactPersonIdIssueDistrict = dt["contact_id_issued_district"].ToString();
                AC.ContactPersonIdIssueDate = dt["contact_id_issue_local_date"].ToString();
                AC.ContactPersonIdIssueDate_BS = dt["contact_id_issued_bs_date"].ToString();
                //AC.ContactPersonIdExpiryDate = dt["contact_id_expiry_local_date"].ToString();
                //AC.ContactPersonIdExpiryDate_BS = dt["contact_id_expiry_bs_date"].ToString();
            }
            return AC;
        }

        public CommonDbResponse ManageSubAgent(SubAgentManagementCommon AC)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += "@flag='" + (string.IsNullOrEmpty(AC.AgentID) ? "i" : "u") + "'";
            sql += " ,@agent_type='Sub-Agent'";
            sql += " ,@agent_id=" + dao.FilterString(AC.AgentID);
          
            sql += " ,@agent_operation_type=" + dao.FilterString(AC.AgentOperationType);
            sql += " ,@agent_commission_type=" + AC.AgentCommissionType;
        //    sql += " ,@agent_mobile_no=" + dao.FilterString(AC.AgentMobileNumber);
            //sql += " ,@agent_contract_date_bs=" + dao.FilterString(AC.AgentContractDate_BS);
            sql += " ,@agent_country=" + dao.FilterString(AC.AgentCountry);
            sql += " ,@agent_province=" + dao.FilterString(AC.AgentProvince);
            sql += " ,@agent_district=" + dao.FilterString(AC.AgentDistrict);
            sql += " ,@agent_local_body=" + dao.FilterString(AC.AgentVDC_Muncipality);
            sql += " ,@agent_ward_number=" + dao.FilterString(AC.AgentWardNo);
            sql += " ,@agent_street=" + dao.FilterString(AC.AgentStreet);
            sql += " ,@agent_available_balance=" + dao.FilterString(AC.AgentBalance);
            sql += " ,@agent_logo=" + dao.FilterString(AC.AgentLogo);
            //sql += " ,@password=" + dao.FilterString(AC.Password);
            //user info
            sql += " ,@user_id=" + dao.FilterString(AC.UserID);
            sql += " ,@first_name=" + dao.FilterString(AC.FirstName);
            sql += " ,@middle_name=" + dao.FilterString(AC.MiddleName);
            sql += " ,@last_name=" + dao.FilterString(AC.LastName);
            //sql += " ,@confirm_password=" + dao.FilterString(AC.ConfirmPassword);


            //contact Person
            sql += " ,@contact_person_name=" + dao.FilterString(AC.ContactPersonName);
            sql += " ,@contact_person_mobile_number=" + dao.FilterString(AC.ContactPersonMobileNumber);
            sql += " ,@contact_person_ID_type=" + dao.FilterString(AC.ContactPersonIdType);
            sql += " ,@contact_person_ID_no=" + dao.FilterString(AC.ContactPersonIdNumber);
            //sql += " ,@contact_person_id_issue_country=" + dao.FilterString(AC.ContactPersonIdIssueCountry);
            sql += " ,@contact_person_id_issue_district=" + dao.FilterString(AC.ContactPersonIdIssueDistrict);
            sql += " ,@contact_person_Id_issue_date=" + dao.FilterString(AC.ContactPersonIdIssueDate);
            sql += " ,@contact_person_id_issue_date_nepali=" + dao.FilterString(AC.ContactPersonIdIssueDate_BS);
            sql += " ,@contact_person_id_expiry_date=" + dao.FilterString(AC.ContactPersonIdExpiryDate);
            sql += " ,@contact_person_id_expiry_date_nepali=" + dao.FilterString(AC.ContactPersonIdExpiryDate_BS);
            sql += " ,@action_user=" + dao.FilterString(AC.ActionUser);
            sql += " ,@action_ip=" + dao.FilterString(AC.IpAddress);
            sql += " ,@action_platform=''";// + dao.FilterString(AC.IpAddress);
            sql += " ,@usr_type='sub-agent'";
            sql += " ,@role_id='11'";
            sql += " ,@usr_type_id='11'";

            //sql += " ,@agent_mobile_no=" + dao.FilterString(AC.AgentMobileNumber);
            //sql += " ,@agent_email=" + dao.FilterString(AC.AgentEmail);
            sql += " ,@agent_web_url=" + dao.FilterString(AC.AgentWebUrl);
            sql += " ,@agent_registration_no=" + dao.FilterString(AC.AgentRegistrationNumber);
            sql += " ,@agent_Pan_no=" + dao.FilterString(AC.AgentPanNumber);
            sql += " ,@agent_contract_date=" + dao.FilterString(AC.AgentContractDate);
            sql += " ,@agent_reg_certificate=" + dao.FilterString(AC.AgentRegistrationCertificate);
            sql += " ,@agent_pan_Certificate=" + dao.FilterString(AC.AgentPanCertificate);
            //if (AC.AgentOperationType.ToUpper() == "BUSINESS")
            //{
            //    sql += " ,@agent_mobile_no=" + dao.FilterString(AC.AgentMobileNumber);
            //    sql += " ,@agent_email=" + dao.FilterString(AC.AgentEmail);
            //    sql += " ,@agent_web_url=" + dao.FilterString(AC.AgentWebUrl);
            //    sql += " ,@agent_registration_no=" + dao.FilterString(AC.AgentRegistrationNumber);
            //    sql += " ,@agent_Pan_no=" + dao.FilterString(AC.AgentPanNumber);
            //    sql += " ,@agent_contract_date=" + dao.FilterString(AC.AgentContractDate);
            //    sql += " ,@agent_reg_certificate=" + dao.FilterString(AC.AgentRegistrationCertificate);
            //    sql += " ,@agent_pan_Certificate=" + dao.FilterString(AC.AgentPanCertificate);
            //}
            if (AC.AgentOperationType.ToUpper() == "BUSINESS")
            {
                sql += " ,@agent_mobile_no=" + dao.FilterString(AC.AgentMobileNumber);
                sql += " ,@agent_email=" + dao.FilterString(AC.AgentEmail);
            }
            else
            {
                sql += " ,@agent_mobile_no=" + dao.FilterString(AC.UserMobileNumber);
                sql += " ,@agent_email=" + dao.FilterString(AC.UserEmail);
            }

            if (!string.IsNullOrEmpty(AC.Password))
            {
                sql += " ,@password=" + dao.FilterString(AC.Password);
                sql += " ,@confirm_password=" + dao.FilterString(AC.ConfirmPassword);
            }
            if (string.IsNullOrEmpty(AC.AgentID))
            {
                sql += " ,@parent_id=" + dao.FilterString(AC.ParentID);
                //user Information
                sql += " ,@agent_name=" + dao.FilterString(AC.AgentName);
                sql += " ,@agent_credit_limit=" + dao.FilterString(AC.AgentCreditLimit);
                sql += " ,@user_name=" + dao.FilterString(AC.UserName);
                sql += " ,@user_mobile_number=" + dao.FilterString(AC.UserMobileNumber);
                sql += " ,@user_email=" + dao.FilterString(AC.UserEmail);
            }

            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse ExtendCreditLimit(SubAgentCreditLimitCommon acc)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += " @flag='exc'";
            sql += ",@agent_id=" + dao.FilterString(acc.AgentId);
            sql += ",@action_user=" + dao.FilterString(acc.ActionUser);
            sql += ",@agent_credit_limit=" + dao.FilterString(acc.AgentCreditLimit);

            return dao.ParseCommonDbResponse(sql);

        }

        public CommonDbResponse Disable_EnableSubAgent(SubAgentManagementCommon amc)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += " @flag='eau'";
            sql += ",@agent_id=" + dao.FilterString(amc.AgentID);
            sql += ",@action_user=" + dao.FilterString(amc.ActionUser);
            sql += ",@user_status=" + dao.FilterString(amc.UserStatus);

            return dao.ParseCommonDbResponse(sql);
        }
    }
}
