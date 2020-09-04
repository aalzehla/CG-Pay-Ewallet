using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.SubDistributorManagement
{
    public class SubDistributorManagementCommon:Common
    {

        public string ParentID { get; set; }
        public string AgentType { get; set; }
        public string AgentID { get; set; }
        public string AgentOperationType { get; set; }
        public bool AgentCommissionType { get; set; }
        public string AgentStatus { get; set; }

        public string AgentName { get; set; }
        public string AgentPhoneNumber { get; set; }
        public string AgentMobileNumber { get; set; }

        public string AgentEmail { get; set; }
        public string AgentWebUrl { get; set; }
        public string AgentRegistrationNumber { get; set; }
        public string AgentPanNumber { get; set; }
        public string AgentContractDate { get; set; }
        public string AgentContractDate_BS { get; set; }
        public string AgentCountry { get; set; }
        public string AgentCountryCode { get; set; }

        public string AgentProvince { get; set; }
        public string AgentDistrict { get; set; }
        public string AgentVDC_Muncipality { get; set; }
        public string AgentWardNo { get; set; }
        public string AgentStreet { get; set; }

        public string AgentCreditLimit { get; set; }
        public string AgentBalance { get; set; }
        public string AgentLogo { get; set; }
        public string AgentRegistrationCertificate { get; set; }
        public string AgentPanCertificate { get; set; }

        //User Information
        public string UserID { get; set; }
        public string UserType { get; set; }
        public string UserStatus { get; set; }
        public string IsPrimary { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public string UserMobileNumber { get; set; }
        public string UserEmail { get; set; }

        //Contact person Details
        public string ContactPersonName { get; set; }
        public string ContactPersonMobileNumber { get; set; }
        public string ContactPersonIdType { get; set; }
        public string ContactPersonIdNumber { get; set; }
        public string ContactPersonIdIssueCountry { get; set; }
        public string ContactPersonIdIssueDistrict { get; set; }
        public string ContactPersonIdIssueDate { get; set; }
        public string ContactPersonIdIssueDate_BS { get; set; }
        public string ContactPersonIdExpiryDate { get; set; }
        public string ContactPersonIdExpiryDate_BS { get; set; }
    }
}
