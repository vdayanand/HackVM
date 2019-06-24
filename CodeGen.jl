module CodeGen
import Main.Parser: IPUSH, Instruction, VarType
function codegen(ins::IPUSH)
    bp = if ins.vartype == VarType("local")
        "LCL"
    end
    return """
        // $(ins)
        @$(bp)
        D=A
        @$(ins.value)
        D=D+A
        @SP
        A=M
        M=D
        @SP
        M=M+1
    """
end

function main(ins::Vector{Instruction})::String
    asm_str = ""
    for i in ins
        asm_str *= codegen(i)
        break
    end
    return asm_str
end

end
