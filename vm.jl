TOKENS = []
@enum TokenType begin
    PUSH
    POP
    ADD
    CONSTANT
    INTEGER
    CHAR
    EOF
end

struct Token
    tokentype::TokenType
    value::String
end

source_file = ARGS[1]
source = open(source_file) do f
    readchomp(f)
end

line_index = 1
char_index = 1

function read_next()
    token_value = ""
    token_type = EOF
    global char_index
    while(char_index <= length(source))
        if isspace(source[char_index])
            if isempty(token_value)
                char_index += 1;
                continue
           else
                if token_value == "push"
                    token_type = PUSH
                elseif token_value == "pop"
                    token_type = POP
                elseif token_value == "add"
                    token_type = ADD
                elseif token_value == "constant"
                    token_type = CONSTANT
                end
                char_index += 1;
                return Token(token_type, token_value)
           end
        end

        if isdigit(source[char_index]) && isempty(token_value)
            token_type = INTEGER
        end
        if source[char_index] == '\'' && isempty(token_value)
            token_type = CHAR
        end
        token_value *= source[char_index]
        char_index += 1;
    end

    return Token(token_type, token_value)
end

function main()
    token_list = []
    token = read_next()
    while(!(token.tokentype == EOF))
        push!(token_list, token)
        token = read_next()
    end
    @info token_list
end
main()
