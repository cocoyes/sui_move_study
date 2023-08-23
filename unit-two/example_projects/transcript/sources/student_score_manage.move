// student score manage
module sui_intro_unit_two::student_score_manage {
    use sui::object::{Self, ID, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::event;
    use std::string;

    const NO_POWER_CODE: u64 = 401;

    /// student obj
    struct StudentInfo has key {
        id: UID,
        name: string::String,
        sex: u8
    }

    /// course info
    struct CourseInfo has key {
        id: UID,
        name: string::String
    }

    /// score info
    struct ScoreInfo has key {
        id: UID,
        stuId: ID,
        courseId: ID,
        score: u8
    }
    struct AdminPower has key {
        id: UID
    }
    /// operate data power
    struct OperatePower has key {
        id: UID,
        type: u8
    }

    /// init
    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminPower{
                id: object::new(ctx)
            }, tx_context::sender(ctx)
        )
    }

    // add student event
    struct AddStudentEvent has copy,drop {
        bizId: ID,
        name: string::String,
        sex: u8,
        requestAddr: address
    }

    // add student info
    public entry fun addStudent(ctx: &mut TxContext,power:&OperatePower,name:string::String,sex:u8,stuAddr:address) {
        assert!(power.type==0||power.type==1,NO_POWER_CODE);
        let studentObject = StudentInfo{
            id: object::new(ctx),
            name: name,
            sex: sex
        };
        
        // create event
        event::emit(
            AddStudentEvent {
                bizId: object::uid_to_inner(&studentObject.id),
                name: name,
                sex: sex,
                requestAddr: tx_context::sender(ctx)
            });
        transfer::transfer(
            studentObject,stuAddr
        );
    }
}