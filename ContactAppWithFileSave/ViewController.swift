// Project:  Contact App with File Save
// Date:    12/16/18
// Author:  John Diczhazy
// Description: ViewController.swift

import Cocoa

class ViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate
{
    @IBOutlet weak var tfName: NSTextField!
    @IBOutlet weak var tfPhone: NSTextField!
    @IBOutlet weak var tfEmail: NSTextField!
    @IBOutlet weak var tfStreet: NSTextField!
    @IBOutlet weak var tfCity: NSTextField!
    @IBOutlet weak var tfState: NSTextField!
    @IBOutlet weak var tfZip: NSTextField!
    @IBOutlet weak var lblCount: NSTextField!
    @IBOutlet weak var tvContacts: NSTableView!
    @IBOutlet weak var puType: NSPopUpButton!
    @IBOutlet weak var lblDependent: NSTextField!
    @IBOutlet weak var tfDependent: NSTextField!
    
    // array to hold Strings in tableView
    var contacts:[String] = []
    
    // array of Contact objects
    var contactObjects:[Contact] = []
    
    // clears all the textFields.
    func clearTextFields()
    {
        // clear fields of text
        tfName.stringValue = ""
        tfPhone.stringValue = ""
        tfEmail.stringValue = ""
        tfStreet.stringValue = ""
        tfCity.stringValue = ""
        tfState.stringValue = ""
        tfZip.stringValue = ""
        tfDependent.stringValue = ""
        // change popup button to default
        puType.selectItem(withTitle: "Business")
        // change label back to Business
        lblDependent.stringValue="Company"
    }
    
    // call the clearTextFields function, do not clear the table
    @IBAction func btnClear(_ sender: Any)
    {
        clearTextFields() // Calls clearTextField function
    }
    
    
    // sortContacts function
    func sortContacts()
    {
        // closure used to sort array
        contactObjects.sort { (s1, s2) -> Bool in
            s1.name < s2.name
        }
        
        // remove all the strings from the contacts array, clearing the table
        contacts.removeAll()
        
        // build a new array from the contactObjects
        for contact in contactObjects
        {
            contacts.append(contact.description)
        }
        
        // reload the table with sorted data
        tvContacts.reloadData()
    }
    
    // call the sortContacts method from the btnSort action.
    @IBAction func btnSort(_ sender: Any)
    {
        sortContacts() // Calls sortContacts function
    }
    
