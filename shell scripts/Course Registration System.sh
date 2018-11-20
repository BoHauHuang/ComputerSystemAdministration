#!/bin/sh
if [ -s data.json ];then  
	data=$(cat data.json)
else
	curl 'https://timetable.nctu.edu.tw/?r=main/get_cos_list' --data 'm_acy=107&m_sem=1&m_degree=3&m_dep_id=17&m_group=**&m_grade=**&m_option=**&m_class=**&m_crsname=**&m_teaname=**&m_cos_id=**&m_cos_code=**&m_crstime=**&m_crsoutline=**&m_costype=**' >> data.json

	data=$(cat data.json)
fi

	cat data.json > data.tmp

	sed -e 's/[{}]""//g' data.tmp >> split.tmp
	awk -F':' 'BEGIN{RS=","} match($1, /^"cos_ename"/){print $2}' split.tmp |
		sed -e 's/[ ]/./g' >> cosname.tmp

	
	grep -Eo "cos_time[:0-9A-Z, -\"][^m]+" split.tmp| 
		awk -F":" '{print $2}' |
		sed 's/"//g' |
		sed 's/,$//g' |
		sed 's/-$/-IDK/g' |
		sed 's/-/,/g' |
		awk -F"," '{print $1$3$5","$2$4$6}' >> costime.tmp
	#awk -F':' 'BEGIN{RS=","} match($1, /^"cos_time"/){print $2}' split.tmp |
		#sed -e 's/-/,/g' >> costime.tmp
	awk -F':' 'BEGIN{RS=","} match($1, /^"cos_id"/){print $2}' split.tmp |
       		sed -e 's/"//g' >> cosid.tmp

	paste -d "~" costime.tmp cosname.tmp |
		sed -e 's/"//g' >> timetable.tmp

	paste -d "~" cosid.tmp timetable.tmp >> allclass.tmp

	if [ -s class.tmp ];then 
		rm class.tmp
		sort -u allclass.tmp > class.tmp
	else
		sort -u allclass.tmp > class.tmp
	fi
	
	rm data.tmp
	rm timetable.tmp
	rm split.tmp
	rm allclass.tmp
	rm costime.tmp
	rm cosname.tmp
	rm cosid.tmp


OptionCheck(){
	if [ -e select.tmp ];then
		if [ -s select.tmp ];then
		for line in $(cat select.tmp)
		do
		       	grep ${line} class.tmp  >> optionchoose.tmp
		done
			if [ -e ctime.tmp ];then
				rm ctime.tmp
			fi
			if [ -e option.tmp ];then
				rm option.tmp
			fi
			uniq optionchoose.tmp > option.tmp
			awk -F"~" '{print $2}' option.tmp |
				awk -F"," '{print $1}' |
				grep -Eo "[0-9][A-Z]+" > classtime.tmp
			grep -xo '.\{3,3\}' classtime.tmp | 
				sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3/' >> ctime.tmp
			grep -xo '.\{4,4\}' classtime.tmp |
				sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3\1\4/' >> ctime.tmp
			grep -xo '.\{2,2\}' classtime.tmp >> ctime.tmp
			fold -w2 ctime.tmp | sort | uniq -d >> whichcollision.tmp

				if [ -s whichcollision.tmp ];then
					which=$(cat whichcollision.tmp)
					rm optionchoose.tmp
					rm whichcollision.tmp
					rm classtime.tmp
					rm ctime.tmp
					rm option.tmp
					dialog --title "!! Class Collision !!" \
						--msgbox "Collision:\n${which}" 50 60
					case $? in
						*) Addclass;;
					esac		
				else
					if [ -e whichcollision.tmp ];then
						rm whichcollision.tmp
					fi
					if [ -e myclass.history ];then
						rm myclass.history
					fi
					if [ -e option.tmp ];then
						rm option.tmp
					fi

					uniq optionchoose.tmp > myclass.history
					rm classtime.tmp
					rm optionchoose.tmp
					rm ctime.tmp
				fi
			else
				if [ -s myclass.history ];then
					rm myclass.history
				fi
				cat select.tmp > myclass.history
			fi
	fi
}

