// Project:  Contact App with File Save
// Date:    12/16/18
// Author:  John Diczhazy
// Description: ContactFriend.swift

import Foundation

class ContactFriend:Contact
{
    // property for the child class
    var yearMet:Int
    
    // initializer
    init(name:String, phone:String, email:String, street:String, city:String, state:String, zip:String, contactType:ContactType, yearMet: Int) throws
    {
        // initialize the child property
        self.yearMet = yearMet
        
        // call the super class init
        try super.init(name: name, phone: phone, email: email, street: street, city: city, state: state, zip: zip, contactType: contactType)
    }
    
    // description function
    override var description: String
    {
        return "\(super.description), \(yearMet)"
    }
}