    @IBAction func btnLoad(_ sender: Any)
    {
        // create the openPanel
        let openPanel = NSOpenPanel()
        
        // display the openPanel and get result
        openPanel.runModal()
        
        // remove any existing contacts before loading the contacts from the file.
        // make sure the count is correct.
        contacts.removeAll() // remove all the strings from the contacts array, clearing the table
        contactObjects.removeAll() // remove all the strings from the contactObjects array, clearing the table
        tvContacts.reloadData()  // reload the table with sorted data
        Contact.clearCount() // reset count to zero
        clearTextFields() // clear text fields
        
        // create reference to contact object
        var contact:Contact? = nil
        
        // bypass load code if URL is nil, this prevents app from crashing if Cancel is selected in openPanel
        let url = openPanel.url
        if url != nil
        {
            // read the file
            do
            {
                // read the contents of the file into a string
                let textFile = try String(contentsOf: openPanel.url!, encoding: String.Encoding.utf8)
                
                // separate the string into array by \n
                let lines = textFile.components(separatedBy: "\n")
                print("Lines: \(lines.count)")
                
                // get each line and split it into its fields which are seperated by commas
                for line in lines
                {
                    // fix for reading Java file. Java file has \n after last line
                    if line.count < 1
                    {
                        break
                    }
                    
                    // separate line into fields by comma
                    var fields = line.components(separatedBy: ",")
                    
                    // get the type of contact object from field 7 and create enum ContactType
                    // you could trim white space, file should not contain spaces after commas
                    let type:Contact.ContactType = Contact.ContactType(rawValue: fields[7].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
                    
                    // use switch to create the appropriate object
                    switch type
                    {
                    case Contact.ContactType.BUSINESS:
                        // create the ContactBusiness object and add it to the array contactObjects
                        try contact = ContactBusiness(
                            name: fields[0],
                            phone: fields[1],
                            email: fields[2],
                            street: fields[3],
                            city: fields[4],
                            state: fields[5],
                            zip: fields[6],
                            contactType: type,
                            company: fields[8]
                        )
                        
                        // use description func and add to contacts array
                        contacts.append((contact?.description)!)
                        
                        // add to the contactObjects array
                        contactObjects.append(contact!)
                        
                    case Contact.ContactType.FAMILY:
                        // create the ContactFamily object and add it to the array contactObjects
                        try contact = ContactFamily(
                            name: fields[0],
                            phone: fields[1],
                            email: fields[2],
                            street: fields[3],
                            city: fields[4],
                            state: fields[5],
                            zip: fields[6],
                            contactType: type,
                            relationship: fields[8])
                        
                        // use description func and add to contacts array
                        contacts.append((contact?.description)!)
                        
                        // add to the contactObjects array
                        contactObjects.append(contact!)
                        
                    case Contact.ContactType.FRIEND:
                        // create the ContactFriend object and add it to the array contactObjects
                        try contact = ContactFriend(
                            name: fields[0],
                            phone: fields[1],
                            email: fields[2],
                            street: fields[3],
                            city: fields[4],
                            state: fields[5],
                            zip: fields[6],
                            contactType: type,
                            yearMet: Int(fields[8])!)
                        
                        // use description func and add to contacts array
                        contacts.append((contact?.description)!)
                        
                        // add to the contactObjects array
                        contactObjects.append(contact!)
                    }
                }
            }
            catch
            {
                /* error handling here */
                print(error)
            }
            
            // get the current count from the Contact class and display it in the label
            lblCount.stringValue = "Count: \(Contact.getCount())"
            
            // reload the table
            tvContacts.reloadData()
        }
    }
    
    func addContact()
    {
        // variable to hold child of contact object
        var conObj:Contact? = nil
        
        do
        {
            // switch statement to determine which type is selected
            // indexes start at 0
            switch(puType.indexOfSelectedItem)
            {
            case 0:
                let company  = tfDependent.stringValue
                
                try conObj = ContactBusiness(name: tfName.stringValue, phone: tfPhone.stringValue, email: tfEmail.stringValue,
                                             street: tfStreet.stringValue, city: tfCity.stringValue, state: tfState.stringValue, zip: tfZip.stringValue,
                                             contactType: Contact.ContactType.BUSINESS, company: company)
                
            case 1:
                let relationship  = tfDependent.stringValue
                
                try conObj = ContactFamily(name: tfName.stringValue, phone: tfPhone.stringValue, email: tfEmail.stringValue,
                                           street: tfStreet.stringValue, city: tfCity.stringValue, state: tfState.stringValue, zip: tfZip.stringValue,
                                           contactType: Contact.ContactType.FAMILY, relationship: relationship)
                
            case 2:
                let yearMet = Int(tfDependent.stringValue) ?? 0
                
                try conObj = ContactFriend(name: tfName.stringValue, phone: tfPhone.stringValue, email: tfEmail.stringValue,
                                           street: tfStreet.stringValue, city: tfCity.stringValue, state: tfState.stringValue, zip: tfZip.stringValue,
                                           contactType: Contact.ContactType.FRIEND, yearMet: yearMet)
                
            default:
                conObj = nil
            }
            
            // add contact object to array.
            contactObjects.append(conObj!)
            
            // get the current count from the Contact class and display it in the label
            lblCount.stringValue = "Count: \(Contact.getCount())"
            
            // add the contact to the array
            contacts.append((conObj?.description)!)
            
            // update the tableView
            tvContacts.reloadData()
            
        }
        catch ContactError.invalidState
        {
            // create an Alert to display error
            let myPopup: NSAlert = NSAlert()
            // set the title
            myPopup.messageText = "Contact Creation Error"
            // set the message
            myPopup.informativeText = "Invalid State"
            myPopup.alertStyle = NSAlert.Style.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
        }
        catch ContactError.invalidZip
        {
            // create an Alert to display error
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Contact Creation Error"
            myPopup.informativeText = "Invalid Zip"
            myPopup.alertStyle = NSAlert.Style.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
        }
            // catches must be exhaustive, this will catch all other errors
        catch
        {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Contact Creation Error"
            myPopup.informativeText = "UnKnown Error"
            myPopup.alertStyle = NSAlert.Style.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
        }
    }
    
    // call the addContact, clearTextFields, and sortContacts functions from btnAdd action.
    @IBAction func btnAdd(_ sender: Any)
    {
        addContact() // Call addContact function
        clearTextFields() // Call clearTextFields function
        sortContacts() // Call sortContacts function
    }
    
    // function deleteContact()
    func deleteContact()
    {
        // get the selected row
        let selectedRow = tvContacts.selectedRow
        
        // if nothing is selected display error message, -1 if no row is selected
        if selectedRow < 0
        {
            // create an Alert to display error
            let myPopup: NSAlert = NSAlert()
            // set the title
            myPopup.messageText = "Deletion Error"
            // set the message
            myPopup.informativeText = "Nothing Selected in Table"
            myPopup.alertStyle = NSAlert.Style.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
        }
        else
        {
            // get the selected string in the table using table selected row and the contacts array
            let selectedString = contacts[selectedRow]
            
            // separate the selected string into individual strings using , as delimiter
            let selectedArray = selectedString.components(separatedBy: ",")
            
            // get the name which is in position 0
            let name = selectedArray[0]
            print("name: \(name)")
            
            // remove the contact from the array contactObjects
            contactObjects.remove(at: selectedRow)
            
            // remove the string from the array contacts
            contacts.remove(at: selectedRow)
            
            // decrement the count
            Contact.decrementCount()
            
            // get the current count from the Contact class and display it in the label
            lblCount.stringValue = "Count: \(Contact.getCount())"
            
            // reload the table
            tvContacts.reloadData()
        }
    }
    
    // call deleteContact function from btnDelete action.
    @IBAction func btnDelete(_ sender: Any)
    {
        deleteContact() // Call deleteContact function
    }
    
    // call deleteContact, addContact, and clearTextFields functions from btnUpdate action
    @IBAction func btnUpdate(_ sender: Any)
    {
        // get the selected row
        let selectedRow = tvContacts.selectedRow
        
        // if nothing is selected display error message, -1 if no row is selected
        if selectedRow < 0
        {
            // create an Alert to display error
            let myPopup: NSAlert = NSAlert()
            // set the title
            myPopup.messageText = "Update Error"
            // set the message
            myPopup.informativeText = "Nothing Selected in Table"
            myPopup.alertStyle = NSAlert.Style.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
        }
        else
        {
            deleteContact() // Call deleteContact function
            addContact() // Call addContact function
            clearTextFields() // Call clearTextFields function
            sortContacts() // Call sortContacts function
        }
    }
    
    @IBAction func btnSave(_ sender: Any)
    {
        // create the savePanel
        let savePanel = NSSavePanel()
        
        // display the savePanel and get result
        savePanel.runModal()
        
        //writing
        do
        {
            // reduce array of contacts from the table to one string
            let joinedString = contacts.joined(separator: "\n")
            print(joinedString)
            // replace all ", " with ","
            let joinedStringNoSpaces = joinedString.replacingOccurrences(of: ", ", with: ",")
            print(joinedStringNoSpaces)
            // write joined string to file. This works
            try joinedStringNoSpaces.write(to:savePanel.url!, atomically: false, encoding: String.Encoding.utf8)
        }
        catch
        {
            /* error handling here */
            print(error)
        }
    }
    
    @IBAction func puType(_ sender: NSPopUpButton)
    {
        // switch statement to determine which type is selected
        // indexes start at 0
        switch(puType.indexOfSelectedItem)
        {
        case 0:
            lblDependent.stringValue = "Company"
            
        case 1:
            lblDependent.stringValue = "Relationship"
            
        case 2:
            lblDependent.stringValue = "Year Met"
            
        default:
            print()
        }
        tfDependent.stringValue = ""
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Tell the TableView what class is handling the source and delegate
        tvContacts.dataSource = self
        tvContacts.delegate = self
    }
    
    @IBAction func btnExit(_ sender: Any)
    {
        NSApplication.shared.terminate(self)
    }
    
    // returns the string for the row and column
    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any?
    {
        print("column: \(String(describing: tableColumn?.identifier))row: \(row)")
        return contacts[row]
    }
    
    // returns the number of rows in the tableView
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return contacts.count
    }
    