Addclass(){
	if [ -e myclass.history ]; then
		if [ -e selectedclass.tmp ];then
			rm selectedclass.tmp
			grep -f myclass.history class.tmp >> selectedclass.tmp
		else
			grep -f myclass.history class.tmp >> selectedclass.tmp
		fi

		if [ -e noselectedclass.tmp ];then
			rm noselectedclass.tmp
			grep -v -f myclass.history class.tmp >> noselectedclass.tmp
		else
			grep -v -f myclass.history class.tmp >> noselectedclass.tmp
		fi
		
		myclass=`awk -F"~" '{print $1, $2"~"$3, "on"}' selectedclass.tmp`
		notmyclass=`awk -F"~" '{print $1, $2"~"$3, "off"}' noselectedclass.tmp`
		rm selectedclass.tmp
		rm noselectedclass.tmp
		Comefrom=1
		dialog --title "Add class" \
			--extra-button --extra-label "Search" \
			--buildlist "" 90 80 60 \
			${myclass} ${notmyclass}  2>select.tmp

		case $? in
			0)OptionCheck;main;;
			3)SearchClass;;
			*)rm select.tmp;main;;
		esac
	else
		Comefrom=1
		myclass=`awk -F"~" '{print $1, $2"~"$3, "off"}' class.tmp`
		dialog --title "Add Class" \
			--extra-button --extra-label "Search" \
			--buildlist "" 90 80 60 \
			${myclass} 2>select.tmp
		case $? in
			0)OptionCheck;main;;
			3)SearchClass;;
			*)rm select.tmp;main;;
		esac
	fi
	}

SearchClass(){
	if [ -s myclass.history ]; then
		if [ -s selectedclass.tmp ];then
			rm selectedclass.tmp
			grep -f myclass.history class.tmp >> selectedclass.tmp
		else
			grep -f myclass.history class.tmp >> selectedclass.tmp
		fi
		if [ -s noselectedclass.tmp ];then
			rm noselectedclass.tmp
			grep -v -f myclass.history class.tmp >> noselectedclass.tmp
		else
			grep -v -f myclass.history class.tmp >> noselectedclass.tmp
		fi
	fi
	if [ -s selectedclass.tmp ];then
		selected=`awk -F"~" '{print $1, $2"~"$3, "on"}' selectedclass.tmp`
	fi

	dialog --title "Search Class" \
		--form "Enter the keyword:" \
		0 0 0 \
		"Keyword: " 1 1 "$classname" 1 10 30 0 2>search.data

	keyword=$(cat search.data)
	rm search.data
	if [ -s noselectedclass.tmp ];then
		fit=`grep -i ${keyword} noselectedclass.tmp | awk -F"~" '{print $1, $2"~"$3, "off"}'`
	else
		fit=`grep -i ${keyword} class.tmp | awk -F"~" '{print $1, $2"~"$3, "off"}'`
	fi
	
	if [ -s selectedclass.tmp ];then
		rm selectedclass.tmp
		rm noselectedclass.tmp
		dialog --title "Add Class" \
			--buildlist "" 90 80 60 \
			${fit} ${selected} 2>select.tmp
		case $? in
			0)OptionCheck;main;;
			*)rm select.tmp;main;;
		esac
	else
		dialog --title "Add Class" \
			--buildlist "" 90 80 60 \
			${fit} 2>select.tmp
		case $? in
			0)OptionCheck;main;;
			*)rm select.tmp;main;;
		esac
	fi
}


