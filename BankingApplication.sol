// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


    struct UserDetails{
        address user;
        uint UserBlnc;
        uint TotalOutstandingLoan;
        uint PersonalOutstandingLoan;
        uint PersonalEmi;
        uint CarOutstandingLoan;
        uint CarEMI;
        uint HomeOutstandingLoan;
        uint HomeEmi;
    }

    struct LoanDetails{
        uint OutstandingLoan;
        uint MonthlyEmi;
        uint NumberOfEMI;

    }



contract BankingSystem
{

    UserDetails public User1;
    LoanDetails public PesonalLoanDetails;
    LoanDetails public HomeLoanDetails;
    LoanDetails public CarLoanDetails;
    address payable Owner;

    constructor()
    {
        Owner = payable(msg.sender);
        //User1.user = msg.sender;
    }

    //Deposit to bank(contract) by Bank Owner
    function depositToBank() public payable
    {
        require(msg.value!=0,"Value Should be Greater than Zero");
        require(msg.sender == Owner,"Only Owner can Deposit Funds In Contract");
    }


    function BankBalance() public view returns(uint)
    {
        return address(this).balance;
    }

// Deposit to user account (address) from other account (address).
    function DepositBlcToAcc(address payable user_aadress) public payable
    {
        require(msg.sender!=user_aadress,"");
        require(msg.sender != Owner);
        require(msg.value >0,"Deposit Fund must be greater than Zero");
        user_aadress.transfer(msg.value);
        User1.UserBlnc = address(user_aadress).balance;
    }

// To Get Personal Loan 
    function GetPersonalLoan(address payable receiver,uint duration, uint amount) public payable
    {
        User1.user = receiver;
        uint intrest = amount*14/100;
        User1.PersonalOutstandingLoan = User1.PersonalOutstandingLoan+(amount+intrest);
        PesonalLoanDetails.OutstandingLoan = User1.PersonalOutstandingLoan;
        User1.PersonalEmi = User1.PersonalEmi + User1.PersonalOutstandingLoan/duration;
        PesonalLoanDetails.MonthlyEmi = User1.PersonalEmi;
        PesonalLoanDetails.NumberOfEMI = duration;
        uint Bblc = address(this).balance;
        //require(User1.OutstandingLoan==0,"You've already Taken loan");
        require(duration>=1,"Duration should be 1 Month or more");
        require(amount>0 && amount<Bblc,"Amount Shuld not be Zero And Less than ContractBalance");
        receiver.transfer(amount);
        Bblc = Bblc-amount; 
        User1.UserBlnc = User1.UserBlnc + User1.PersonalOutstandingLoan ;
    }


// To Get Car Loan
    function getCarLoan(address payable receiver , uint duration , uint amount) public payable
    {
        User1.user = receiver;
        uint intrest = amount*9/100;
        User1.CarOutstandingLoan = User1.CarOutstandingLoan+(amount+intrest);
        CarLoanDetails.OutstandingLoan = User1.CarOutstandingLoan;
        User1.CarEMI = User1.CarEMI + User1.CarOutstandingLoan/duration;
        CarLoanDetails.MonthlyEmi = User1.CarEMI;
        CarLoanDetails.NumberOfEMI = duration;
        uint Bblc = address(this).balance;
        //require(User1.OutstandingLoan==0,"You've already Taken loan");
        require(duration>=1,"Duration should be 1 Month or more");
        require(amount>0 && amount<Bblc,"Amount Shuld not be Zero And Less than ContractBalance");
        receiver.transfer(amount);
        Bblc = Bblc-amount; 
        User1.UserBlnc = User1.UserBlnc + User1.CarOutstandingLoan ;

    }

// To Get Home Loan
    function GetHomeLoan(address payable receiver, uint duration, uint amount) public payable
    {
        User1.user = receiver;
        uint intrest = amount*7/100;
        User1.HomeOutstandingLoan = User1.HomeOutstandingLoan+(amount+intrest);
        HomeLoanDetails.OutstandingLoan = User1.HomeOutstandingLoan;
        User1.HomeEmi = User1.HomeEmi + User1.HomeOutstandingLoan/duration;
        HomeLoanDetails.MonthlyEmi = User1.HomeEmi;
        HomeLoanDetails.NumberOfEMI = duration;
        uint Bblc = address(this).balance;
        //require(User1.OutstandingLoan==0,"You've already Taken loan");
        require(duration>=1,"Duration should be 1 Month or more");
        require(amount>0 && amount<Bblc,"Amount Shuld not be Zero And Less than ContractBalance");
        receiver.transfer(amount);
        Bblc = Bblc-amount; 
        User1.UserBlnc = User1.UserBlnc + User1.HomeOutstandingLoan ;

    }

    // function PayEMI(uint amount) public //payable
    // {
    //     require(amount == User1.MonthlyEmi,"EMI must be equal to due amount");
    //     require(msg.sender == User1.user,"Account address must be same where emi pending to pay");
    //     User1.UserBlnc = User1.UserBlnc - amount;
    //     User1.OutstandingLoan = User1.OutstandingLoan - amount;
    //     //payable(address(this)).transfer(amount);
    //     address(this).balance + amount;
    // }
     
}
