module Parser

using  Main.Tokenizer

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

struct INULL <: Instruction
end

t_index = 1

function parse_push(tokens)
    global t_index
    vartype = if tokens[t_index + 1].token_type == Tokenizer.VARTYPE
        tokens[t_index+1].token_value
    else
        error("ParseError: illegal arguments for PUSH")
    end
    value = if tokens[t_index + 2].token_type == Tokenizer.INTEGER || tokens[t_index + 1].token_type == Tokenizer.CHAR
        parse(Int64, (tokens[t_index+2].token_value))
    else
       error("ParseError: illegal arguments for PUSH")
    end
    t_index +=  2
    return IPUSH(VarType(vartype), value)
end

function parse_pop(tokens)
    global t_index
    vartype = if typeof(tokens[t_index+1]) == Tokenizer.VARTYPE
        tokens[t_index+1].token_value
    else
        error("ParseError: illegal arguments for PUSH")
    end
    value = if tokens[t_index+2].token_type == Tokenizer.INTEGER || tokens[t_index + 2].token_type == Tokenizer.81CHAR
        parse(Int64, (tokens[t_index + 2].token_value))
    else
       error("ParseError: illegal arguments for PUSH")
    end
    t_index +=  2
    return IPOP(VarType(vartype), value)
end

function parse_add(tokens)
    return IADD()
end

function parseNext(tokens)
    global t_index
    while(t_index <= length(tokens))
        if tokens[t_index].token_type == Tokenizer.PUSH
            token = parse_push(tokens)
            t_index += 1
            return token
        elseif tokens[t_index].token_type == Tokenizer.POP
            token = parse_pop(tokens)
            t_index += 1
            return token
        elseif tokens[t_index].token_type == Tokenizer.ADD
            token = parse_add(tokens)
            t_index += 1
            return token
        else
            error("Parser: Illegal instruction $(tokens[t_index])")
        end
    end
    INULL()
end

function main(tokens::Vector{Token})::Vector{Instruction}
    instructions = Instruction[]
    instruction = parseNext(tokens)
    while typeof(instruction) != INULL
        push!(instructions, instruction)
        instruction = parseNext(tokens)
    end
    @show instructions
    return instructions
end

end
