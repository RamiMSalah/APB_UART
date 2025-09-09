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
{ "checksId":"0", "checksName":"assign_width_overflow","severityId":"0","categoryId":"0"},
{ "checksId":"1", "checksName":"bus_bits_not_read","severityId":"1","categoryId":"0"},
{ "checksId":"2", "checksName":"empty_block","severityId":"0","categoryId":"0"},
{ "checksId":"3", "checksName":"unloaded_input_port","severityId":"2","categoryId":"3"},
{ "checksId":"4", "checksName":"if_else_if_can_be_case","severityId":"2","categoryId":"0"},
{ "checksId":"5", "checksName":"reserved_keyword","severityId":"2","categoryId":"7"},
{ "checksId":"6", "checksName":"multi_driven_signal","severityId":"0","categoryId":"1"},
{ "checksId":"7", "checksName":"always_has_inconsistent_async_control","severityId":"1","categoryId":"4"},
{ "checksId":"8", "checksName":"fsm_without_one_hot_encoding","severityId":"2","categoryId":"0"},
{ "checksId":"9", "checksName":"always_signal_assign_large","severityId":"1","categoryId":"0"},
{ "checksId":"10", "checksName":"parameter_name_duplicate","severityId":"2","categoryId":"7"},
{ "checksId":"11", "checksName":"comment_not_in_english","severityId":"2","categoryId":"7"},
{ "checksId":"12", "checksName":" ","severityId":"3","categoryId":"9"}]};
var schematicStatus = {  
"assign_width_overflow" : "off",
"bus_bits_not_read" : "on",
"empty_block" : "off",
"unloaded_input_port" : "on",
"if_else_if_can_be_case" : "off",
"reserved_keyword" : "off",
"multi_driven_signal" : "on",
"always_has_inconsistent_async_control" : "off",
"fsm_without_one_hot_encoding" : "off",
"always_signal_assign_large" : "off",
"parameter_name_duplicate" : "off",
"comment_not_in_english" : "off"};
var adaptiveModeStatus = {  
"assign_width_overflow" : "off",
"bus_bits_not_read" : "off",
"empty_block" : "off",
"unloaded_input_port" : "on",
"if_else_if_can_be_case" : "off",
"reserved_keyword" : "off",
"multi_driven_signal" : "off",
"always_has_inconsistent_async_control" : "off",
"fsm_without_one_hot_encoding" : "off",
"always_signal_assign_large" : "off",
"parameter_name_duplicate" : "on",
"comment_not_in_english" : "off"};
var checkAliasMap = { };
var argMap = {  
"1":"lhs_expression",
"2":"lhs_width",
"3":"rhs_width",
"4":"module",
"5":"file",
"6":"line",
"7":"bits",
"8":"port",
"9":"name",
"10":"reason",
"11":"signal",
"12":"flop1",
"13":"line1",
"14":"flop2",
"15":"line2",
"16":"count",
"17":"limit",
"18":"parameter",
"19":"module1",
"20":"file1",
"21":"module2",
"22":"file2"};
