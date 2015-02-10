library(dplyr)
fsann <- tbl_df(dget('fs.ann.R'))
fsann <- mutate(fsann,
    sta = ((CA_Y1-CA_Y2) - (CL_Y1-CL_Y2) - DEP_CF_Y1)/ASSETS_Y1,
    snoa = (STDEBT_Y1+LTDEBT_Y1+MINOR_Y1+PREF_Y1+EQUITY_Y1-CASH_Y1)/ASSETS_Y1,
    dsri = (AR_Y1/SALES_Y1)/(AR_Y2/SALES_Y2),
    gmi = (GROSS_Y2/SALES_Y2)/(GROSS_Y1/SALES_Y1),
    aqi = OLTA_Y1/ASSETS_Y1,
    sgi = SALES_Y1/SALES_Y2,
    depi = DEP_Y2/DEP_Y1,
    sga_y1 = TOTEXP_Y1-(CGS_Y1+RD_Y1+DEP_Y1+INT_Y1+UNINC_Y1),
    sga_y2 = TOTEXP_Y2-(CGS_Y2+RD_Y2+DEP_Y2+INT_Y2+UNINC_Y2),
    sgai = sga_y1/sga_y2,
    lvgi = (LIAB_Y1/ASSETS_Y1)/(LIAB_Y2/ASSETS_Y2),
    tata = (CA_Y1-CASH_Y1-CL_Y1)/(CA_Y2-CASH_Y2-CL_Y2),
    prom = -4.84+0.92*dsri+0.528*gmi+0.404*aqi+0.892*sgi+0.115*depi-0.172*sgai+4.679*tata-0.327*lvgi
)
fsqtr <- tbl_df(dget('fs.qtr.R'))
fsqtr <- mutate(fsqtr,