Option(){
	if [ -s option.history ]; then
		option=`awk '{
				if($1==1 && $2==2)
					print "1","ShowClassRoom", "on", "2", "HideExtraColumn", "on";
				else if($1==2)
				      print "1", "ShowClassRoom", "off", "2", "HideExtraColumn", "on";
				else if($1==1)
				      print "1", "ShowClassRoom", "on", "2", "HideExtraColumn", "off";
			      	else 
				      print "1", "ShowClassRoom", "off", "2", "HideExtraColumn", "off"
			      }' option.history`

		dialog --title "Option" \
			--extra-button --extra-label "FreeTimeClass" \
			--ok-label "Apply" \
			--checklist "" 90 80 30 \
			${option} 2>history.tmp

		case $? in
			0) cat history.tmp>option.history;
				rm history.tmp;
				main;;
			3) rm history.tmp;SelectFreeTimeClass;;
			*) rm history.tmp;main;;
		esac

	else
		dialog --title "Option" \
			--extra-button --extra-label "FreeTimeClass" \
			--ok-label "Apply" \
			--checklist "" 90 80 30 \
			"1" "Show ClassRoom" "off" \
		    "2" "Hide Extra Column" "off" 2>option.history
		case $? in
			0) main;;
			3) SelectFreeTimeClass;;
			*) main;;
		esac
	fi
}

SelectFreeTimeClass(){
	if [ -e myclass.history ];then
		
		awk -F"~" '{print $2}' myclass.history | 
			awk -F"," '{print $1}' |
			grep -Eo "[0-9][A-Z]+" > mychecktime.tmp

		grep -xo '.\{3,3\}' mychecktime.tmp | 
				sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3/' >> myclasstime.tmp
		grep -xo '.\{4,4\}' mychecktime.tmp |
				sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3\1\4/' >> myclasstime.tmp
		grep -xo '.\{2,2\}' mychecktime.tmp >> myclasstime.tmp

		fold -w2 myclasstime.tmp | sort | uniq > myclasstime.data
		
		rm mychecktime.tmp
		rm myclasstime.tmp

		for line in $(cat class.tmp)
		do
			id=`echo $line | awk -F"~" '{print $1}'`
			echo $line > line.tmp
			awk -F"~" '{print $2}' line.tmp | awk -F"," '{print $1}' | grep -Eo "[0-9][A-Z]+" > thisclassline.tmp
			grep -xo '.\{3,3\}' thisclassline.tmp | sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3/' >> thistime.tmp
			grep -xo '.\{4,4\}' thisclassline.tmp | sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3\1\4/' >> thistime.tmp
			grep -xo '.\{2,2\}' thisclassline.tmp >> thistime.tmp
			fold -w2 thistime.tmp | sort | uniq  > this.tmp

			grep -f myclasstime.data this.tmp > coll.tmp
			if [ -s coll.tmp ];then
				rm coll.tmp
			else
				echo $line >> notselectedfreeclass.tmp
			fi
			if [ -e coll.tmp ];then
				rm coll.tmp
			fi
			rm thistime.tmp
			rm this.tmp
			rm line.tmp
			rm thisclassline.tmp
		done

		rm myclasstime.data

		myclass=`awk -F"~" '{print $1,$2"~"$3, "on"}' myclass.history`
		notmyfreetimeclass=`awk -F"~" '{print $1, $2"~"$3, "off"}' notselectedfreeclass.tmp`
		if [ -e notselectedfreeclass.tmp ];then
			rm notselectedfreeclass.tmp
		fi
		dialog --title "Free Time Class" \
			--buildlist "" 90 80 60 \
			${myclass} ${notmyfreetimeclass}  2>select.tmp

		case $? in
			0)FreeOptionCheck;Option;;
			*)rm select.tmp;Option;;
		esac
	else
		myclass=`awk -F"~" '{print $1, $2"~"$3, "off"}' class.tmp`
		dialog --title "Add Class" \
			--buildlist "" 90 80 60 \
			${myclass} 2>select.tmp
		case $? in
			0)FreeOptionCheck;Option;;
			*)rm select.tmp;Option;;
		esac
	fi
}


