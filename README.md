# Infrastructure As Code

Build status : [![Build Status](https://dev.azure.com/ygo74/iac/_apis/build/status/ygo74.iac?branchName=master)](https://dev.azure.com/ygo74/iac/_build/latest?definitionId=21&branchName=master)  


## Project structure

## Application Definitions

Application definition is defined at different levels :
=> Global Application
=> Environment

## Tools

## Manage Infrastructure version
file: infrastructure/version.yml
format:
  ```yaml
    ---
    # Format must be :
    # version: Major.Minor
    version: 1.0  
  ```

### Strategy
1. Update Major Version
   When: Global configuration changes which impact all applications
   How: Manual, Modify the file infrastructure/version.yml

2. Update Minor Version
   When: New application is added
   How: Manual, Modify the file infrastructure/version.yml

3. Update Patch Version
   When: Pull request is merged on master
   How: Bump patch version on the latest tag found for pattern Major.Minor

