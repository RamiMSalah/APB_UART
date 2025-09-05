var setupInfo = { "setupInfo" : [
{ "HOME_0IN" : "C:/QFT_2021.1/QFT_2021.1/QFT/V2021.1/win64" },{ "QHOME" : "C:/QFT_2021.1/QFT_2021.1/QFT/V2021.1/win64" },{ "ZSH" : "" },{ "ZI_RTLD_LIB" : "" }]};
var category = { "category" : [
{ "categoryId" : "0" , "categoryName":"Rtl Design Style" },
{ "categoryId" : "1" , "categoryName":"Simulation" },
{ "categoryId" : "2" , "categoryName":"Synthesis" },
{ "categoryId" : "3" , "categoryName":"Connectivity" },
{ "categoryId" : "4" , "categoryName":"Reset" },
{ "categoryId" : "5" , "categoryName":"Clock" },
{ "categoryId" : "6" , "categoryName":"Testbench" },
{ "categoryId" : "7" , "categoryName":"Nomenclature Style" },
{ "categoryId" : "8" , "categoryName":"Setup Checks" }]};
var severity = { "severity" : [
{ "severityId" : "0" , "severityName":"Error" },
{ "severityId" : "1" , "severityName":"Warning" },
{ "severityId" : "2" , "severityName":"Info" }]};
var statusObj = { "status" : [
{ "statusId" : "0" , "statusName":"uninspected" },
{ "statusId" : "1" , "statusName":"pending" },
{ "statusId" : "2" , "statusName":"waived" },
{ "statusId" : "3" , "statusName":"bug" },
{ "statusId" : "4" , "statusName":"fixed" },
{ "statusId" : "5" , "statusName":"verified" }]} ;
var checks = { "checks":[
{ "checksId":"0", "checksName":"assign_width_overflow","severityId":"2","categoryId":"0"},
{ "checksId":"1", "checksName":"always_signal_assign_large","severityId":"2","categoryId":"0"},
{ "checksId":"2", "checksName":"seq_block_has_duplicate_assign","severityId":"1","categoryId":"0"},
{ "checksId":"3", "checksName":" ","severityId":"3","categoryId":"9"}]};
var schematicStatus = {  
"assign_width_overflow" : "off",
"always_signal_assign_large" : "off",
"seq_block_has_duplicate_assign" : "off"};
var adaptiveModeStatus = {  
"assign_width_overflow" : "off",
"always_signal_assign_large" : "off",
"seq_block_has_duplicate_assign" : "off"};
var checkAliasMap = { };
var argMap = {  
"1":"lhs_expression",
"2":"lhs_width",
"3":"rhs_width",
"4":"module",
"5":"file",
"6":"line",
"7":"count",
"8":"limit",
"9":"signal",
"10":"line1",
"11":"line2"};
