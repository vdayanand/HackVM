module Parser

using Tokenizer: Token
struct VarType
    value::String
end

abstract type Instruction
end

struct IPOP <: Instruction
    vartype::VarType
    value::Union{Char, Int64, Nothing}
end

struct IPUSH <: Instruction
    vartype::VarType
    value::Union{Char, Int64, Nothing}
end

struct IADD <: Instruction
end

t_index = 1

function parse_push(tokens)
    vartype = if tokens[t_index + 1].token_type == VARTYPE
        tokens[t_index + 1].token_value
    else
        error("ParseError: illegal arguments for PUSH")
    end
    value = if tokens[t_index + 2].token_type == INTEGER || tokens[t_index + 2].token_type == CHAR
        tokens[t_index + 2].token_value
    else
       error("ParseError: illegal arguments for PUSH")
    end
    return IPUSH(vartype, value)
end

function parse_pop()
    itype = POP
    vartype = if typeof(tokens[t_index + 1]) == VARTYPE
        tokens[t_index + 1].token_value
    else
        error("ParseError: illegal arguments for PUSH")
    end
    value = if tokens[t_index + 2].token_type == INTEGER || tokens[t_index + 2].token_type == CHAR
        tokens[t_index + 1].token_value
    else
       error("ParseError: illegal arguments for PUSH")
    end
    return IPOP(vartype, value)
end

function parse_add(tokens)
    return ADD()
end

function parseNext(tokens)
    global t_index
    while(t_index <= length(tokens))
        if tokens[t_index] == PUSH
            return parse_push(tokens)
        elseif tokens[t_index] == POP
            return parse_pop(tokens)
        elseif tokens[t_index] == ADD
            return parse_add(tokens)
        else
            error("Parser: Illegal instruction $(token[t_index])")
        end
        t_index += 1
    end
end

function main(tokens::Vector{Token})::Vector{Instruction}
    instructions = Instruction[]
    instruction = parseNext(tokens)
    while instruction.itype != NULL
        instruction = parseNext()
        push!(instructions, instruction)
    end
    @info instructrions
    return instructions
end

end
