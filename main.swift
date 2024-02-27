import Foundation

class Appointment: CustomStringConvertible {
    var time: String
    var name: String
    
    var description: String {
        return "Appointment with \(name) at \(time)"
    }
    
    init(time: String, name: String ) {
        self.time = time
        self.name = name
    }
}

enum AppointmentType: String {
    case consultation
    case followup
    case Interview
}

class DetailedAppointment: Appointment {
    var type: AppointmentType
    
    init(time: String, name: String, type: AppointmentType) {
        self.type = type
        super.init(time: time, name: name)
    }
    
    override var description: String {
        return "\(super.description) for \(type)"
    }
}

class TextTemplate {
    var defaultMessage: String
    
    init(defaultMessage: String) {
        self.defaultMessage = defaultMessage
    }
    
    func updateDefaultMessage(message: String) {
        self.defaultMessage = message
    }
    
    func applyAppointment(appointment: Appointment) -> String {
        let message = defaultMessage.replacingOccurrences(of: "time", with: appointment.time)
        return message.replacingOccurrences(of: "name", with: appointment.name)
    }
    
    func applyAppointment(appointment: DetailedAppointment) -> String {
        var message = defaultMessage.replacingOccurrences(of: "time", with: appointment.time)
        message = message.replacingOccurrences(of: "name", with: appointment.name)
        message += " for \(appointment.type)"
        return message
    }
}

struct AppointmentManager {
    var appointments: [Appointment]
    var textTemplate: TextTemplate
    
    init(appointments: [Appointment]? = nil, textTemplate: TextTemplate) {
        if let appointments = appointments {
            self.appointments = appointments
        } else {
            self.appointments = []
        }
        self.textTemplate = textTemplate
    }
    
    mutating func addAppointment(appointment:Appointment) {
        appointments.append(appointment)
    }
    
    func writeReminders() {
        guard !appointments.isEmpty else {
            print("No appointments to create")
            return
        }
        for currAppointment in appointments {
            if let detailedAppointment = currAppointment as? DetailedAppointment {
                let reminder = textTemplate.applyAppointment(appointment: detailedAppointment)
                print(reminder)
            } else {
                let reminder = textTemplate.applyAppointment(appointment: currAppointment)
                print(reminder)
            }
        }
    }
}

var appointments: [Appointment] = []
var template = TextTemplate(defaultMessage: "Hi name, this is Parker. I just want to remind you about your appointment with bishop at time")

while true {
    print("\nMenu:")
    print("1: Add appointment")
    print("2: Write reminders")
    print("3: Set new reminder template")
    print("4: Quit")
    print("Enter your choice:")

    if let input = readLine(), let choice = Int(input) {
        switch choice {
        case 1:
            print("Who is the appointment for?")
            if let name = readLine(), !name.isEmpty {
                print("When is the appointment? (HH:MM PM/AM)")
                if let time = readLine(), !time.isEmpty {
                    print("Is the type of appointment known? (yes/no)")
                    if let typeInput = readLine(), let knownType = typeInput.lowercased() == "yes" ? true : false {
                        if knownType {
                            print("What type of appointment is it? (consultation/followup/interview)")
                            if let typeString = readLine(), let type = AppointmentType(rawValue: typeString.lowercased()) {
                                let appointment = DetailedAppointment(time: time, name: name, type: type)
                                appointments.append(appointment)
                                print("Typed appointment added successfully!")
                            } else {
                                print("Invalid appointment type.")
                            }
                        } else {
                            let appointment = Appointment(time: time, name: name)
                            appointments.append(appointment)
                            print("Basic appointment added successfully!")
                        }
                    } else {
                        print("Invalid input for appointment type.")
                    }
                } else {
                    print("Invalid time format.")
                }
            } else {
                print("Invalid name.")
            }

        case 2:
            let appointmentManager = AppointmentManager(appointments: appointments, textTemplate: template)
            appointmentManager.writeReminders()
        case 3:
            print("Enter the new reminder template:")
            if let newTemplate = readLine() {
                template.updateDefaultMessage(message: newTemplate)
                print("New template set successfully!")
            } else {
                print("Invalid template.")
            }
        case 4:
            print("Exiting the program.")
            exit(0)
        default:
            print("Invalid choice. Please enter a number between 1 and 4.")
        }
    } else {
        print("Invalid input. Please enter a number.")
    }
}

