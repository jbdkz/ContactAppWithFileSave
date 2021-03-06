// Project:  Contact App with File Save
// Date:    12/16/18
// Author:  John Diczhazy
// Description: ContactFamily.swift

import Foundation

class ContactFamily:Contact
{
    // property for the child class
    var relationship:String
    
    // initializer
    init(name:String, phone:String, email:String, street:String, city:String, state:String, zip:String, contactType:ContactType, relationship: String) throws
    {
        // initialize the child property
        self.relationship = relationship
        
        // call the super class init
        try super.init(name: name, phone: phone, email: email, street: street, city: city, state: state, zip: zip, contactType: contactType)
    }
    
    // description function
    override var description: String
    {
        return "\(super.description), \(relationship)"
    }
}
