
ERC20 Regulated Token 
=====================
This project aims to develop an ERC20 token that can be transferred only to approved users.
The approval must be granted by the token issuer by adding addresses to an approved list. 
The token issuer in this way can add addresses that undergo and pass the KYC/AML policies typically used in banking environments.

Additional and futures development might include but not limited to the following:

* Multiple allowed users lists/policies
* Transfer allowed in case of similar policies
* Governance mechanism

Description
=====================
This type of token should be useful for banks that want to join the ETH echosystem without compromises
toward regulators policies including KYC and AML.

A typical use case is the issuance of a token by a bank to one of its clients. The client went through
a KYC/AML procedure. Once the client receives the token, that for example can be a financial structured product
then he/she become the sole custodian of this asset, because it will be stored in his/her wallet.

This self-custody capability opens up the doors to a whole set of new scenarios, including the possibility for a client 
to transfer the asset ownership to someone else that might be under veto from the same bank because resident in a veto 
country like North Korea.

A simple solution could be to leave empty the implementation of the ERC20 transfer functions, apart for example the possibility
to transfer the asset back to the issuer in order to redeem the underlying asset (e.g. gold tokenization).
Despite this works, clearly doesn't make the token very useful because clients that own is and want to adopt the self custody method 
cannot trade it. 

The solution we adopt is to link the token to a list of allowed user adresses, added by the bank according to their KYC/AML policies. 
In this way a client can trade with other bank clients. The protocol can be furtherly improved by allowing banks with similar KYC/AML
policies to add allowed addresses to the same list.
In this way the potential market available to the clients can grow potentially reaching all the banks that share a common KYC/AML policy 
for the specific product represented by the ERC20 token.

