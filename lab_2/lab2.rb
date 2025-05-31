module Logger
  
  def log_info(message)
    File.open("app.logs", "a") do |file|
      file.puts "#{Time.now} -- INFO -- #{message} "
    end
  
  end

  def log_warning(message)
    File.open("app.logs", "a") do |file|
      file.puts "#{Time.now} -- WARNING -- #{message} "
    end
  end

  def log_error(message)
    File.open("app.logs", "a") do |file|
      file.puts "#{Time.now} -- ERROR -- #{message} "
    end
  end

end

# logger should append to app.logs in this format {timestamp} -- {log_type} -- {message}

class User
  # include Logger
  attr_accessor :name, :balance
  def initialize(name, balance)
    @name = name
    @balance = balance
  end

end


class Transaction
  attr_accessor :user, :value
  def initialize(user, value)
    @user = user
    @value = value
  end

  def display_transaction
    puts "User: #{@user.name}, Transaction Value: #{@value}"
  end
end


class Bank

  def initialize
    raise "#{self.class} is abstract" if self.instance_of?(Bank) #instance_of?(Bank)
  end

  def process_transaction(*trans, &_block)
    raise "Method #{__method__} is abstract, please override this method"
  end

end

class CBABank < Bank
  include Logger

  def initialize(*args)
    @users = args
  end
  def process_transaction(*trans, &block)
    init_log = "#{Time.now} -- INFO -- Processing Transactions ";
    trans.each do |transaction|
      init_log += "User #{transaction.user.name} transaction with value #{transaction.value}, "
    end
    puts init_log
    File.open("app.logs", "a") do |file|
      file.puts init_log
    end
    #For each transaction, the user in the transaction is being checked if it is related to the bank or now (read about .include? method)
 
    trans.each do |transaction|
      if @users.include?(transaction.user)
        if transaction.user.balance + transaction.value > 0
          log_info("User #{transaction.user.name} transaction with value #{transaction.value} succeeded")
          transaction.user.balance += transaction.value
          block.call(:success, transaction)

        elsif transaction.user.balance + transaction.value == 0
          log_info("User #{transaction.user.name} transaction with value #{transaction.value} succeeded")
          log_warning("#{transaction.user.name} has 0 balance")
          transaction.user.balance = 0
          block.call(:success, transaction)
        else
          log_error("User #{transaction.user.name} transaction with value #{transaction.value} failed with message Not enough balance")
          block.call(:error, transaction,"not enogh balance")
        end
      else
        log_error("User #{transaction.user.name} transaction with value #{transaction.value} failed with message #{transaction.user.name} not exist in the bank!!")
        block.call(:error, transaction, "user not registered")
      end
    end

  end
end



users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

CBABank.new(*users).process_transaction(*transactions) do |status, transaction, message|
  if status == :success
    puts "#{transaction.user.name} transaction with value #{transaction.value} succeeded"
  else
    puts "#{transaction.user.name} transaction with value #{transaction.value} failed with reason #{message}"
    
  end
end