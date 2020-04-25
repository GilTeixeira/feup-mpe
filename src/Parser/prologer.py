

class Prologer:
    def __init__(self, hospital):
        self.hospital=hospital
        self.prologCode = ""
    
    def generatePrologFile(self, output):
        prologFile = open(output, 'w', encoding="utf-8")
        self.convertToProlog()
        prologFile.write(self.prologCode)
        prologFile.close()

    def convertToProlog(self):
        self.prologCode = ("%% Autogenerated data file from text file: '%s'\n" % "TODO")
        self.convertNumberOfDays()  
        self.convertShifts()
        self.convertStaff()
        self.convertDaysOff()
        self.convertShiftOnRequests()
        self.convertShiftOffRequests()
        self.convertCover()
    

    def convertNumberOfDays(self):
        self.prologCode += '\n'
        self.prologCode += "number_of_days(%d)." %  self.hospital.numberOfDays
        self.prologCode += '\n'
    
    def convertShifts(self):
        self.prologCode += '\n'
        for shift in self.hospital.shifts:
            self.prologCode += "shift(%d,%d,%s).\n" % (shift.shiftIntID,shift.duration,str(self.hospital.getShiftsIntID(shift.shiftsIDCantFollow)))  
        #self.prologCode += "numberOfDays(%d)." %  self.hospital.numberOfDays
        self.prologCode += '\n'

 #nurseID, maxShifts,
    #maxTotalMinutes, minTotalMinutes, maxConsecutiveShifts, 
    #minConsecutiveShifts, minConsecutiveDaysOff, maxWeekends
    def convertStaff(self):
        self.prologCode += '\n'
        for nurse in self.hospital.nurses:
            maxShiftsWithIntID = [(self.hospital.getShiftIntID(shiftID),maxShift) for (shiftID, maxShift) in nurse.maxShifts]
            self.prologCode += "nurse(%d,%s,%d,%d,%d,%d,%d,%d).\n" % (nurse.nurseIntID, str(maxShiftsWithIntID),
                nurse.maxTotalMinutes, nurse.minTotalMinutes, nurse.maxConsecutiveShifts, 
                nurse.minConsecutiveShifts, nurse.minConsecutiveDaysOff, nurse.maxWeekends)
        #self.prologCode += "numberOfDays(%d)." %  self.hospital.numberOfDays
        self.prologCode += '\n'
    
    def convertDaysOff(self):
        self.prologCode += "\n"
        for nurse in self.hospital.nurses:
            self.prologCode += "days_off(%d,%s).\n" % (nurse.nurseIntID,str(nurse.daysOff))
        self.prologCode += "\n"

    def convertShiftOnRequests(self):
        self.prologCode += "\n"
        for nurse in self.hospital.nurses:
            for request in nurse.shiftOnRequests:
                self.prologCode += "shift_on_request(%d,%d,%d,%d).\n" % (nurse.nurseIntID,request.day,self.hospital.getShiftIntID(request.shiftID),request.weight)
        self.prologCode += "\n"
    
    # day, shiftID, weight, OnRequest
    def convertShiftOffRequests(self):
        self.prologCode += "\n"
        for nurse in self.hospital.nurses:
            for request in nurse.shiftOffRequests:
                self.prologCode += "shift_off_request(%d,%d,%d,%d).\n" % (nurse.nurseIntID,request.day,self.hospital.getShiftIntID(request.shiftID),request.weight)
        self.prologCode += "\n"
    
    #day, shiftID, required, weightUnder, weightOver
    def convertCover(self):
        self.prologCode += "\n"
        for cover in self.hospital.covers:
            self.prologCode += "cover(%d,%d,%d,%d,%d).\n" % (cover.day, self.hospital.getShiftIntID(cover.shiftID), cover.required, cover.weightUnder, cover.weightOver)
        self.prologCode += "\n"

