
// make sure you change to wherever the aux_cpi repo is stored in your machine
// In profile.do I set the global wb_dir in my computer for general use
global auxout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\GPWG\PIP_repo\
cd "${auxout}\aux_pfw\"
global dlw_dir "\\wbgfscifs01\GPWG-GMD\Datalib\GMD-DLW\Support\Support_2005_CPI\"

local pfwdirs: dir "${dlw_dir}" dirs "*CPI_*_M", respectcase
local pfwvins "0"
foreach pfwdir of local pfwdirs {
	if regexm("`pfwdir'", "CPI_[Vv]([0-9]+)_M") local pfwvin = regexs(1)
	local pfwvins "`pfwvins', `pfwvin'"
}
local pfwvin = max(`pfwvins')


if length("`pfwvin'") == 1 {
	local pfwvin = "0`pfwvin'"
}
	
disp "`pfwvin'"

use "${dlw_dir}/Support_2005_CPI_v`pfwvin'_M/Data/Stata/Survey_price_framework.dta", clear

gen pfw_id = "CPI_v`pfwvin'_M"
cap noi datasignature confirm using "pfw", strict
if (_rc) {
	datasignature set, reset saving("pfw", replace)
  export delimited  "pfw.csv" , replace
	save "pfw.dta" , replace
}


