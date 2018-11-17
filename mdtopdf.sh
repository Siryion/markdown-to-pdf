# $1 -> markdown file to be converted
# $2 -> result pdf file name 
# $3 -> markdown styling stylesheet (if empty default will be chosen)

# Get script full path
script_full_path=$(dirname "$0")
echo $script_full_path

# Create the markdown the html
tmp_html_file=${1%.md}'_tmp.html'
touch $tmp_html_file

# Add pre html
pre_html_part1='<html><head><meta charset="utf-8"><link rel="stylesheet" href="'
pre_html_part2='/styles/'
style='gitlab.css'

if [ -n "$3" ]
  then
    style=$3
fi

pre_html_part3='"></head><body>'
pre_html="$pre_html_part1$script_full_path$pre_html_part2$style$pre_html_part3"

echo $pre_html > $tmp_html_file

# Append markdown code to temporary html file
pandoc -f markdown -t html $1 -o md.html
cat md.html >> $tmp_html_file

# Append post html to temporary html file
post_html='</body></html>'
echo $post_html >> $tmp_html_file

# Convert html to PDF
wkhtmltopdf $tmp_html_file  $2

# Remove temporary files
rm $tmp_html_file
rm md.html