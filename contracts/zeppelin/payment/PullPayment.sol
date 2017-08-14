pragma solidity ^0.4.11;


/*
 * PullPayment
 * Base contract supporting async send for pull payments.
 * Inherit from this contract and use asyncSend instead of send.
 */
contract PullPayment {
  mapping(address => uint) public payments;

  // store sent amount as credit to be pulled, called by payer
  function asyncSend(address dest, uint amount) internal {
    payments[dest] += amount;
  }

  // withdraw accumulated balance, called by payee
  function withdrawPayments() {
    address payee = msg.sender;
    uint payment = payments[payee];
    
    if (payment == 0) {
      revert();
    }

    if (this.balance < payment) {
      revert();
    }

    payments[payee] = 0;

    if (!payee.send(payment)) {
      revert();
    }
  }
}
