//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Banking
{

    
    address payable Owner;
    struct User
    {
        uint Balance ;
        uint Date ;

    } 


    struct LoanDetails
    {
        uint OutstandingLoan;
        uint MonthlyEmi;
        uint NumberOfEMI;
        uint Date ;
        
    }

    mapping(address => User) public Users;
    mapping(address => LoanDetails) public PersonalLoan;
    mapping(address => LoanDetails) public HomeLoan;
    mapping(address => LoanDetails) public CarLoan;


    constructor()
    {
        Owner = payable(msg.sender);
    }


    function Addfund() public payable
    {
        require(msg.value!=0,"Value Should be Greater than Zero");
        require(msg.sender == Owner,"Only Owner can Deposit Funds In Contract");
    }


    function BankBalance() public view returns(uint)
    {
        return address(this).balance;
    }


    function Deposit(uint amount) public payable
    {
        require( amount>0,"Deposit Fund must be greater than Zero");
        Users[msg.sender].Balance += amount;
        Users[msg.sender].Date  = block.timestamp;

    }


    function GetPersonalLoan(uint amount , uint duration) public payable
    {
        uint Bblc = address(this).balance;

        require(Users[msg.sender].Balance > 0,"Acount not created yet");
        require(duration>=1,"Duration should be 1 Month or more");
        require(amount>0 && amount<Bblc,"Amount Shuld not be Zero And Less than ContractBalance");

        uint intrest = amount*14/100;
        LoanDetails memory person  = PersonalLoan[msg.sender];
        person.OutstandingLoan +=  amount +  intrest;
        person.MonthlyEmi += person.OutstandingLoan/duration;
        person.NumberOfEMI += duration;
        PersonalLoan[msg.sender] = person;

        
        payable(msg.sender).transfer(amount);
        Bblc = Bblc-amount; 
        Users[msg.sender].Balance += amount;
        PersonalLoan[msg.sender].Date = block.timestamp;

    }



    function GetCarLoan(uint amount, uint duration) public payable
    {
        uint Bblc = address(this).balance;

        require(Users[msg.sender].Balance > 0,"Acount not created yet");
        require(duration>=1,"Duration should be 1 Month or more");
        require(amount>0 && amount<Bblc,"Amount Shuld not be Zero And Less than ContractBalance");

        uint intrest = amount*9/100;
        LoanDetails memory person = CarLoan[msg.sender];
        person.OutstandingLoan += amount + intrest;
        person.MonthlyEmi += person.OutstandingLoan/duration;
        person.NumberOfEMI  += duration;

        CarLoan[msg.sender] = person;

        payable(msg.sender).transfer(amount);
        Bblc = Bblc - amount;
        Users[msg.sender].Balance += amount;
        CarLoan[msg.sender].Date = block.timestamp;

    }



    function GetHomeLoan(uint amount , uint duration) public payable
    {
        uint Bblc = address(this).balance;

        require(Users[msg.sender].Balance > 0,"Acount not created yet");
        require(duration>=1,"Duration should be 1 Month or more");
        require(amount>0 && amount<Bblc,"Amount Shuld not be Zero And Less than ContractBalance");

        uint intrest = amount*7/100;
        LoanDetails memory person = HomeLoan[msg.sender];
        person.OutstandingLoan += amount + intrest;
        person.MonthlyEmi += person.OutstandingLoan/duration;
        person.NumberOfEMI += duration;

        payable(msg.sender).transfer(amount);
        Bblc = Bblc - amount;
        Users[msg.sender].Balance += amount;
        HomeLoan[msg.sender].Date = block.timestamp;

    }



    function PayEMI(string memory LoanType,uint amount) public
    {

        if(keccak256(abi.encodePacked(LoanType)) == keccak256(abi.encodePacked("Personal")))
        {
            require(keccak256(abi.encodePacked(LoanType)) == keccak256(abi.encodePacked("Personal")),"Invalid Loan Type");
            require(amount == PersonalLoan[msg.sender].MonthlyEmi,"EMI must be equal to due amount");
             
            LoanDetails memory person  = PersonalLoan[msg.sender];

            person.OutstandingLoan -=  amount;
            address(this).balance + amount;
            person.NumberOfEMI -= 1;

            PersonalLoan[msg.sender] = person;
        }


        if(keccak256(abi.encodePacked(LoanType)) == keccak256(abi.encodePacked("Car")))
        {
            require(keccak256(abi.encodePacked(LoanType)) == keccak256(abi.encodePacked("Car")));
            require(amount == CarLoan[msg.sender].MonthlyEmi,"EMI must be equal to due amount");

            LoanDetails memory person  = CarLoan[msg.sender];
            
            person.OutstandingLoan -= amount;
            address(this).balance + amount;
            person.NumberOfEMI -= 1;
            CarLoan[msg.sender] = person;

        }

        if(keccak256(abi.encodePacked(LoanType)) == keccak256(abi.encodePacked("Home")))
        {
            require(keccak256(abi.encodePacked(LoanType)) == keccak256(abi.encodePacked("Home")));
            require(amount == HomeLoan[msg.sender].MonthlyEmi,"EMI must be equal to due amount");
             
            LoanDetails memory person  = HomeLoan[msg.sender];

            person.OutstandingLoan -= amount;
            address(this).balance + amount;
            person.NumberOfEMI -= 1;

            HomeLoan[msg.sender] = person;
        }


    }


}