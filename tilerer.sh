#!/bin/bash  
declare -a arr=(ATG DZA AZE ALB ARM AGO ASM ARG AUS BHR BRB BMU BHS BGD BLZ BIH BOL MMR BEN SLB BRA BGR BRN CAN KHM LKA COG COD BDI CHN AFG BTN CHL CYM CMR TCD COM COL CRI CAF CUB CPV COK CYP DNK DJI DMA DOM ECU EGY IRL GNQ EST ERI SLV ETH AUT CZE GUF FIN FJI FLK FSM PYF FRA GMB GAB GEO GHA GRD GRL DEU GUM GRC GTM GIN GUY HTI HND HRV HUN ISL IND IRN ISR ITA CIV IRQ JPN JAM JOR KEN KGZ PRK KIR KOR KWT KAZ LAO LBN LVA BLR LTU LBR SVK LIE LBY MDG MTQ MNG MSR MKD MLI MAR MUS MRT MLT OMN MDV MEX MYS MOZ MWI NCL NIU NER ABW AIA BEL HKG MNP FRO AND GIB IMN LUX MAC MCO PSE MNE MYT ALA NFK CCK ATA BVT ATF HMD IOT CXR UMI VUT NGA NLD NOR NPL NRU SUR NIC NZL PRY PER PAK POL PAN PRT PNG GNB QAT REU ROU MDA PHL PRI RUS RWA SAU KNA SYC ZAF LSO BWA SEN SVN SLE SGP SOM ESP LCA SDN SWE SYR CHE TTO THA TJK TKL TON TGO STP TUN TUR TUV TKM TZA UGA GBR UKR USA BFA URY UZB VCT VEN VGB VNM VIR NAM WLF WSM SWZ YEM ZMB ZWE IDN GLP ANT ARE TLS PCN PLW MHL SPM SHN SMR TCA ESH SRB VAT SJM MAF BLM GGY JEY SGS TWN)

## cut by country
for iso3 in "${arr[@]}"
do
  echo "$iso3"
  aux='ISO3="'$iso3'"'
  gdalwarp -cwhere $aux -cutline TM_WORLD_BORDERS-0.3.shp -srcnodata '0' -crop_to_cutline F182013.v4c_web.stable_lights.avg_vis.tif $iso3.tif
done

## generate sql
for iso3 in "${arr[@]}"
do
  echo "$iso3"
  raster2pgsql $iso3.tif > $iso3.tif.sql
done

## insert postgis
for iso3 in "${arr[@]}"
do
  echo "$iso3"
  psql -d spatialdb -f $iso3.tif.sql
done

## done ## Investigar como interpretar los datos en la bd
## Iterar por las tablas y hacer un (avg luz por pais)/area
## mostrar los datos