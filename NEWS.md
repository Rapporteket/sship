# sship 0.7.3

* messages from functions now explicit on their origin (sship) ([#25](https://github.com/Rapporteket/sship/pull/25))

# sship 0.7.2

* effort circumventing problem in older versions of R archiving single files using internal implementation of tar() ([#24](https://github.com/Rapporteket/sship/pull/24)) 

# sship 0.7.1

* fixed error making file archive on Solaris: now using R internal implementation of tar() ([#23](https://github.com/Rapporteket/sship/pull/23))

# sship 0.7.0

* adjustments and improvements for proper release ([#20](https://github.com/Rapporteket/sship/pull/20))
* fixed possible function tampering of users environment ([#21](https://github.com/Rapporteket/sship/pull/21))

# sship 0.6.0

* added option for encryption using a local public key ([#19](https://github.com/Rapporteket/sship/pull/19))

# sship 0.5.2

* fixed file path bug in file decryption ([#18](https://github.com/Rapporteket/sship/pull/18))

# sship 0.5.1

* move ci from travis to github actions
* eternal branch renamed to 'main'

# sship 0.5

* add simple use of pubkey from local file

# sship 0.4

* adding sftp as new shipment method with private/public key authentication

# sship 0.3

* adding function for making (ssh) key pairs 
* restructuring config focusing on recipient
* unit testing of decryption

# sship 0.2

* extending and correcting documentation
* server mode handling of (global) config
* adding logo

# sship 0.1

* Documentation (ambitions) and most of the bare bone functions
