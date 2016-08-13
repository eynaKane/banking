class Account
  @@trans = {}
  @@ctr = 0

  def initialize(check)
    if check == pin
      @balance = balance
      puts "Welcome back!\nYour current balance is $ #{@balance}\n\n"
      @valid = true
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
    return puts pin_error unless pin_number == pin
    return puts amount_error unless amount <= @balance

    @balance -= amount
    puts "\nWithdrew #{amount}.\nYour current balance is $ #{@balance}."
  end

  def deposit(pin_number, amount)
    @@ctr += 1
    @@trans[@@ctr] = { deposit: amount }
    return puts pin_error unless pin_number == pin
    return puts amount_error unless amount > 0

    @balance += amount
    puts "\nDeposited #{amount}.\nYour current balance is $ #{@balance}."
  end

  def display_balance(pin_number)
    puts pin_number == pin ? "\nYour current balance is $ #{@balance}." : pin_error
  end

  def self.trans
    puts "\n\n#{@@trans}"
  end

  private

  def pin
    @pin = 1234
  end

  def balance
    @balance = 1_000.00
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
    puts "\nSorry! Withdrawing from your Savings Account is invalid."
  end

  def self.trans
    puts "\n\nYour Savings Account Transactions:"
    @@trans.map do |k, v|
      print "#{k.to_s}: "
      v.map do |type, amount|
        puts "#{type.to_s} $ #{amount}"
      end
    end
  end
end

class CheckingAccount < Account
  def self.trans
    puts "\n\nYour Checking Account Transactions:"
    @@trans.map do |k, v|
      print "#{k.to_s}: "
      v.map do |type, amount|
        puts "#{type.to_s} $ #{amount}"
      end
    end
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
    withdraw_amt = gets.chomp.to_f.round(2)
    account.withdraw(pin, withdraw_amt)
  when 2
    print "Enter amount to deposit: "
    deposit_amt = gets.chomp.to_f.round(2)
    account.deposit(pin, deposit_amt)
  when 3
    account.display_balance(pin)
  else
    type_name.trans
    abort("\n\nBye...")
  end
end