FreeOptionCheck(){
	if [ -e select.tmp ];then
		if [ -s select.tmp ];then
		for line in $(cat select.tmp)
		do
		       	grep ${line} class.tmp  >> optionchoose.tmp
		done
			if [ -e ctime.tmp ];then
				rm ctime.tmp
			fi
			if [ -e option.tmp ];then
				rm option.tmp
			fi
			uniq optionchoose.tmp > option.tmp
			awk -F"~" '{print $2}' option.tmp |
				awk -F"," '{print $1}' |
				grep -Eo "[0-9][A-Z]+" > classtime.tmp
			grep -xo '.\{3,3\}' classtime.tmp | 
				sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3/' >> ctime.tmp
			grep -xo '.\{4,4\}' classtime.tmp |
				sed 's/\([0-9]\)\([A-Z]\)\([A-Z]\)\([A-Z]\)/\1\2\1\3\1\4/' >> ctime.tmp
			grep -xo '.\{2,2\}' classtime.tmp >> ctime.tmp
			fold -w2 ctime.tmp | sort | uniq -d >> whichcollision.tmp

				if [ -s whichcollision.tmp ];then
					which=$(cat whichcollision.tmp)
					rm optionchoose.tmp
					rm whichcollision.tmp
					rm classtime.tmp
					rm ctime.tmp
					rm option.tmp
								
					dialog --title "!! Class Collision !!" \
						--msgbox "Collision:\n${which}" 50 60
					case $? in
						*) SelectFreeTimeClass;;
					esac

				else
					if [ -e whichcollision.tmp ];then
						rm whichcollision.tmp
					fi
					if [ -e myclass.history ];then
						rm myclass.history
					fi
					if [ -e option.tmp ];then
						rm option.tmp
					fi

					uniq optionchoose.tmp > myclass.history
					rm classtime.tmp
					rm optionchoose.tmp
					rm ctime.tmp
				fi
			else
				if [ -s myclass.history ];then
					rm myclass.history
				fi
				cat select.tmp > myclass.history
			fi
	fi
}


