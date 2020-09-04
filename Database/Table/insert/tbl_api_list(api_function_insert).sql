insert into tbl_Api_List
select 'CGMerchantPayment'
,      'CGMP'
,      'Make Payment Thrpugh Card'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1




insert into tbl_Api_List
select 'CGQRResponse'
,      'CGQR'
,      'Response after QR Scan'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'CGLoadFund'
,      'CGLF'
,      'Load Fund'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'RedirectToPayment'
,      'CGRDP'
,      'Get Redirection Url'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'CGLoadFund'
,      'CGLF'
,      'Load Fund'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'LoadFundReceipt'
,      'CGR'
,      'Load Fund Receipt'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'CGBankList'
,      'CGBL'
,      'Bank List'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1


--date 8/14

insert into tbl_Api_List
select 'ProvinceDropdown'
,      'PDD'
,      'Load Province Dropdown'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1


insert into tbl_Api_List
select 'GenderDropdown'
,      'GDD'
,      'Load Gender Dropdown'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'IdDropdown'
,      'IDD'
,      'Load Identification Dropdown'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'PurposeDropdown'
,      'PDD'
,      'Load Purpose Dropdown'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1


select * from tbl_Api_List  where function_Name like '%CG%'

update tbl_Api_List set function_Name = 'MerchantPayment' where ApiId = 5401
update tbl_Api_List set function_Name = 'QRResponse' where ApiId = 5501
update tbl_Api_List set function_Name = 'LoadFund' where ApiId = 5601
update tbl_Api_List set function_Name = 'BankList' where ApiId = 5801

select * from tbl_Api_List order by apiid desc

insert into tbl_Api_List
select 'AmountDenomination'
,      'AD'
,      'Amount Denomination'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'LandLinePayment'
,      'LP'
,      'LandLine Payment'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'NEABillPayment'
,      'EBP'
,      'Electricity Bill Payment'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'NEAOfficeList'
,      'NOL'
,      'NEA Office List'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'NEABIllEnquiry'
,      'NBE'
,      'NEA BIll Enquiry'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

--NEAServiceCharge

insert into tbl_Api_List
select 'NEAServiceCharge'
,      'NSC'
,      'NEA Service Charge'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'WaterOfficeList'
,      'NWSCOL'
,      'NWSC Office List'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

insert into tbl_Api_List
select 'WaterBillEnquiry'
,      'NWSCBE'
,      'NWSC Bill Enquiry'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1


insert into tbl_Api_List
select 'WaterBillPayment'
,      'NWSCBP'
,      'NWSC Water Bill Payment'
,      Status
,      Created_by
,      created_local_Date
,      created_UTC_date
,      created_nepali_date
,      updated_by
,      updated_local_Date
,      updated_UTC_Date
,      updated_nepali_date
from tbl_Api_List where ApiId = 1

Execute apiProc_Function_Check @function_name ='NEAServiceCharge'