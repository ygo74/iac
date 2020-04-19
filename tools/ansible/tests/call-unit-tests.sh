#!/bin/bash
export OUTPUT_PATH=../../../testresults


export JUNIT_OUTPUT_DIR=$OUTPUT_PATH/junitfiles
export JUNIT_TASK_CLASS=True
export JUNIT_TASK_RELATIVE_PATH=True


source ../../../ansible-2.9.6/bin/activate

# Generate inventory
cd ..
ansible-playbook -i localhost,k 00-generate-application-servers.yml \
                 -e application=application_specifications_v2 \
                 -e application_definition_path=../../specifications/application_specifications_v2.yml \
                 -e application_servers_path=../../testresults/inventory

cd tests
ansible-playbook -i $OUTPUT_PATH/inventory/dev 00-validate_iac_output.yml
ansible-playbook -i $OUTPUT_PATH/inventory/uat 00-validate_iac_output.yml

deactivate