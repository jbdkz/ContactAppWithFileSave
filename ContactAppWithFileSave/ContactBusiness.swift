// Project:  Contact App with File Save
// Date:    10/16/18
// Author:  John Diczhazy
// Description: ContactBusiness.swift

import Foundation

class ContactBusiness:Contact
{
    // property for the child class
    var company:String
    
    // initializer
    init(name:String, phone:String, email:String, street:String, city:String, state:String, zip:String, contactType:ContactType, company: String) throws
    {
        // initialize the child property
        self.company = company
        
        // call the super class init
        try super.init(name: name, phone: phone, email: email, street: street, city: city, state: state, zip: zip, contactType: contactType)
    }
    
    // description function
    override var description: String
    {
        return "\(super.description), \(company)"
    }
}
