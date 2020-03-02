#!/bin/sh
RESULT="tmp.$$"
./gitlab.sh | grep -E 'physicaldrive' | grep -v "grep" > $RESULT

##################### set html #####################
echo "<meta http-equiv='refresh' content='5'>"
echo "<html>"
echo "<head></head>"
echo "<body>"
echo "<style>"
echo "div.divstyle{border: 1px solid black; float: left; width:10%; padding:10px;}"
echo "</style>"
echo "<div class='divstyle';>"
echo "gitlab-CI"
echo "<table border='1' width='100%;'>"
echo "<tbody>"
##################### set html #####################

##################### set table #####################
echo "<tr style='background: deepskyblue;'>"
echo "<td width='70px;'>디스크</td>"
echo "<td width='70px;'>상태</td>"
echo "</tr>"
##################### end table #####################
Status1=$(awk '{print $(NF -0)}' "$RESULT" | sed -n '1p' | cut -c 1,2)
Status2=$(awk '{print $(NF -0)}' "$RESULT" | sed -n '2p' | cut -c 1,2)
Status3=$(awk '{print $(NF -0)}' "$RESULT" | sed -n '3p' | cut -c 1,2)
Status4=$(awk '{print $(NF -0)}' "$RESULT" | sed -n '4p' | cut -c 1,2)
ID1=bay1
ID2=bay2
ID3=bay3
ID4=bay4
date_str=$(date '+%Y/%m/%d %H:%M:%S')
##################### loop start #####################

if [ "$Status1" = "OK" ]; then
        echo "<tr style='background: white; text-align: center;'>"
                echo "<td> $ID1 </td>"
                echo "<td style='background-color: mediumaquamarine;'> OK </td>"
        echo "</tr>"

else

        echo "<tr style='background: crimson; text-align: center;'>"
                echo "<td> $ID1 </td>"
                echo "<td style='background-color: crimson;'> Failed </td>"
        echo "</tr>"
fi

if [ "$Status2" = "OK" ]; then
        echo "<tr style='background: white; text-align: center;'>"
                echo "<td> $ID2 </td>"
                echo "<td style='background-color: mediumaquamarine;'> OK </td>"
        echo "</tr>"

else

        echo "<tr style='background: crimson; text-align: center;'>"
                echo "<td> $ID2 </td>"
                echo "<td style='background-color: crimson;'> Failed </td>"
        echo "</tr>"
fi

if [ "$Status3" = "OK" ]; then
        echo "<tr style='background: white; text-align: center;'>"
                echo "<td> $ID3 </td>"
                echo "<td style='background-color: mediumaquamarine;'> OK </td>"
        echo "</tr>"

else

        echo "<tr style='background: crimson; text-align: center;'>"
                echo "<td> $ID3 </td>"
                echo "<td style='background-color: crimson;'> Failed </td>"
        echo "</tr>"
fi

if [ "$Status4" = "OK" ]; then
        echo "<tr style='background: white; text-align: center;'>"
                echo "<td> $ID4 </td>"
                echo "<td style='background-color: mediumaquamarine;'> OK </td>"
        echo "</tr>"

else

        echo "<tr style='background: crimson; text-align: center;'>"
                echo "<td> $ID4 </td>"
                echo "<td style='background-color: crimson;'> Failed </td>"
        echo "</tr>"
fi
##################### loop end #####################
#done

##################### end html #####################
echo "</tbody>"
echo "</table>"
#echo "</div>"
echo "</body>"
echo "</html>"
##################### end html #####################
rm -f "$RESULT"
