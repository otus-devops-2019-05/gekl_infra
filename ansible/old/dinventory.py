#!/usr/bin/python
import os
import sys
import argparse
import re
import warnings
from google.cloud import storage
import json

#vars
gcp_bucket = 'infra-249015-tfstate-stage'
warnings.filterwarnings("ignore") # ignor gcp warnings

class Inventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        if self.args.list:
            self.inventory = self.ans_inventory()
            with open("inventory.json", "w") as data_file:
				json.dump(self.inventory, data_file, indent=4)

        elif self.args.host:
            self.inventory = self.empty_inventory()
        else:
            self.inventory = self.empty_inventory()

        print json.dumps(self.inventory);
       	
    def ans_inventory(self):
    	#read bucket
		client = storage.Client()
      		bucket = client.get_bucket(gcp_bucket)
                blob = bucket.get_blob('stage/default.tfstate')
		tfstate = blob.download_as_string()

		#print(tfstate)
		# deserialized json
		data = json.loads(tfstate)
		#print(data['modules'])

		tf_modules = data['modules']
		# print(tf_modules)

		group_app_hosts = []
		group_db_hosts = []
		

		for k in tf_modules:
			if k['resources']:
				for key,val in k['resources'].items():
					if re.match('google_compute_instance',key):
						#print(val['primary']['attributes'])
						if re.search('app',val['primary']['id']):
							group_app_hosts.append(val['primary']['attributes']['network_interface.0.access_config.0.nat_ip'])
						if re.search('db',val['primary']['id']):
							group_db_hosts.append(val['primary']['attributes']['network_interface.0.access_config.0.nat_ip'])
						

		inventory = {}
		if group_app_hosts:
			inventory['app'] = {}
			inventory['app']['hosts'] = group_app_hosts
		if group_db_hosts:
			inventory['db'] = {}
			inventory['db']['hosts'] = group_db_hosts
		inventory.update({'_meta':{'hostvars':{}}})
		#print inventory
		return inventory

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read args.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
Inventory()