    // called when the user selects an item in the table
    // you should always get the data from the tables data source
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        // get the selected row
        let row = tvContacts.selectedRow
        
        // get the string from the array at row
        // user can select nothing in the list which returns -1
        if row >= 0 && row < contacts.count
        {
            print("Selected: \(contacts[row])")
            
            // get the selected string in the table using table selected row and the contacts array
            let selectedString = contacts[row]
            
            // separate the selected string into individual strings using , as delimiter
            let selectedArray = selectedString.components(separatedBy: ",")
            
            // seperate strings from array, remove white space
            let name = selectedArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = selectedArray[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let email = selectedArray[2].trimmingCharacters(in: .whitespacesAndNewlines)
            let street = selectedArray[3].trimmingCharacters(in: .whitespacesAndNewlines)
            let city = selectedArray[4].trimmingCharacters(in: .whitespacesAndNewlines)
            let state = selectedArray[5].trimmingCharacters(in: .whitespacesAndNewlines)
            let zip = selectedArray[6].trimmingCharacters(in: .whitespacesAndNewlines)
            let type = selectedArray[7].trimmingCharacters(in: .whitespacesAndNewlines)
            let depd = selectedArray[8].trimmingCharacters(in: .whitespacesAndNewlines)
            
            // assign string data to text fields
            tfName.stringValue = name
            tfPhone.stringValue = phone
            tfEmail.stringValue = email
            tfStreet.stringValue = street
            tfCity.stringValue = city
            tfState.stringValue = state
            tfZip.stringValue = zip
            tfDependent.stringValue = depd
            
            // make sure the popup button reflects the item selected in the table using the switch statement
            switch type{
            case "BUSINESS":
                puType.selectItem(withTitle: "Business")
                lblDependent.stringValue = "Company"
            case "FAMILY":
                puType.selectItem(withTitle: "Family")
                lblDependent.stringValue = "Relationship"
            case "FRIEND":
                puType.selectItem(withTitle: "Friend")
                lblDependent.stringValue = "Year Met"
            default:
                print("No selection found")
            }
        }
    }
    
    override var representedObject: Any?
        {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
