using cgpay.wallet.shared.Models;
using cgpay.wallet.shared.Models.SubDistributorManagement;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.repository.SubDistributorManagement
{
    public class SubDistributorManagementRepository : ISubDistributorManagementRepository
    {
        RepositoryDao dao;
        public SubDistributorManagementRepository()
        {
            dao = new RepositoryDao();
        }
        public List<SubDistributorManagementCommon> GetSubDistributorList(string ParentId, string username, string AgentId = "")
        {
            string sql = "Exec sproc_agent_Detail_v3";
            sql += " @flag='s'";
            sql += " ,@agent_type='Sub-Distributor'";
            sql += " ,@parent_Id=" + dao.FilterParameter(ParentId);
            sql += " ,@agent_id=" + dao.FilterParameter(AgentId);
            sql += " ,@action_user=" + dao.FilterParameter(username);
            var dt = dao.ExecuteDataTable(sql);
            List<SubDistributorManagementCommon> lst = new List<SubDistributorManagementCommon>();
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    SubDistributorManagementCommon DMC = new SubDistributorManagementCommon()
                    {
                        ParentID = item["parent_id"].ToString(),
                        AgentID = item["agent_id"].ToString(),
                        AgentName = item["agent_name"].ToString(),
                        AgentOperationType = item["agent_operation_type"].ToString(),
                        AgentStatus = item["agent_status"].ToString(),
                        AgentCreditLimit = item["agent_credit_limit"].ToString(),
                        AgentMobileNumber = item["agent_mobile_no"].ToString()
                    };

                    lst.Add(DMC);
                }
            }
            return lst;
        }


        public SubDistributorManagementCommon GetSubDistributorById(string AgentId, string username)
        {
            string sql = "Exec sproc_agent_Detail_v3";
            sql += " @flag='ds'";
            sql += " ,@agent_type='Distributor'";
            sql += ", @agent_id=" + dao.FilterString(AgentId);
            sql += ", @action_user=" + dao.FilterString(username);
            var dt = dao.ExecuteDataRow(sql);
            SubDistributorManagementCommon SMC = new SubDistributorManagementCommon();
            if (dt != null)
            {
                SMC.AgentType = dt["agent_type"].ToString();
                SMC.AgentID = dt["agent_id"].ToString();
                SMC.ParentID = dt["parent_id"].ToString();
                SMC.AgentOperationType = dt["agent_operation_type"].ToString();
                //string test = dt["is_auto_commission"].ToString();
                SMC.AgentCommissionType = dt["is_auto_commission"].ToString().ToUpper() == "TRUE" ? true : false;//dt[""].ToString();
                SMC.AgentName = dt["agent_name"].ToString();
                SMC.AgentMobileNumber = dt["agent_mobile_no"].ToString();
                //SMC.AgentMobileNumber = dt["agent_mobile_no"].ToString();
                SMC.AgentEmail = dt["agent_email_address"].ToString();
                // AC.AgentWebUrl = dt["agent_web_url"].ToString();
                SMC.AgentWebUrl = dt["web_url"].ToString();
                SMC.AgentRegistrationNumber = dt["agent_registration_no"].ToString();
                SMC.AgentPanNumber = dt["agent_pan_no"].ToString();
                SMC.AgentContractDate = dt["agent_contract_local_date"].ToString();
                SMC.AgentContractDate_BS = dt["agent_contract_nepali_date"].ToString();
                SMC.AgentCountry = dt["agent_country"].ToString();
                //AC.AgentProvince = dt["agent_province"].ToString();
                //AC.AgentDistrict = dt["agent_district"].ToString();
                //AC.AgentVDC_Muncipality = dt["agent_localbody"].ToString();
                //AC.AgentWardNo = dt["agent_wardno"].ToString();
                //AC.AgentStreet = dt["agent_address"].ToString();

                SMC.AgentProvince = dt["permanent_province"].ToString();
                SMC.AgentDistrict = dt["permanent_district"].ToString();
                SMC.AgentVDC_Muncipality = dt["permanent_localbody"].ToString();
                SMC.AgentWardNo = dt["permanent_wardno"].ToString();
                SMC.AgentStreet = dt["permanent_address"].ToString();

                SMC.AgentCreditLimit = dt["agent_credit_limit"].ToString();
                SMC.AgentBalance = dt["available_balance"].ToString();
                SMC.AgentLogo = dt["agent_logo_img"].ToString();
                //AC.AgentRegistrationCertificate = dt["agent_registeration_cert_image"].ToString();
                //AC.AgentPanCertificate = dt["agent_pan_cert_image"].ToString(); 
                SMC.AgentRegistrationCertificate = dt["agent_document_img_back"].ToString();
                SMC.AgentPanCertificate = dt["agent_document_img_front"].ToString();
                SMC.UserID = dt["user_id"].ToString();
                SMC.UserName = dt["user_name"].ToString();
                //AC.Password = dt[""].ToString();
                //AC.ConfirmPassword = dt[""].ToString();
                SMC.FirstName = dt["first_name"].ToString();
                SMC.MiddleName = dt["middle_name"].ToString();
                SMC.LastName = dt["last_name"].ToString();
                SMC.UserMobileNumber = dt["user_mobile_no"].ToString();
                SMC.UserEmail = dt["user_email"].ToString();

                SMC.ContactPersonName = dt["contact_person_name"].ToString();
                SMC.ContactPersonIdType = dt["contact_person_id_type"].ToString();
                SMC.ContactPersonIdNumber = dt["contact_person_id_no"].ToString();
                SMC.ContactPersonMobileNumber = dt["contact_person_mobile_no"].ToString();

                //AC.ContactPersonIdIssueCountry = dt[""].ToString();
                SMC.ContactPersonIdIssueDistrict = dt["contact_id_issued_district"].ToString();
                SMC.ContactPersonIdIssueDate = dt["contact_id_issue_local_date"].ToString();
                SMC.ContactPersonIdIssueDate_BS = dt["contact_id_issued_bs_date"].ToString();
                //AC.ContactPersonIdExpiryDate = dt["contact_id_expiry_local_date"].ToString();
                //AC.ContactPersonIdExpiryDate_BS = dt["contact_id_expiry_bs_date"].ToString();
            }
            return SMC;
        }

        public CommonDbResponse ManageSubDistributor(SubDistributorManagementCommon DC)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += "@flag='" + (string.IsNullOrEmpty(DC.AgentID) ? "i" : "u") + "'";
            sql += " ,@agent_type='Sub-Distributor'";
            sql += " ,@agent_id=" + dao.FilterString(DC.AgentID);
            sql += " ,@agent_operation_type=" + dao.FilterString(DC.AgentOperationType);
            sql += " ,@agent_commission_type=" + DC.AgentCommissionType;
            //sql += " ,@agent_mobile_no=" + dao.FilterString(DC.AgentMobileNumber);
            //sql += " ,@agent_contract_date_bs=" + dao.FilterString(AC.AgentContractDate_BS);
            sql += " ,@agent_country=" + dao.FilterString(DC.AgentCountry);
            sql += " ,@agent_province=" + dao.FilterString(DC.AgentProvince);
            sql += " ,@agent_district=" + dao.FilterString(DC.AgentDistrict);
            sql += " ,@agent_local_body=" + dao.FilterString(DC.AgentVDC_Muncipality);
            sql += " ,@agent_ward_number=" + dao.FilterString(DC.AgentWardNo);
            sql += " ,@agent_street=" + dao.FilterString(DC.AgentStreet);
            sql += " ,@agent_available_balance=" + dao.FilterString(DC.AgentBalance);
            sql += " ,@agent_logo=" + dao.FilterString(DC.AgentLogo);
            sql += " ,@password=" + dao.FilterString(DC.Password);
            //user info
            sql += " ,@user_id=" + dao.FilterString(DC.UserID);
            sql += " ,@first_name=" + dao.FilterString(DC.FirstName);
            sql += " ,@middle_name=" + dao.FilterString(DC.MiddleName);
            sql += " ,@last_name=" + dao.FilterString(DC.LastName);
            sql += " ,@confirm_password=" + dao.FilterString(DC.ConfirmPassword);


            //contact Person
            sql += " ,@contact_person_name=" + dao.FilterString(DC.ContactPersonName);
            sql += " ,@contact_person_mobile_number=" + dao.FilterString(DC.ContactPersonMobileNumber);
            sql += " ,@contact_person_ID_type=" + dao.FilterString(DC.ContactPersonIdType);
            sql += " ,@contact_person_ID_no=" + dao.FilterString(DC.ContactPersonIdNumber);
            //sql += " ,@contact_person_id_issue_country=" + dao.FilterString(AC.ContactPersonIdIssueCountry);
            sql += " ,@contact_person_id_issue_district=" + dao.FilterString(DC.ContactPersonIdIssueDistrict);
            sql += " ,@contact_person_Id_issue_date=" + dao.FilterString(DC.ContactPersonIdIssueDate);
            sql += " ,@contact_person_id_issue_date_nepali=" + dao.FilterString(DC.ContactPersonIdIssueDate_BS);
            sql += " ,@contact_person_id_expiry_date=" + dao.FilterString(DC.ContactPersonIdExpiryDate);
            sql += " ,@contact_person_id_expiry_date_nepali=" + dao.FilterString(DC.ContactPersonIdExpiryDate_BS);
            sql += " ,@action_user=" + dao.FilterString(DC.ActionUser);
            sql += " ,@action_ip=" + dao.FilterString(DC.IpAddress);
            sql += " ,@action_platform=''";// + dao.FilterString(AC.IpAddress);
            sql += " ,@usr_type='sub-distrubutor'";
            sql += " ,@role_id='10'";
            sql += " ,@usr_type_id='10'";


            if (DC.AgentOperationType.ToUpper() == "BUSINESS")
            {
                sql += " ,@agent_mobile_no=" + dao.FilterString(DC.AgentMobileNumber);
                sql += " ,@agent_email=" + dao.FilterString(DC.AgentEmail);
                sql += " ,@agent_web_url=" + dao.FilterString(DC.AgentWebUrl);
                sql += " ,@agent_registration_no=" + dao.FilterString(DC.AgentRegistrationNumber);
                sql += " ,@agent_Pan_no=" + dao.FilterString(DC.AgentPanNumber);
                sql += " ,@agent_contract_date=" + dao.FilterString(DC.AgentContractDate);
                sql += " ,@agent_reg_certificate=" + dao.FilterString(DC.AgentRegistrationCertificate);
                sql += " ,@agent_pan_Certificate=" + dao.FilterString(DC.AgentPanCertificate);
            }
            if (string.IsNullOrEmpty(DC.AgentID))
            {
                sql += " ,@parent_id=" + dao.FilterString(DC.ParentID);
                //user Information
                sql += " ,@agent_name=" + dao.FilterString(DC.AgentName);
                sql += " ,@agent_credit_limit=" + dao.FilterString(DC.AgentCreditLimit);
                sql += " ,@user_name=" + dao.FilterString(DC.UserName);


                sql += " ,@user_mobile_number=" + dao.FilterString(DC.UserMobileNumber);
                sql += " ,@user_email=" + dao.FilterString(DC.UserEmail);
            }

            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse ExtendCreditLimit(SubDistributorCreditLimitCommon acc)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += " @flag='exc'";
            sql += ",@agent_id=" + dao.FilterString(acc.AgentId);
            sql += ",@action_user=" + dao.FilterString(acc.ActionUser);
            sql += ",@agent_credit_limit=" + dao.FilterString(acc.AgentCreditLimit);

            return dao.ParseCommonDbResponse(sql);

        }

        public CommonDbResponse Disable_EnableSubDistributor(SubDistributorManagementCommon DMC)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += " @flag='eau'";
            sql += ",@agent_id=" + dao.FilterString(DMC.AgentID);
            sql += ",@action_user=" + dao.FilterString(DMC.ActionUser);
            sql += ",@user_status=" + dao.FilterString(DMC.UserStatus);

            return dao.ParseCommonDbResponse(sql);
        }

        public List<SubDistributorManagementCommon> GetUserList(string DistId, string username, string UserId = "")
        {
            var Dis = new List<SubDistributorManagementCommon>();
            string sql = "sproc_agent_Detail_v3 @flag ='v',@agent_id= " + dao.FilterString(DistId) + ",@action_user=" + dao.FilterString(username) + ",@user_id=" + dao.FilterString(UserId);
            var dUser = dao.ExecuteDataTable(sql);
            if (dUser != null)
            {
                foreach (DataRow dr in dUser.Rows)
                {
                    SubDistributorManagementCommon Distri = new SubDistributorManagementCommon();
                    Distri.AgentID = dr["agent_id"].ToString();
                    Distri.UserID = dr["user_id"].ToString();
                    Distri.FullName = dr["full_name"].ToString();
                    Distri.UserEmail = dr["user_email"].ToString();
                    Distri.UserMobileNumber = dr["user_mobile_no"].ToString();
                    Distri.UserName = dr["user_name"].ToString();
                    //Distri.UserPassword = dr["password"].ToString();
                    Distri.UserType = dr["usr_type"].ToString();
                    Distri.IsPrimary = dr["is_primary"].ToString();
                    Distri.UserStatus = dr["status"].ToString();
                    Dis.Add(Distri);
                }
            }


            return Dis;
        }
        public CommonDbResponse ManageUser(SubDistributorManagementCommon discomm)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += "@flag ='" + (string.IsNullOrEmpty(discomm.UserID) ? "id" : "ud") + "' ";
            sql += ",@user_id =" + dao.FilterString(discomm.UserID);
            sql += ",@agent_id =" + dao.FilterString(discomm.AgentID);
            sql += ",@full_name =" + dao.FilterString(discomm.FullName);
            sql += ",@password  =" + dao.FilterString(discomm.Password);
            sql += ",@action_user =" + dao.FilterString(discomm.ActionUser);
            sql += ",@action_ip =" + dao.FilterString(discomm.IpAddress);
            sql += " ,@role_id='10'";
            if (string.IsNullOrEmpty(discomm.UserID))
            {
                sql += ",@is_primary ='N'";
                sql += ",@user_status ='Y'";
                sql += ",@usr_type_id ='10'";
                sql += ",@usr_type ='sub-distributor'";// + dao.FilterString(discomm.UserType);
                sql += ",@user_mobile_number   =" + dao.FilterString(discomm.UserMobileNumber);
                sql += ",@user_name = " + dao.FilterString(discomm.UserName);
                sql += ",@user_email  =" + dao.FilterString(discomm.UserEmail);

            }
            return dao.ParseCommonDbResponse(sql);
        }
        public SubDistributorManagementCommon GetUserById(string DistId, string UserId,string username)
        {
            var Dis = new SubDistributorManagementCommon();
            string sql = "sproc_agent_Detail_v3 @flag ='v', @user_id= " + dao.FilterString(UserId) + ",@agent_id = " + dao.FilterString(DistId)+",@action_user="+dao.FilterString(username);
            var dr = dao.ExecuteDataRow(sql);
            if (dr != null)
            {
                Dis.FullName = dr["full_name"].ToString();
                Dis.UserEmail = dr["user_email"].ToString();
                Dis.UserMobileNumber = dr["user_mobile_no"].ToString();
                Dis.UserName = dr["user_name"].ToString();
                Dis.UserType = dr["usr_type"].ToString();
                Dis.IsPrimary = dr["is_primary"].ToString();
                Dis.UserStatus = dr["status"].ToString();
            }
            return Dis;
        }
        public CommonDbResponse Disable_EnableSubDistributorUser(SubDistributorManagementCommon DMC)
        {
            string sql = "sproc_agent_Detail_v3 ";
            sql += " @flag='uu'";
            sql += ",@agent_id=" + dao.FilterString(DMC.AgentID);
            sql += ",@user_id=" + dao.FilterString(DMC.UserID);
            sql += ",@action_user=" + dao.FilterString(DMC.ActionUser);
            sql += ",@user_status=" + dao.FilterString(DMC.UserStatus);

            return dao.ParseCommonDbResponse(sql);
        }

        public CommonDbResponse AssignSubDistributorRole(string DistId, string UserId, string RoleId, string IsPrimary)
        {
            string sql = "Exec sproc_agent_detail";
            sql += " @flag='drole'";
            sql += " ,@user_id=" + dao.FilterString(UserId);
            sql += " ,@agent_id=" + dao.FilterString(DistId);
            sql += " ,@is_primary=" + dao.FilterString(IsPrimary);
            sql += " ,@role_id='10'";//+ dao.FilterString(RoleId);
            return dao.ParseCommonDbResponse(sql);
        }
        public SubDistributorManagementRolesCommon getSubDistributorRoleAssigned(string DistId, string UserId, string username)
        {
            string sql = "Exec sproc_agent_detail_v3";
            sql += " @flag='grole'";
            sql += " ,@user_id=" + dao.FilterString(UserId);
            sql += " ,@agent_id=" + dao.FilterString(DistId);
            sql += " ,@action_user=" + dao.FilterString(username);
            var dt = dao.ExecuteDataRow(sql);
            SubDistributorManagementRolesCommon RC = new SubDistributorManagementRolesCommon();
            if (dt != null)
            {
                RC.UserId = dt["user_id"].ToString();
                RC.AgentId = dt["Agent_id"].ToString();
                RC.RoleId = dt["role_id"].ToString();
                RC.IsPrimary = dt["is_primary"].ToString();
            }
            return RC;
        }
    }
}
