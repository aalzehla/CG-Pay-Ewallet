using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cgpay.wallet.shared.Models.Merchant
{
    public class MerchantCommon:Common
    {
        public string MerchantType { get; set; }
        public string MerchantID { get; set; }
        public string ParentID { get; set; }
        public string MerchantOperationType { get; set; }
        public bool MerchantCommissionType { get; set; }
        public string MerchantStatus { get; set; }
        public string MerchantName { get; set; }
        public string MerchantPhoneNumber { get; set; }
        public string MerchantMobileNumber { get; set; }
        public string MerchantEmail { get; set; }
        public string MerchantWebUrl { get; set; }
        public string MerchantRegistrationNumber { get; set; }
        public string MerchantPanNumber { get; set; }
        public string MerchantContractDate { get; set; }
        public string MerchantContractDate_BS { get; set; }
        public string MerchantCountry { get; set; }
        public string MerchantCountryCode { get; set; }
        public string MerchantProvince { get; set; }
        public string MerchantDistrict { get; set; }
        public string MerchantVDC_Muncipality { get; set; }
        public string MerchantWardNo { get; set; }
        public string MerchantStreet { get; set; }
        public string MerchantCreditLimit { get; set; }
        public string MerchantBalance { get; set; }
        public string MerchantLogo { get; set; }
        public string MerchantRegistrationCertificate { get; set; }
        public string MerchantPanCertificate { get; set; }
        public string MerchantCode { get; set; }
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
        public string MerchantQr { get; set; }
    }
    public class MerchantUserCommon : Common
    {
        public string MerchantId { get; set; }
        public string UserId { get; set; }
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
        public string UserStatus { get; set; }
        public string MerchantQr { get; set; }
    }
}
