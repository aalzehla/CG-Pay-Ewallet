using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace cgpay.wallet.application.Models
{
    public class KYCModel
    {
        public string UserId { get; set; }
        public string AgentId { get; set; }
        public string ActionUser { get; set; }
        public string ActionIpAddress { get; set; }
        public string CreatedPlatform { get; set; }
        public string AgentType { get; set; }
        public string SubmittedDate { get; set; }
        public string Action { get; set; }
        public string KycStatus { get; set; }

        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "First Name is required")]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Display(Name = "Middle Name")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        public string MiddleName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Last Name is required")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }

        [Display(Name = "Full Name")]
        public string FullName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Date of Birth is required")]
        [Display(Name = "Date of Birth (AD)")]
        //[DataType(DataType.Date)]
        public string DOB_Eng { get; set; }

        [Display(Name = "Date of Birth (BS)")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Date of Birth is required")]
        //[DataType(DataType.Date)]
        public string DOB_Nep { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Gender is required")]
        public string Gender { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Occupation is required")]
        public string Occupation { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Marital Status is required")]
        [Display(Name = "Marital Status")]
        public string MaritalStatus { get; set; }

        [Display(Name = "Spouse's Name")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        public string SpouseName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Father's Name is required")]
        [Display(Name = "Father's Name")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        public string FatherName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Mother's Name is required")]
        [Display(Name = "Mother's Name")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        public string MotherName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Grand Father's Name is required")]
        [Display(Name = "Grand Father's Name")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        public string GrandFatherName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Nationality is required")]
        [RegularExpression("^[a-zA-Z ]*$", ErrorMessage = "Only Alphabets allowed")]
        public string Nationality { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Country Name is required")]
        public string Country { get; set; }

        [Display(Name = "Permanent Province ")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Province is required")]
        public string PProvince { get; set; }


        [Display(Name = "Permanent District")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent District is required")]
        public string PDistrict { get; set; }

        [Display(Name = "Permanent VDC/Muncipality")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent VDC/Muncipality is required")]
        public string PLocalBody { get; set; }

        [Display(Name = "Permanent Ward No")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Ward No is required")]
        [MaxLength(2, ErrorMessage = "Ward Number has maximum 2 digits")]
        [Range(1, 99, ErrorMessage = "Invalid Ward Number")]//Int32.MaxValue
        public string PWardNo { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Permanent Street is required")]
        [Display(Name = "Permanent Street")]
        public string PAddress { get; set; }

        [Display(Name = "Temporary Province ")]
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Province is required")]
        public string TProvince { get; set; }
        [Display(Name = "Temporary District")]
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Temporary District is required")]
        public string TDistrict { get; set; }

        //[Required(AllowEmptyStrings = false, ErrorMessage = "Temporary VDC/Muncipality is required")]
        [Display(Name = "Temporary VDC/Muncipality")]
        public string TLocalBody { get; set; }

        [Display(Name = "Temporary Ward No")]
        //[Required(AllowEmptyStrings = false, ErrorMessage = "Temporary Ward No is required")]
        [MaxLength(2, ErrorMessage = "Ward Number has maximum 2 digits")]
        [Range(1, 99, ErrorMessage = "Invalid Ward Number")]//Int32.MaxValue
        public string TWardNo { get; set; }

        [Display(Name = "Temporary Street")]
        public string TAddress { get; set; }

        [Display(Name = "Phone Number")]
        [RegularExpression("^[0-9]*$", ErrorMessage = "Only Numbers allowed")]
        public string PhoneNo { get; set; }

        [Display(Name = "Mobile Number")]
        [RegularExpression("^[9][0-9]*$", ErrorMessage = "Phone Number Start With 9")]
        [MaxLength(10, ErrorMessage = "Mobile Number Max Length is Invalid"), MinLength(10, ErrorMessage = "Mobile Number Minimum Length is Invalid")]
        public string MobileNo { get; set; }

        [Display(Name = "Email Address")]
        [EmailAddress]
        public string EmailAddress { get; set; }


        [Display(Name = "Profile Image")]
        public string PPImage { get; set; }

        public string UpdatedBy { get; set; }

        public string Updated_IP { get; set; }


        //THIS IS FOR KYC DOCUMENTS
        [Display(Name = "ID Type")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "ID. is required")]
        public string Id_type { get; set; }

        [Display(Name = "ID Number")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "ID number is required")]
        [RegularExpression("^[a-zA-Z0-9/-]*$", ErrorMessage = "No Special Character Allowed")]
        public string Id_No { get; set; }

        [Display(Name = "ID Issue date (AD)")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "ID Issue date (AD) is required")]
        public string Id_IssuedDateAD { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "ID Issue date (BS) is required")]
        [Display(Name = "ID Issue date (BS)")]
        public string Id_IssuedDateBS { get; set; }

        [Display(Name = "ID Issued Place")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "ID Issued Place is required")]
        public string Id_IssuedPlace { get; set; }

        [Display(Name = "ID expiry Date (AD)")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "ID Issue date (AD) is required")]
        public string Id_ExpiryDateAD { get; set; }

        [Display(Name = "ID expiry Date (BS)")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "ID Issue date (BS) is required")]
        public string Id_ExpiryDateBS { get; set; }

        [Display(Name = "ID Front Image")]
        public string Id_DocumentFront { get; set; }

        [Display(Name = "ID Back Image")]
        public string Id_DocumentBack { get; set; }

        [Display(Name = "Reject Remarks")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Rejected Remarks is required")]
        public string Remarks { get; set; }

        [Display(Name = "Created By")]
        public string CreatedBy { get; set; }

        [Display(Name = "Is same as permanent address : ")]
        public bool SameAsPermanentAddress { get; set; }

        //For List
        public List<SelectListItem> CountryList { get; set; }
        public List<SelectListItem> GenderList { get; set; }
        public List<SelectListItem> OccupationList { get; set; }
        public List<SelectListItem> MaritalStatusList { get; set; }
        public List<SelectListItem> RemarksList { get; set; }
        public List<SelectListItem> DocTypeList { get; set; }
        public List<SelectListItem> PProvinceList { get; set; }
        public List<SelectListItem> TProvinceList { get; set; }
        public List<SelectListItem> PDistrictList { get; set; }
        public List<SelectListItem> TDistrictList { get; set; }
        public List<SelectListItem> PMunicipalityList { get; set; }
        public List<SelectListItem> TMunicipalityList { get; set; }
        public List<SelectListItem> NationalityList { get; set; }
        public List<SelectListItem> Id_IssuedPlaceList { get; set; }
        public string OtherRemarks { get; set; }

    }
    public class KYCModelDetail
    {
        public string UserId { get; set; }
        public string AgentId { get; set; }
        public string ActionUser { get; set; }
        public string ActionIpAddress { get; set; }
        public string CreatedPlatform { get; set; }
        public string AgentType { get; set; }
        public string SubmittedDate { get; set; }
        public string Action { get; set; }
        public string KycStatus { get; set; }
        [Display(Name = "First Name")]
        public string FirstName { get; set; }
        [Display(Name = "Middle Name")]
        public string MiddleName { get; set; }
        [Display(Name = "Last Name")]
        public string LastName { get; set; }
        [Display(Name = "Full Name")]
        public string FullName { get; set; }
        [Display(Name = "Date of Birth (AD)")]
        public string DOB_Eng { get; set; }
        [Display(Name = "Date of Birth (BS)")]
        public string DOB_Nep { get; set; }
        public string Gender { get; set; }
        public string Occupation { get; set; }
        [Display(Name = "Marital Status")]
        public string MaritalStatus { get; set; }
        [Display(Name = "Spouse's Name")]
        public string SpouseName { get; set; }
        [Display(Name = "Father's Name")]
        public string FatherName { get; set; }
        [Display(Name = "Mother's Name")]
        public string MotherName { get; set; }
        [Display(Name = "Grand Father's Name")]
        public string GrandFatherName { get; set; }
        public string Nationality { get; set; }
        public string Country { get; set; }
        [Display(Name = "Permanent Province ")]
        public string PProvince { get; set; }
        [Display(Name = "Permanent District")]
        public string PDistrict { get; set; }
        [Display(Name = "Permanent VDC/Muncipality")]
        public string PLocalBody { get; set; }
        [Display(Name = "Permanent Ward No")]
        public string PWardNo { get; set; }
        [Display(Name = "Permanent Street")]
        public string PAddress { get; set; }

        [Display(Name = "Temporary Province ")]
        public string TProvince { get; set; }
        [Display(Name = "Temporary District")]
        public string TDistrict { get; set; }
        [Display(Name = "Temporary VDC/Muncipality")]
        public string TLocalBody { get; set; }
        [Display(Name = "Temporary Ward No")]
        public string TWardNo { get; set; }
        [Display(Name = "Temporary Street")]
        public string TAddress { get; set; }
        [Display(Name = "Phone Number")]
        public string PhoneNo { get; set; }
        [Display(Name = "Mobile Number")]
        public string MobileNo { get; set; }
        [Display(Name = "Email Address")]
        public string EmailAddress { get; set; }
        [Display(Name = "Profile Image")]
        public string PPImage { get; set; }
        public string UpdatedBy { get; set; }
        public string Updated_IP { get; set; }

        //THIS IS FOR KYC DOCUMENTS
        [Display(Name = "ID Type")]
        public string Id_type { get; set; }
        [Display(Name = "ID Number")]
        public string Id_No { get; set; }
        [Display(Name = "ID Issue date (AD)")]
        public string Id_IssuedDateAD { get; set; }
        [Display(Name = "ID Issue date (BS)")]
        public string Id_IssuedDateBS { get; set; }
        [Display(Name = "ID Issued Place")]
        public string Id_IssuedPlace { get; set; }
        [Display(Name = "ID expiry Date (AD)")]
        public string Id_ExpiryDateAD { get; set; }
        [Display(Name = "ID expiry Date (BS)")]
        public string Id_ExpiryDateBS { get; set; }
        [Display(Name = "ID Front Image")]
        public string Id_DocumentFront { get; set; }
        [Display(Name = "ID Back Image")]
        public string Id_DocumentBack { get; set; }
        [Display(Name = "Reject Remarks")]
        [Required(AllowEmptyStrings = false, ErrorMessage = "Rejected Remarks is required")]
        public string Remarks { get; set; }
        [Display(Name = "Created By")]
        public string CreatedBy { get; set; }
        [Display(Name = "Is same as permanent address : ")]
        public bool SameAsPermanentAddress { get; set; }
        //For List
        public List<SelectListItem> CountryList { get; set; }
        public List<SelectListItem> GenderList { get; set; }
        public List<SelectListItem> OccupationList { get; set; }
        public List<SelectListItem> MaritalStatusList { get; set; }
        public List<SelectListItem> RemarksList { get; set; }
        public List<SelectListItem> DocTypeList { get; set; }
        public List<SelectListItem> PProvinceList { get; set; }
        public List<SelectListItem> TProvinceList { get; set; }
        public List<SelectListItem> PDistrictList { get; set; }
        public List<SelectListItem> TDistrictList { get; set; }
        public List<SelectListItem> PMunicipalityList { get; set; }
        public List<SelectListItem> TMunicipalityList { get; set; }
        public List<SelectListItem> NationalityList { get; set; }
        public string OtherRemarks { get; set; }

    }
    public class KycFilterModel
    {
        [RegularExpression("^[9][0-9]*$", ErrorMessage = "Phone Number Start With 9")]
        [MaxLength(10, ErrorMessage = "Mobile Number Max Length is Invalid"), MinLength(10, ErrorMessage = "Mobile Number Minimum Length is Invalid")]
        [Display(Name = "Mobile Number")]
        public string MobileNumber { get; set; }
        [Display(Name = "Email Address")]
        [EmailAddress]
        public string Email { get; set; }
        [Display(Name = "Status")]
        public string KycStatus { get; set; }
        public List<SelectListItem> KycStatusList { get; set; }
        [Display(Name = "From Date")]
        public string FromDate { get; set; }
        [Display(Name = "To Date")]
        public string ToDate { get; set; }
    }
}