v0.2.18 (2016-03-18)
--------------------
- Upgrade Jenkins to 1.652
- Upgrade to Java 7
- In job_cleanup resources, whitelist is no longer name attribute
- Revert fix for TypeError: no implicit conversion of String into Array in job_cleanup provider
- Remove chef-rewind chef_gem resource and require
- Update to test cookbook for job_cleanup whitelist attribute change

v0.2.17 (2016-02-22)
-------------------
- Add test call for jr_jenkins_job_cleanup provider in fixture cookbook
- Fix for TypeError: no implicit conversion of String into Array in job_cleanup provider
- Fixed rubocop errors/warnings

v0.2.16 (2016-02-22)
-------------------
- Added initial JacksonRiver Jenkins CI mirror repo
- Updated support for latest Jenkins upstream cookbook version 2.4.x
- Fixed Travis CI support
- Updated integration testing
- Fixed rubocop, and food critic warnings and errors
