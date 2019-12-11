#!/bin/sh

#
# Generated on Wed Nov 27 14:12:05 CST 2019
# Start of user configurable variables
#
LANG=C
export LANG

#Trap to cleanup cookie file in case of unexpected exits.
trap 'rm -f $COOKIE_FILE; exit 1' 1 2 3 6 

# SSO username 
printf 'SSO User Name:' 
read SSO_USERNAME

# Path to wget command
WGET=/usr/bin/wget

# Log directory and file
LOGDIR=.
LOGFILE=$LOGDIR/wgetlog-$(date +%m-%d-%y-%H:%M).log

# Print wget version info 
echo "Wget version info: 
------------------------------
$($WGET -V) 
------------------------------" > "$LOGFILE" 2>&1 

# Location of cookie file 
COOKIE_FILE=$(mktemp -t wget_sh_XXXXXX) >> "$LOGFILE" 2>&1 
if [ $? -ne 0 ] || [ -z "$COOKIE_FILE" ] 
then 
 echo "Temporary cookie file creation failed. See $LOGFILE for more details." |  tee -a "$LOGFILE" 
 exit 1 
fi 
echo "Created temporary cookie file $COOKIE_FILE" >> "$LOGFILE" 

# Output directory and file
OUTPUT_DIR=.
#
# End of user configurable variable
#

# The following command to authenticate uses HTTPS. This will work only if the wget in the environment
# where this script will be executed was compiled with OpenSSL.
# 
 $WGET  --secure-protocol=auto --save-cookies="$COOKIE_FILE" --keep-session-cookies --http-user "$SSO_USERNAME" --ask-password  "https://edelivery.oracle.com/osdc/cliauth" -O /dev/null 2>> "$LOGFILE"

# Verify if authentication is successful 
if [ $? -ne 0 ] 
then 
 echo "Authentication failed with the given credentials." | tee -a "$LOGFILE"
 echo "Please check logfile: $LOGFILE for more details." 
else
 echo "Authentication is successful. Proceeding with downloads..." >> "$LOGFILE" 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983411-01.zip&token=S1k3L2hhL1RYSWJFVnRqRVc0R3ZZZyE6OiFmaWxlSWQ9MTA1ODAwNDE5JmZpbGVTZXRDaWQ9OTEyMTU5JnJlbGVhc2VDaWRzPTg0Nzc3NyZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYxJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQ" -O "$OUTPUT_DIR/V983411-01.zip" >> "$LOGFILE" 2>&1 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983412-01_1of2.zip&token=aS9VbVNsZEJOUk01N05HNWJ3blA4USE6OiFmaWxlSWQ9MTA1ODAwNDEyJmZpbGVTZXRDaWQ9OTEyMTIzJnJlbGVhc2VDaWRzPTg0Nzc3NyZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYxJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQ" -O "$OUTPUT_DIR/V983412-01_1of2.zip" >> "$LOGFILE" 2>&1 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983412-01_2of2.zip&token=d09hSU9rVW5VMllmaE1PVGtsRkxnUSE6OiFmaWxlSWQ9MTA1ODAwNDEzJmZpbGVTZXRDaWQ9OTEyMTIzJnJlbGVhc2VDaWRzPTg0Nzc3NyZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYxJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQ" -O "$OUTPUT_DIR/V983412-01_2of2.zip" >> "$LOGFILE" 2>&1 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983383-01.zip&token=NXE4M1ZQdUFVa0tuVDJWVi9UM25ZUSE6OiFmaWxlSWQ9MTA1ODAwMzc4JmZpbGVTZXRDaWQ9OTEyMTQxJnJlbGVhc2VDaWRzPTg0Nzc4MiZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQmZGxwQ2lkcz05MTQ1MjM" -O "$OUTPUT_DIR/V983383-01.zip" >> "$LOGFILE" 2>&1 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983385-01_1of2.zip&token=dDRzTkFCT1dmbnh3VCsrbkZkdDQ2USE6OiFmaWxlSWQ9MTA1ODAwMzgxJmZpbGVTZXRDaWQ9OTEyMTQ3JnJlbGVhc2VDaWRzPTg0Nzc4MiZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQmZGxwQ2lkcz05MTQ1MjM" -O "$OUTPUT_DIR/V983385-01_1of2.zip" >> "$LOGFILE" 2>&1 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983385-01_2of2.zip&token=NkgrVUZoQkEyTGxGVGVoblNWdmhNUSE6OiFmaWxlSWQ9MTA1ODAwMzgwJmZpbGVTZXRDaWQ9OTEyMTQ3JnJlbGVhc2VDaWRzPTg0Nzc4MiZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQmZGxwQ2lkcz05MTQ1MjM" -O "$OUTPUT_DIR/V983385-01_2of2.zip" >> "$LOGFILE" 2>&1 
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983386-01_1of2.zip&token=eGg1c0kzLzZ6Z3pwWkx0c2FVUWdWdyE6OiFmaWxlSWQ9MTA1ODAwMjkwJmZpbGVTZXRDaWQ9OTEyMTQ4JnJlbGVhc2VDaWRzPTg0Nzc4MiZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQmZGxwQ2lkcz05MTQ1MjM" -O "$OUTPUT_DIR/V983386-01_1of2.zip" >> "$LOGFILE" 2>&1 
 $WGET --load-cookies="$COOKIE_FILE" "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983386-01_2of2.zip&token=WDQ3LytySmFXYzU3N1NaUWcrZ09odyE6OiFmaWxlSWQ9MTA1ODAwMjkxJmZpbGVTZXRDaWQ9OTEyMTQ4JnJlbGVhc2VDaWRzPTg0Nzc4MiZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTYxMTMyNjAmZW1haWxBZGRyZXNzPWFsZXhhbmRlci52YXNpbGVua29Ac3Bhci1pY3MuY29tJnVzZXJOYW1lPUVQRC1BTEVYQU5ERVIuVkFTSUxFTktPQFNQQVItSUNTLkNPTSZpcEFkZHJlc3M9MmEwMjo4Mzg4OmI4MDo3NTAwOjcwNDQ6M2ZmNDo0MjVmOjIxMGImdXNlckFnZW50PU1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS83OC4wLjM5MDQuMTA4IFNhZmFyaS81MzcuMzYmY291bnRyeUNvZGU9QVQmZGxwQ2lkcz05MTQ1MjM" -O "$OUTPUT_DIR/V983386-01_2of2.zip" >> "$LOGFILE" 2>&1 
fi 

# Cleanup
rm -f "$COOKIE_FILE" 
echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE" 

