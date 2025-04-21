# Migrating Security Groups Between Clouds

This process is broken up into multiple parts - 
1) Download security group details from old zCompute cloud via UI Menu -> Security Groups -> Export Spreadsheet CSV
2) Take CSV and delete any security groups not being migrated from Column A
3) Create a blank Column B
4) Move security_group_ipv4_ingress_rules to Column C
5) Move security_group_ipv4_egress_rules to Column D
6) Run 1creating-securitygroups.sh from command line CN of new zCompute, using symp to create new Security Groups in new cloud
7) Run 2getting-securitygroup-ids.sh next, this gets all new IDs documented from the newly created Security Groups
8) (Work in Progress) Run final script to read Columns C and Column D to make Security Group rules based off Security Group IDs

## Usage
1. **Make sure you have correct permissions to do this from CN command line**
2. **Make sure all scripts are executable**:
   ```sh
   chmod +x
