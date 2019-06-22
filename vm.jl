@enum TokenType begin
    PUSH
    POP
    ADD
    CONSTANT
    INTEGER
    CHAR
    EOF
    NULL
end

struct Token
    tokentype::TokenType
    value::String
end

source_file = ARGS[1]
source = open(source_file) do f
    read(f, String)
end

line_index = 1
char_index = 1

function read_next()
    token_value = ""
    token_type = NULL

    global char_index
    while(char_index <= length(source))
        if isspace(source[char_index])
            if(source[char_index] == '\n')
                line_index += 1
            end
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
                elseif token_type == NULL
                   @error "Tokenizer: Unrecognized token $token_value at $(line_index):$(char_index)"
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
    token_type == NULL && (token_type = EOF)
    return Token(token_type, token_value)
end

function main()
    token_list = []
    token = read_next()
    @show token
    while(!(token.tokentype == EOF))
        push!(token_list, token)
        token = read_next()
        @show token
    end
    @info token_list
end
main()
