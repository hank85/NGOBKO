#!/bin/sh  
  
file_input=$1
file_output=$1.html
TM=`date +%Y%m%d_%H:%M:%S`
faith="日积月累，高不可攀!"
  
td_str=''
create_html_head(){
    echo -e "<html>
        <body>
            <h1>$faith $TM</h1>"
}
  
create_table_head(){  
    echo -e "<table border="1">"  
}  
  
create_td(){
#    if [ -e ./"$1" ]; then
        #!#echo $1
        td_str=`echo $1 | awk 'BEGIN{FS="|"}''{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'`
        #!#echo $td_str
#    fi
}

create_tr(){
    create_td "$1"
    echo -e "<tr>
        $td_str
    </tr>" 
}
  
create_table_end(){
    echo -e "</table>"
}
  
create_html_end(){
    echo -e "</body></html>"
}
create_html(){
    >$file_output

    create_html_head >> $file_output
    create_table_head >> $file_output
  
    while read line
    do
        #!#echo $line
		if [[ "$line" == *---* ]] 
		then
			create_table_end >> $file_output
			create_table_head >> $file_output
		else
			create_tr "$line">> $file_output
		fi
    done < $file_input

    create_table_end >> $file_output
    create_html_end >> $file_output
}

create_html
