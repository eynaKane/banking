class Account
  @@ctr = 0

  def initialize(check)
    if check == pin
      @balance = balance
      @@trans = trans
      @valid = true
      puts "Welcome back!\nYour current balance is $#{@balance}\n\n"
    else
      puts pin_error
      @valid = false
    end
  end

  public

  def valid?
    @valid
  end

  def withdraw(pin_number, amount)
    @@ctr += 1
    @@trans[@@ctr] = { withdraw: amount }
    return pin_error unless pin_number == pin
    return amount_error unless amount <= @balance

    @balance -= amount
    "\nWithdrew $#{amount}.\nYour current balance is $#{@balance}."
  end

  def deposit(pin_number, amount)
    @@ctr += 1
    @@trans[@@ctr] = { deposit: amount }
    return pin_error unless pin_number == pin
    return amount_error unless amount > 0

    @balance += amount
    "\nDeposited $#{amount}.\nYour current balance is $#{@balance}."
  end

  def display_balance(pin_number)
    pin_number == pin ? "\nYour current balance is $#{@balance}." : pin_error
  end

  private

  def pin
    @pin = 1234
  end

  def balance
    @balance = 1_000.00
  end

  def trans
    @@trans = {}
  end

  def self.transactions
    @@trans.map do |k, v|
      print "\n#{k.to_s}: "
      v.map do |type, amount|
        print "#{type.to_s} $#{amount}"
      end
    end
  end

  def pin_error
    "Incorrect PIN. Access Denied!"
  end

  def amount_error
    "\nInvalid amount!"
  end
end

class SavingsAccount < Account
  def withdraw(pin_number, amount)
    "\nSorry! You shouldn't withdraw from your Savings Account."
  end

  def self.list_transactions
    puts "\n\nYour Savings Account Transactions:"
    self.transactions
  end
end

class CheckingAccount < Account
  def self.list_transactions
    puts "\n\nYour Checking Account Transactions:"
    self.transactions
  end
end

ctr = 0
checker = false
until checker do
  print "\n"
  ctr += 1
  puts "***********************************\n[1] Savings Account"
  puts "[2] Checking Account"
  print "Enter account type: "
  type = gets.chomp.to_i
  checker = [1,2].include?(type)
  abort("\n\nFRAUD DETECTION!") if ctr == 3 && checker != true
end

type_name = type == 1 ? SavingsAccount : CheckingAccount

ctr = 0
checker = false
until checker do
  print "\n"
  ctr += 1
  print "Enter PIN: "
  pin = gets.chomp.to_i
  account = type_name.new(pin)
  checker = account.valid?
  abort("\n\nFRAUD DETECTION!") if ctr == 3 && checker != true
end

loop do
  ctr = 0
  checker = false
  until checker do
    print "\n"
    ctr += 1
    puts "***********************************\n[1] Withdraw"
    puts "[2] Deposit"
    puts "[3] Check Balance"
    puts "[4] Quit!"
    print "What would you like to do? "
    task = gets.chomp.to_i
    checker = [1,2,3,4].include?(task.to_i)
    abort("\n\nFRAUD DETECTION!") if ctr == 3 && checker != true
  end

  case task
  when 1
    print "Enter amount to withdraw: "
    withdraw_amt = gets.chomp
    puts !(withdraw_amt !~ /\A\d+\.?\d{0,2}\z/) ? account.withdraw(pin, withdraw_amt.to_f) : "Invalid amount! Transaction voided."
  when 2
    print "Enter amount to deposit: "
    deposit_amt = gets.chomp
    puts !(deposit_amt !~ /\A\d+\.?\d{0,2}\z/) ? account.deposit(pin, deposit_amt.to_f) : "Invalid amount! Transaction voided."
  when 3
    puts account.display_balance(pin)
  else
    puts account.display_balance(pin)
    puts type_name.list_transactions
    abort("Thank you!")
  end
end
