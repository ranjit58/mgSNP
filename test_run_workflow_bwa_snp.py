#!/usr/bin/python
from distutils import spawn 
# A worklow to go from bwa alignment to SNP calling 

__author__ = 'Ranjit Kumar (ranjit58@gmail.com)' 


# ENV variable (can be read from the config files later)


def checkPrerequisite( *dependencies ):
	print "Checking for dependencies"

	for software in dependencies:
		software_path = spawn.find_executable(software)
		#print software_path
		if software_path :
			print "Checking for", software, ":" ,"Found -->", software_path
		else:
			print "Checking for", software, ":", "Not found."

	#print "Please install the missing packages."

	return;



def main():
	checkPrerequisite("bwa","GATK","parallel","php")



if __name__ == '__main__':
	main()






	
