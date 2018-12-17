// Project:  Contact App with File Save
// Date:    10/16/18
// Author:  John Diczhazy
// Description: Contact.swift

import Foundation

class Contact :NSObject
{
    // properties
    var name:String
    var phone:String
    var email:String
    var address:Address
    var type:ContactType
    
    // type property
    private static var count:Int = 0
    
    // return the private count
    static func getCount()->Int
    {
        return count
    }
    
    // increment the private count
    static func incrementCount()
    {
        count += 1
    }
    
    // decrement the private count
    static func decrementCount()
    {
        count -= 1
    }
    
    // make sure the count is correct.
    static func clearCount()
    {
        count = 0
    }
    
    // description property returns string used in list
    override var description:String
    {
        return "\(name), \(phone), \(email), \(address), \(type)"
    }
    
    // initializer
    init(name:String, phone:String, email:String, street:String, city:String, state:String, zip:String, contactType:ContactType) throws
    {
        self.name = name
        self.phone = phone
        self.email = email
        
        // must try to create Address since it throws
        try self.address = Address(street: street, city: city, state: state, zip: zip)
        self.type = contactType
        
        // increment the type property
        Contact.count += 1
    }
    
    // nested class
    // class to represent a Address
    // add NSObject so we can override the description property
    class Address :NSObject
    {
        // properties
        var street:String
        var city:String
        var state:String
        var zip:String
        
        // initializers
        init(street:String, city:String, state:String, zip:String) throws
        {
            // truncate street to 10 characters
            if street.count > 10
            {
                // find the 10th index
                let index1 = street.index(street.startIndex, offsetBy: 9)
                // string slice to first 10 characters
                self.street = String(street[...index1])
            }
            else
            {
                self.street = street
            }
            
            // capitalize the first character
            self.city = city.capitalized
            
            // check for state exactly 2 characters and uppercase.
            self.state = state.uppercased()
            if state.count != 2
            {
                // throw an error
                throw ContactError.invalidState
            }
            
            // check for zip exactly 5 digits
            if let range = zip.range(of: "^\\d{5}$", options: .regularExpression)
            {
                //self.zip = zip.substring(with: range)
                self.zip = String(zip[range])
            }
            else
            {
                // throw an error
                throw ContactError.invalidZip
            }
        }
        
        // description property returns string used in list
        override var description : String
        {
            return "\(street), \(city), \(state), \(zip)"
        }
    }
    
    enum ContactType:String
    {
        case BUSINESS, FAMILY, FRIEND
    }
}




