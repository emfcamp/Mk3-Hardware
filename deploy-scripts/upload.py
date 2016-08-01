import sys
import string
import textwrap
import math
import time
import random
import glob
import os
import json
import errno
import requests

def print_usage():
	print ("upload.py id.hex secret.hex key")
	print ("\r\n")
	print ("\r\n")
	print ("Files need to be in intel hex format. id.hex is 12 bytes from 0x1FFF7590, secret is 8 bytes from ???")


def get_id(file,bytes):
	out = ""
	with open(file) as f:
		f.readline()  #discard first line
		l = f.readline()
		
		if not (len(l) == (bytes*2+12)):
			print (l + "    " + str(len(l)))
			print_usage()
			quit()

		id = l[9:(bytes*2+12)-3]
			
		
		out = ""
		while len(id):
			out = id[:2] + out
			id = id[2:]
	return out
	

	
args = sys.argv[1:]

if not len(args) == 3:
	print_usage()
	quit()

	
	

print("ID file: " + args[0] + ",  Secret file: " + args[1])

id = get_id(args[0],12)
sec = get_id(args[1],8)

key = args[2]
url = "http://api.badge.emfcamp.org/api/admin/badge/add?key="

print(id)
print(sec)

try:
	r=requests.post(url + key,data={ "badge_id" : id, "secret" : sec })
except Exception as e:
	print(e)
	sys.exit(0)
	
res = json.loads(r.text)

print(r.text)

if "success" in res:
	if res["success"] == True:
		sys.exit(1)
	else:
		sys.exit(0)
else:
	sys.exit(0)

input("Press Enter to continue...")

