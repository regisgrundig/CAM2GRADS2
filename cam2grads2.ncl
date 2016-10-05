;-------------------------------------------------------------
;
;   CAM 2 GRADS VESAO 2
;
;  esse script carrega os arquivos d saida do CAM 3.1
;  e cria um set de variaveis que pode ser aberto com 
; Grads versao 2+
; 
;  baseado no script ncl mpas_to_lat_lon.ncl 
;  By reginaldo ventura de sa (reginaldo.venturadesa@gmail.com) 
;
;
;  foi feito na versão 6.3 do ncl 
;
;
begin
;
;  busca todos os arquivos camrun*.nc 
;  alterar conforme a necessidade 
;  camrun é o nome default 
; 
files = systemfunc("ls camrun.*.nc")
cdf_file = addfiles(files,"r")
;
;  variaveis 3D 
;  esse set de varivaies somente tem as avriaveis
; abaixo; acrescente seguindo o exemplo
;
;
;   3D VARIABLES 
;
temp = cdf_file[:]->T              ; temperature
hgt    = cdf_file[:]->Z3               ; geopotential height
q   =    cdf_file[:]->Q 
u   =    cdf_file[:]->U 
v   =    cdf_file[:]->V
omega   =    cdf_file[:]->OMEGA
;
;  2D VARIABLES 
;  esse set de varivaies somente tem as avriaveis
; abaixo; acrescente seguindo o exemplo
;
;
lat  = cdf_file[0]->lat                      ; latitude
lon  = cdf_file[0]->lon                      ; longitude
pres = cdf_file[:]->PSL               ; pressure at mean sea level
ts   = cdf_file[:]->TS 
tsmx   = cdf_file[:]->TSMX 
tsmn   = cdf_file[:]->TSMN 
precc   = cdf_file[:]->PRECC 
precl   = cdf_file[:]->PRECL
flns   =  cdf_file[:]->FLNS
pblh   = cdf_file[:]->PBLH
lhflx   = cdf_file[:]->LHFLX

;
; para pegar as dimensoes. caso nao utilize o u coloque
; aqui outra avriavel 3D
;
dims=dimsizes(u)
nTime   = dims(0)
nLevels = dims(1) 
nLat    = dims(2)
nLon    = dims(3)
;
; cria novo arquivo netcdf
; o nome deverá constar no cam.ctl 
; se alterar o nome aqui devrá alterar la tambem
;
; o arquivo novo de netcdf tem que ser apagado 
; caso exista
;
lixo = systemfunc("rm cam2grads2_3d.nc") 
;
;  cria o arquivo novo netcdf
;
fout = addfile("cam2grads2_3d.nc","c")
dimNames = (/"Time", "lat" , "lon" , "levels"/)
dimSizes = (/-1    , nLat  , nLon  , nLevels /)
dimUnlim = (/True  , False , False , False   /)
;
; define as configuracoes do arquivo netcdf
;
filedimdef(fout,dimNames,dimSizes,dimUnlim)
;
;copy global atttibutes from the input to the output file:
;
fileattdef(fout,cdf_file[0])
;
;... predefine the dimensionality of the variables to be written out:
;
; se no inicio for incluir ou retirar variaveis estas
; devem refletir aqui nesse bloco
;
filevardef(fout,"latitude" ,typeof(lat)  ,(/"lat"/))
filevardef(fout,"longitude",typeof(lon)  ,(/"lon"/))
filevardef(fout,"u",typeof(u),(/"Time","levels","lat","lon"/))
filevardef(fout,"v",typeof(v),(/"Time","levels","lat","lon"/))
filevardef(fout,"temp",typeof(temp),(/"Time","levels","lat","lon"/))
filevardef(fout,"omega",typeof(omega),(/"Time","levels","lat","lon"/))
filevardef(fout,"hgt",typeof(hgt),(/"Time","levels","lat","lon"/))
filevardef(fout,"q",typeof(q),(/"Time","levels","lat","lon"/))
filevardef(fout,"pres",typeof(pres),(/"Time","lat","lon"/))
filevardef(fout,"ts",typeof(ts),(/"Time","lat","lon"/))
filevardef(fout,"tsmx",typeof(tsmx),(/"Time","lat","lon"/))
filevardef(fout,"tsmn",typeof(tsmn),(/"Time","lat","lon"/))
filevardef(fout,"precc",typeof(precc),(/"Time","lat","lon"/))
filevardef(fout,"precl",typeof(precl),(/"Time","lat","lon"/))
filevardef(fout,"flns",typeof(flns),(/"Time","lat","lon"/))
filevardef(fout,"pblh",typeof(pblh),(/"Time","lat","lon"/))
filevardef(fout,"lhflx",typeof(lhflx),(/"Time","lat","lon"/))
;
; as variaveis abaixo tem que estar na mesma
; sequencia do bloco anterior
;
fout->latitude  = (/lat/)
fout->longitude = (/lon/)
fout->u = (/u/)
fout->v = (/v/)
fout->temp = (/temp/)
fout->omega = (/omega/)
fout->hgt = (/hgt/)
fout->q = (/q/)
fout->pres = (/pres/)
fout->ts = (/ts/)
fout->tsmx = (/tsmx/)
fout->tsmn = (/tsmn/)
fout->precc = (/precc/)
fout->precl = (/precl/)
fout->flns = (/flns/)
fout->pblh = (/pblh/)
fout->lhflx = (/lhflx/)
print ("Have a nice day!")
end
