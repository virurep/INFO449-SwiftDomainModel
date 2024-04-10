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
    
    func convert(_ targetCurrency:String) -> Money {
        
        let usdAmount = convertUSD().amount
        
        switch targetCurrency {
        case "USD" :
            return Money(amount: usdAmount * 1, currency: targetCurrency)
        case "GBP" :
            return Money(amount: usdAmount * (1/2), currency: targetCurrency)
        case "EUR" :
            return Money(amount: usdAmount * (3/2), currency: targetCurrency)
        case "CAN" :
            return Money(amount: usdAmount * (5/4), currency: targetCurrency)
        default:
            fatalError("Invalid currency provided: \(targetCurrency)")
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
    
    private func convertUSD() -> Money {
        
        switch currency {
        case "GBP" :
            return Money(amount: amount * 2, currency: "USD")
        case "EUR" :
            return Money(amount: amount * (2/3), currency: "USD")
        case "CAN" :
            return Money(amount: amount * (4/5), currency: "USD")
        case "USD" :
            return self
        default:
            fatalError("Invalid currency provided: \(currency)")
            
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
    
    func raise(byAmount delta:Double){
            
            switch type {
            case .Hourly(let hourlyWage):
                type = .Hourly(hourlyWage + Double(delta))
            case .Salary(let yearlySalary):
                type = .Salary(yearlySalary + UInt(delta))
            }
            
    }
    
    func raise(byPercent delta:Double){
            
            switch type {
            case .Hourly(let hourlyWage):
                type = .Hourly(hourlyWage * (1.0 + delta))
            case .Salary(let yearlySalary):
                type = .Salary(yearlySalary + UInt(1.0 + delta))
            }
            
    }
        
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
