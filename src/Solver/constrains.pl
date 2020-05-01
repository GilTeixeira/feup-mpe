% Constrain 1
% HC1 : Maximum one shift per day
% Already Defined in the domain 


% Constrain 2
% HC2 : Shift rotations
set_shift_rotations(Schedule):-
    findall([ShiftID, ImpossibleShifts], shift(ShiftID,_,ImpossibleShifts), Shifts),
    maplist(set_shift_rotation_schedule(Schedule),Shifts).
 
set_shift_rotation_schedule([],_).
set_shift_rotation_schedule(_,[_,[]]). % Otimization 4.2.2
set_shift_rotation_schedule([ScheduleNurse|ScheduleRemain], [ShiftID,ImpossibleShifts]):-
    set_shift_rotation_nurse(ScheduleNurse, [ShiftID,ImpossibleShifts]),
    set_shift_rotation_schedule(ScheduleRemain, [ShiftID,ImpossibleShifts]).

% TODO : Optimization FDSEt from prologer
set_shift_rotation_nurse([_],_).
set_shift_rotation_nurse([ScheduleDay,ScheduleNextDay|ScheduleNurseRemain], [ShiftID, ImpossibleShifts]):-
    list_to_fdset(ImpossibleShifts,ImpossibleShiftsFDSet),
    (ScheduleDay #= ShiftID) #=> #\(ScheduleNextDay in_set ImpossibleShiftsFDSet),
    set_shift_rotation_nurse([ScheduleNextDay|ScheduleNurseRemain], [ShiftID, ImpossibleShifts]).



% TODO: Otimization when nurse can only do 1 shift
% ID, MaxShifts, MaxTotalMinutes, MinTotalMinutes, MaxConsecutiveShifts, MinConsecutiveShifts, MinConsecutiveDaysOff, MaxWeekends
% Constrain 3
% HC3: Maximum number of shifts
set_max_shifts(Schedule):-
    findall([NurseID, MaxShifts,MaxTotalMinutes, MinTotalMinutes], nurse(NurseID,MaxShifts,MaxTotalMinutes, MinTotalMinutes,_,_,_,_), Nurses),
    maplist(set_max_shifts_schedule(Schedule),Nurses).

set_max_shifts_schedule(Schedule, [NurseID,MaxShifts,MaxTotalMinutes, MinTotalMinutes]):-
    nth1(NurseID,Schedule,NurseSchedule),
    length(MaxShifts, NShifts),
    length(ShiftsCounter, NShifts),
    
    % Constrain 3
    create_global_cardinal_vals(MaxShifts,ShiftsCounter,Vals),
    global_cardinality(NurseSchedule, [0-_|Vals]), % nurses can have no shift _ times

    % Constrain 4 & 5
    get_shifts_duration(ShiftsDuration),
    scalar_product(ShiftsDuration, ShiftsCounter, #=<, MaxTotalMinutes),
    scalar_product(ShiftsDuration, ShiftsCounter, #>=, MinTotalMinutes).



create_global_cardinal_vals([],[],[]).
create_global_cardinal_vals([(ShiftID, MaxShift)|MaxShifts],[ShiftCounter|ShiftsCounter],[Val|Vals]):-
    Val = ShiftID-ShiftCounter,
    ShiftCounter #=< MaxShift,
    create_global_cardinal_vals(MaxShifts,ShiftsCounter,Vals).



%%% old c3
/*
set_max_shifts(Schedule):-
    forall(shift(NurseID,MaxShifts,_,_,_,_,_,_), set_max_shifts_schedule(NurseID,MaxShifts,Schedule)). 
% TODO OPTIMIZATION:- find nurse schedule every time
set_max_shifts_schedule(NurseID,MaxShifts,Schedule):-


%[(1, 14), (2, 14)]
createListDiff(0,[],_).
createListDiff(NShifts,[ShiftID|ShiftsList],[ListHead|List]):-
    NShiftsMinus1 is NShifts - 1,
    ListHead = ShiftID-NShifts.
    createListDiff(NShiftsMinus1, ShiftsList, List).




set_max_shifts_schedule(NurseID,MaxShifts,Schedule):-
    nth1(NurseID,Schedule,NurseSchedule),
    get_number_shifts(NShifts),
    get_shifts_list(ShiftsList),

    length(Length, NShifts),
    global_cardinality(NurseSchedule).

*/



% Constrain 5
% HC5: Minimum total minutes
%set_min_minutes(Schedule):-
    % global cardinalityt of each type of shift
%    nl.



% Constrain 10
% HC10 : Requested days off
%set_nurses_days_off(Schedule):-
    %forall(days_off(NurseID,DaysOff), set_nurse_days_off(NurseID,DaysOff,Schedule)).

%set_nurse_days_off(NurseID, [], Schedule).
%set_nurse_days_off(NurseID, [DayOff|DaysOff], Schedule):-

    % TODO
%    set_nurse_days_off(NurseID, DaysOff, Schedule).
