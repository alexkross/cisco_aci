#!/usr/bin/gawk -f
# Cisco ACI configuration dump file names parser and sorter.
# Suitable for further processing by script that read this output as <infilename>\t<outfilename>,
# then process <infilename> with JSON butifier to update local git repository of human-readable configuration.
# Note: badly named *.json will be mapped into "config_000".

{
	l=split($0,p,"/")
	d=substr($0,1,match($0,"[^/]*$")-1) # including trailing "/"
	split(p[l],t,"T")
	split(t[2],e,".")
	split(e[1],n,"_")
	f[n[3],sprintf("%03d", strtonum(n[2]))]=d":"p[l] # ":" is not allowed in paths
}
END {
	for(j=1;j<=asorti(f,i);j++) {
		split(i[j],nc,SUBSEP)
		split(f[i[j]],df,":")
		print df[1]df[2]"\t"(nc[1]==""?"config":nc[1])"_"nc[2]
	}
}
