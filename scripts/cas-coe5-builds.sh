curl -s http://10.47.161.207/builds/cas_coe5_dev/ | awk '
/<a href=.*\debug.bcsi"/ {
  file = $0;
  date = $0;
  gsub(/.*<a href="|\">.*/, "", file);
  gsub(/.*<\/a>\s*|\s*$/, "", date);
  print "http://10.47.161.207/builds/cas_coe5_dev/" file " " date;
}'
