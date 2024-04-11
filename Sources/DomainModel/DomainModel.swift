struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    
    let amount:Int
    let currency:String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        guard ["USD", "GBP", "EUR", "CAN"].contains(currency) else {
            fatalError("Invalid currency provided: \(currency)")
        }
        self.currency = currency
    }
    
    func convert(_ newCurrency:String) -> Money {
        
        var usdAmount: Int
                
                switch currency {
                case "USD":
                    usdAmount = amount
                    
                case "GBP":
                    usdAmount = Int(Double(amount) / 0.5)
                    
                case "EUR":
                    usdAmount = Int(Double(amount) / 1.5)
                    
                case "CAN":
                    usdAmount = Int(Double(amount) / 1.25)
                    
                default:
                    fatalError("Unknown currency: \(currency)")
                    
                }
                
                
                switch newCurrency {
                case "USD":
                    return Money(amount: usdAmount, currency: newCurrency)
                    
                case "GBP":
                    return Money(amount: Int(Double(usdAmount) * 0.5), currency: newCurrency)
                    
                case "EUR":
                    return Money(amount: Int(Double(usdAmount) * 1.5), currency: newCurrency)
                    
                case "CAN":
                    return Money(amount: Int(Double(usdAmount) * 1.25), currency: newCurrency)
                    
                default:
                    fatalError("Unknown currency: \(newCurrency)")
                }

    }
    
    
    func add(_ delta:Money) -> Money {
        
        if delta.currency != currency {
            let convertedAmount = convert(delta.currency)
            return Money(amount: convertedAmount.amount + delta.amount, currency: delta.currency)
        }
        else {
            return Money(amount: amount + delta.amount, currency: currency)
        }
        
    }
    
    func subtract(_ delta:Money) -> Money {
        
        if delta.currency != currency {
            let convertedAmount = convert(delta.currency)
            return Money(amount: convertedAmount.amount - delta.amount, currency: delta.currency)
        }
        else {
            return Money(amount: amount - delta.amount, currency: currency)
        }
        
    }
    
    
}

////////////////////////////////////
// Job
//
public class Job {
    
    let title:String
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var type:JobType
    
    init(title:String, type:JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours:Double) -> Int {
        
        switch type {
        case .Hourly(let hourlyWage):
            return Int(hours * hourlyWage)
        case .Salary(let yearlySalary):
            return Int(yearlySalary)
        }
        
    }
    
    func raise(byAmount amount: Double) {
            switch type {
            case .Hourly(let wage):
                type = .Hourly(wage + Double(amount))
            case .Salary(let salary):
                type = .Salary(salary + UInt(amount))
            }
        }
        
        func raise(byPercent percentage: Double) {
            switch type {
            case .Hourly(let wage):
                type = .Hourly(wage * (1 + percentage))
            case .Salary(let salary):
                type = .Salary(UInt(Double(salary) * (1 + percentage)))
            }
        }
        
}

////////////////////////////////////
// Person
//
public class Person {
    
    let firstName:String
    let lastName:String
    let age:Int
    var job: Job? {
          didSet {
              if age < 16 {
                  job = nil
              }
          }
      }
      var spouse: Person? {
          didSet {
              if age < 16 {
                  spouse = nil
              }
          }
      }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        
            var result = "[Person: firstName:" + firstName + " lastName:" + lastName + " age:" + String(age) + " job:"
            if job != nil {
                result += job!.title
            } else {
                result += "nil"
            }
            result += " spouse:"
            if spouse != nil {
                result += spouse!.firstName
            } else {
                result += "nil"
            }
            result += "]"
            return result
        
        }
    
}

////////////////////////////////////
// Family
//
public class Family {
    
    var members: [Person]
    
    init(spouse1:Person, spouse2:Person) {
        
        guard spouse1.spouse == nil && spouse2.spouse == nil else {
            fatalError("Each person can only be part of one family")
        }
        
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        
        self.members = [spouse1, spouse2]
        
    }
    
    func haveChild(_ kid:Person) -> Bool {
        
        if members[0].age > 21 || members[1].age > 21 {
            
            members.append(kid)
            return true
        }
        else {
            return false
        }
        
    }
    
    func householdIncome() -> Int {
        
        var totalIncome = 0
        
        for member in members {
            if (member.job !== nil){
                totalIncome += member.job!.calculateIncome(2000)
            }
        }
        
        return totalIncome
        
    }
    
}