main(){
	if [ -s myclass.history ]; then
		cat myclass.history |
			awk -F"~" '{print $2,$3}' |
			sed 's/,/ /g' |
			awk '{print $1, $3, $2}' > myclasslist.tmp

		if [ -e thisclasstime.tmp ];then
			rm thisclasstime.tmp
		fi
		if [ -e thisclass.tmp ];then
			rm thisclass.tmp
		fi

		awk '{split($1,arr,"");
			for(i=0;i<length(arr);i++){
				if(arr[i]~/^[0-9]/){day=arr[i]};
			if(arr[i]~/^[A-Za-z]/){print day arr[i]"~"$2"~"$3}}}' myclasslist.tmp > nowmyclass.tmp

		rm myclasslist.tmp

		Buildtable

		for line in $(cat nowmyclass.tmp)
		do
			time=`echo $line | awk -F"~" '{print $1}'`
			class=`echo $line | awk -F"~" '{print $2}'`
			room=`echo $line | awk -F"~" '{print $3}'`
			if [ -s option.history ];then
				showroom=`cat option.history | grep -Eo "1"`
				if [ -z $showroom ];then
					sed 's/'${time}'/'${class}'/g' timetable.data > temptable.tmp
				else
					sed 's/'${time}'/'${room}'/g' timetable.data > temptable.tmp
				fi
			else
				sed 's/'${time}'/'${class}'/g' timetable.data > temptable.tmp

				rm timetable.data
			fi
			if [ -s option.history ];then
					show=`cat option.history | grep -Eo "2"`
				if [ -z $show ];then

					awk '{print $1}' temptable.tmp >> time.data
					awk '{print $2}' temptable.tmp >> Mon.data
					awk '{print $3}' temptable.tmp >> Tue.data
					awk '{print $4}' temptable.tmp >> Wed.data
					awk '{print $5}' temptable.tmp >> Thr.data
					awk '{print $6}' temptable.tmp >> Fri.data
					awk '{print $7}' temptable.tmp >> Sat.data
					awk '{print $8}' temptable.tmp >> Sun.data
				
					paste -d " " time.data Mon.data Tue.data Wed.data Thr.data Fri.data Sat.data Sun.data | column -t > timetable.data
					rm temptable.tmp
					rm time.data
					rm Mon.data
					rm Tue.data
					rm Wed.data
					rm Thr.data
					rm Fri.data
					rm Sat.data
					rm Sun.data	
				else
					awk '{print $1}' temptable.tmp >> time.data
					awk '{print $2}' temptable.tmp >> Mon.data
					awk '{print $3}' temptable.tmp >> Tue.data
					awk '{print $4}' temptable.tmp >> Wed.data
					awk '{print $5}' temptable.tmp >> Thr.data
					awk '{print $6}' temptable.tmp >> Fri.data

					paste -d " " time.data Mon.data Tue.data Wed.data Thr.data Fri.data | column -t > timetable.data
					rm temptable.tmp
					rm time.data
					rm Mon.data
					rm Tue.data
					rm Wed.data
					rm Thr.data
					rm Fri.data
				fi
			else
				awk '{print $1}' temptable.tmp >> time.data
				awk '{print $2}' temptable.tmp >> Mon.data
				awk '{print $3}' temptable.tmp >> Tue.data
				awk '{print $4}' temptable.tmp >> Wed.data
				awk '{print $5}' temptable.tmp >> Thr.data
				awk '{print $6}' temptable.tmp >> Fri.data
				awk '{print $7}' temptable.tmp >> Sat.data
				awk '{print $8}' temptable.tmp >> Sun.data
				paste -d " " time.data Mon.data Tue.data Wed.data Thr.data Fri.data Sat.data Sun.data | column -t > timetable.data
				rm time.data
				rm Mon.data
				rm Tue.data
				rm Wed.data
				rm Thr.data
				rm Fri.data
				rm Sat.data
				rm Sun.data
				rm temptable.tmp
			fi
		done

		rm nowmyclass.tmp

		dialog --stdout --no-collapse --title "" \
			--help-button --help-label "Exit" \
			--extra-button --extra-label "Option" \
			--ok-label "Add Class" \
			--textbox timetable.data 60 100
		case $? in
			0) Addclass;;
			3) Option;;
			*) exit;;
		esac

	else
		Buildtable

		dialog --stdout --no-collapse --title "" \
			--help-button --help-label "Exit" \
       			--extra-button --extra-label "Option" \
			--ok-label "Add Class" \
			--textbox timetable.data 60 100

		case $? in
		 	0) Addclass;;
			3) Option;;
			*) exit;;
		esac
	fi
}
Buildtable(){
	if [ -s timetable.data ]; then
	rm timetable.data
	fi

	if [ -s option.history ];then
		show=`cat option.history | grep -Eo "2"`
		if [ -z $show ];then
			space="=========="
			printf "...\n M\n =\n N\n =\n A\n =\n B\n =\n C\n =\n D\n =\n X\n =\n E\n =\n F\n =\n G\n =\n H\n =\n Y\n =\n I\n =\n J\n =\n K" >> time.data
			printf ".Mon \n|1M\n${space}\n|1N\n${space}\n|1A\n${space}\n|1B\n${space}\n|1C\n${space}\n|1D\n${space}\n|1X\n${space}\n|1E\n${space}\n|1F\n${space}\n|1G\n${space}\n|1H\n${space}\n|1Y\n${space}\n|1I\n${space}\n|1J\n${space}\n|1K\n\n\n\n\n" >> Mon.data
			printf ".Tue \n|2M\n${space}\n|2N\n${space}\n|2A\n${space}\n|2B\n${space}\n|2C\n${space}\n|2D\n${space}\n|2X\n${space}\n|2E\n${space}\n|2F\n${space}\n|2G\n${space}\n|2H\n${space}\n|2Y\n${space}\n|2I\n${space}\n|2J\n${space}\n|2K\n\n\n\n\n" >> Tue.data
			printf ".Wed \n|3M\n${space}\n|3N\n${space}\n|3A\n${space}\n|3B\n${space}\n|3C\n${space}\n|3D\n${space}\n|3X\n${space}\n|3E\n${space}\n|3F\n${space}\n|3G\n${space}\n|3H\n${space}\n|3Y\n${space}\n|3I\n${space}\n|3J\n${space}\n|3K\n\n\n\n\n" >> Wed.data
			printf ".Thr \n|4M\n${space}\n|4N\n${space}\n|4A\n${space}\n|4B\n${space}\n|4C\n${space}\n|4D\n${space}\n|4X\n${space}\n|4E\n${space}\n|4F\n${space}\n|4G\n${space}\n|4H\n${space}\n|4Y\n${space}\n|4I\n${space}\n|4J\n${space}\n|4K\n\n\n\n\n" >> Thr.data
			printf ".Fri \n|5M\n${space}\n|5N\n${space}\n|5A\n${space}\n|5B\n${space}\n|5C\n${space}\n|5D\n${space}\n|5X\n${space}\n|5E\n${space}\n|5F\n${space}\n|5G\n${space}\n|5H\n${space}\n|5Y\n${space}\n|5I\n${space}\n|5J\n${space}\n|5K\n\n\n\n\n" >> Fri.data
			printf ".Sat \n|6M\n${space}\n|6N\n${space}\n|6A\n${space}\n|6B\n${space}\n|6C\n${space}\n|6D\n${space}\n|6X\n${space}\n|6E\n${space}\n|6F\n${space}\n|6G\n${space}\n|6H\n${space}\n|6Y\n${space}\n|6I\n${space}\n|6J\n${space}\n|6K\n\n\n\n\n" >> Sat.data
			printf ".Sun \n|7M\n${space}\n|7N\n${space}\n|7A\n${space}\n|7B\n${space}\n|7C\n${space}\n|7D\n${space}\n|7X\n${space}\n|7E\n${space}\n|7F\n${space}\n|7G\n${space}\n|7H\n${space}\n|7Y\n${space}\n|7I\n${space}\n|7J\n${space}\n|7K\n\n\n\n\n" >> Sun.data
			paste -d " " time.data Mon.data Tue.data Wed.data Thr.data Fri.data Sat.data Sun.data | column -t > timetable.data
			rm time.data
			rm Mon.data
			rm Tue.data
			rm Wed.data
			rm Thr.data
			rm Fri.data
			rm Sat.data
			rm Sun.data
				
		else 
			space="=========="
			printf "...\n A\n =\n B\n =\n C\n =\n D\n =\n E\n =\n F\n =\n G\n =\n H\n =\n I\n =\n J\n =\n K" >> time.data
			printf ".Mon \n|1A\n${space}\n|1B\n${space}\n|1C\n${space}\n|1D\n${space}\n|1E\n${space}\n|1F\n${space}\n|1G\n${space}\n|1H\n${space}\n|1I\n${space}\n|1J\n${space}\n|1K\n\n\n\n\n" >> Mon.data
			printf ".Tue \n|2A\n${space}\n|2B\n${space}\n|2C\n${space}\n|2D\n${space}\n|2E\n${space}\n|2F\n${space}\n|2G\n${space}\n|2H\n${space}\n|2I\n${space}\n|2J\n${space}\n|2K\n\n\n\n\n" >> Tue.data
			printf ".Wed \n|3A\n${space}\n|3B\n${space}\n|3C\n${space}\n|3D\n${space}\n|3E\n${space}\n|3F\n${space}\n|3G\n${space}\n|3H\n${space}\n|3I\n${space}\n|3J\n${space}\n|3K\n\n\n\n\n" >> Wed.data
			printf ".Thr \n|4A\n${space}\n|4B\n${space}\n|4C\n${space}\n|4D\n${space}\n|4E\n${space}\n|4F\n${space}\n|4G\n${space}\n|4H\n${space}\n|4I\n${space}\n|4J\n${space}\n|4K\n\n\n\n\n" >> Thr.data
			printf ".Fri \n|5A\n${space}\n|5B\n${space}\n|5C\n${space}\n|5D\n${space}\n|5E\n${space}\n|5F\n${space}\n|5G\n${space}\n|5H\n${space}\n|5I\n${space}\n|5J\n${space}\n|5K\n\n\n\n\n" >> Fri.data
			paste -d " " time.data Mon.data Tue.data Wed.data Thr.data Fri.data | column -t > timetable.data	
			rm time.data
			rm Mon.data
			rm Tue.data
			rm Wed.data
			rm Thr.data
			rm Fri.data

		fi
	else
		space="=========="
		printf "...\n M\n =\n N\n =\n A\n =\n B\n =\n C\n =\n D\n =\n X\n =\n E\n =\n F\n =\n G\n =\n H\n =\n Y\n =\n I\n =\n J\n =\n K" >> time.data
		printf ".Mon \n|1M\n${space}\n|1N\n${space}\n|1A\n${space}\n|1B\n${space}\n|1C\n${space}\n|1D\n${space}\n|1X\n${space}\n|1E\n${space}\n|1F\n${space}\n|1G\n${space}\n|1H\n${space}\n|1Y\n${space}\n|1I\n${space}\n|1J\n${space}\n|1K\n\n\n\n\n" >> Mon.data
		printf ".Tue \n|2M\n${space}\n|2N\n${space}\n|2A\n${space}\n|2B\n${space}\n|2C\n${space}\n|2D\n${space}\n|2X\n${space}\n|2E\n${space}\n|2F\n${space}\n|2G\n${space}\n|2H\n${space}\n|2Y\n${space}\n|2I\n${space}\n|2J\n${space}\n|2K\n\n\n\n\n" >> Tue.data
		printf ".Wed \n|3M\n${space}\n|3N\n${space}\n|3A\n${space}\n|3B\n${space}\n|3C\n${space}\n|3D\n${space}\n|3X\n${space}\n|3E\n${space}\n|3F\n${space}\n|3G\n${space}\n|3H\n${space}\n|3Y\n${space}\n|3I\n${space}\n|3J\n${space}\n|3K\n\n\n\n\n" >> Wed.data
		printf ".Thr \n|4M\n${space}\n|4N\n${space}\n|4A\n${space}\n|4B\n${space}\n|4C\n${space}\n|4D\n${space}\n|4X\n${space}\n|4E\n${space}\n|4F\n${space}\n|4G\n${space}\n|4H\n${space}\n|4Y\n${space}\n|4I\n${space}\n|4J\n${space}\n|4K\n\n\n\n\n" >> Thr.data
		printf ".Fri \n|5M\n${space}\n|5N\n${space}\n|5A\n${space}\n|5B\n${space}\n|5C\n${space}\n|5D\n${space}\n|5X\n${space}\n|5E\n${space}\n|5F\n${space}\n|5G\n${space}\n|5H\n${space}\n|5Y\n${space}\n|5I\n${space}\n|5J\n${space}\n|5K\n\n\n\n\n" >> Fri.data
		printf ".Sat \n|6M\n${space}\n|6N\n${space}\n|6A\n${space}\n|6B\n${space}\n|6C\n${space}\n|6D\n${space}\n|6X\n${space}\n|6E\n${space}\n|6F\n${space}\n|6G\n${space}\n|6H\n${space}\n|6Y\n${space}\n|6I\n${space}\n|6J\n${space}\n|6K\n\n\n\n\n" >> Sat.data
		printf ".Sun \n|7M\n${space}\n|7N\n${space}\n|7A\n${space}\n|7B\n${space}\n|7C\n${space}\n|7D\n${space}\n|7X\n${space}\n|7E\n${space}\n|7F\n${space}\n|7G\n${space}\n|7H\n${space}\n|7Y\n${space}\n|7I\n${space}\n|7J\n${space}\n|7K\n\n\n\n\n" >> Sun.data
		paste -d " " time.data Mon.data Tue.data Wed.data Thr.data Fri.data Sat.data Sun.data | column -t > timetable.data
		rm time.data
		rm Mon.data
		rm Tue.data
		rm Wed.data
		rm Thr.data
		rm Fri.data
		rm Sat.data
		rm Sun.data
	fi

	
}

main
