#!/bin/bash

# per day salary
pay=500

echo "Enter User ID: "
read USER_ID

echo "Enter day (DD): "
read d

if [ "$d" == "7" ]; then
  # check user in users file
  user_found=0
  for row in $(cat data/users.csv); do
    id=$(echo $row | cut -d',' -f1)
    if [ "$id" == "$USER_ID" ]; then
      user_found=1
      user_role=$(echo $row | cut -d',' -f3)
    fi
  done

  if [ $user_found -eq 1 ]; then
    echo "Processing Salary..."
    
    file="data/attendance/$USER_ID.csv"
    if [ -f "$file" ]; then
      present=0
      absent=0
      
      for a in $(cat $file); do
        if [ "$a" == "Date,Status" ]; then
          # do nothing for header
          x=1
        else
          s=$(echo $a | cut -d',' -f2)
          if [ "$s" == "P" ]; then
            present=$(expr $present + 1)
          else
            if [ "$s" == "A" ]; then
              absent=$(expr $absent + 1)
            else
              # if anything else just ignore
              x=2
            fi
          fi
        fi
      done
      
      salary=$(expr $present \* $pay)
      
      m=$(date +%B)
      y=$(date +%Y)
      
      echo "$USER_ID,$m,$salary" >> data/salary.csv
      
      if [ -d "payslips" ]; then
        x=3
      else
        mkdir payslips
      fi
      
      slip="payslips/${USER_ID}_salary_${m}_${y}.txt"
      
      echo "---------------------------" > $slip
      echo "        PAYSLIP            " >> $slip
      echo "---------------------------" >> $slip
      echo "User ID      : $USER_ID" >> $slip
      echo "User Role    : $user_role" >> $slip
      echo "Present Days : $present" >> $slip
      echo "Absent Days  : $absent" >> $slip
      echo "Per Day Pay  : ₹500" >> $slip
      echo "Total Salary : ₹$salary" >> $slip
      echo "---------------------------" >> $slip
      
      echo ""
      echo "----- Payslip Preview -----"
      cat $slip
      echo "Done!"
    else
      echo "attendance file not found"
    fi
  else
    echo "user id is wrong"
  fi
else
  if [ "$d" != "7" ]; then
    echo "Salary can only be generated on 7th"
  fi
fi